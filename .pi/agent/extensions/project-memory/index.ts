import { appendFile, mkdir, readFile } from "node:fs/promises";
import { createHash, randomUUID } from "node:crypto";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import type { AgentMessage } from "@earendil-works/pi-agent-core";
import { StringEnum } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

interface MemoryRecord {
	id: string;
	text: string;
	tags: string[];
	createdAt: string;
	project: string;
	sessionId?: string;
}

type MemoryEvent = { op: "retain"; memory: MemoryRecord } | { op: "forget"; id: string; at: string };

const SECRET_PATTERN = /(?:api[_-]?key|secret|token|password|private[_-]?key|authorization)\s*[:=]\s*\S+/i;
const STOP_WORDS = new Set(["about", "after", "again", "also", "and", "are", "for", "from", "have", "into", "that", "the", "this", "with"]);

function memoryPath(cwd: string): string {
	const key = createHash("sha256").update(cwd).digest("hex").slice(0, 16);
	return join(process.env.PI_CODING_AGENT_DIR || join(homedir(), ".pi", "agent"), "memory", `${key}.jsonl`);
}

function terms(text: string): Set<string> {
	return new Set(
		text
			.toLowerCase()
			.split(/[^a-z0-9]+/)
			.filter((word) => word.length > 2 && !STOP_WORDS.has(word)),
	);
}

async function loadMemories(cwd: string): Promise<MemoryRecord[]> {
	let content = "";
	try {
		content = await readFile(memoryPath(cwd), "utf8");
	} catch (error) {
		if ((error as NodeJS.ErrnoException).code === "ENOENT") return [];
		throw error;
	}

	const active = new Map<string, MemoryRecord>();
	for (const line of content.split("\n")) {
		if (!line.trim()) continue;
		try {
			const event = JSON.parse(line) as MemoryEvent;
			if (event.op === "retain") active.set(event.memory.id, event.memory);
			if (event.op === "forget") active.delete(event.id);
		} catch {
			// Ignore a malformed line while preserving the rest of the append-only store.
		}
	}
	return [...active.values()].sort((a, b) => b.createdAt.localeCompare(a.createdAt));
}

async function appendMemoryEvent(cwd: string, event: MemoryEvent): Promise<void> {
	const path = memoryPath(cwd);
	await mkdir(dirname(path), { recursive: true });
	await appendFile(path, `${JSON.stringify(event)}\n`, { encoding: "utf8", mode: 0o600 });
}

function relevantMemories(memories: MemoryRecord[], query: string, limit = 5): MemoryRecord[] {
	const queryTerms = terms(query);
	if (queryTerms.size === 0) return [];
	return memories
		.map((memory) => {
			const memoryTerms = terms(`${memory.text} ${memory.tags.join(" ")}`);
			let score = 0;
			for (const term of queryTerms) if (memoryTerms.has(term)) score += 1;
			return { memory, score };
		})
		.filter((entry) => entry.score > 0)
		.sort((a, b) => b.score - a.score || b.memory.createdAt.localeCompare(a.memory.createdAt))
		.slice(0, limit)
		.map((entry) => entry.memory);
}

export default function projectMemoryExtension(pi: ExtensionAPI): void {
	async function retain(options: {
		cwd: string;
		text: string;
		tags?: string[];
		sessionId?: string;
	}): Promise<MemoryRecord> {
		const clean = options.text.replace(/\s+/g, " ").trim();
		if (clean.length < 8) throw new Error("Memory is too short to be useful.");
		if (SECRET_PATTERN.test(clean)) throw new Error("Refusing to store text that appears to contain a secret.");
		const memory: MemoryRecord = {
			id: randomUUID().slice(0, 8),
			text: clean,
			tags: (options.tags ?? []).map((tag) => tag.trim().toLowerCase()).filter(Boolean).slice(0, 8),
			createdAt: new Date().toISOString(),
			project: options.cwd,
			sessionId: options.sessionId,
		};
		await appendMemoryEvent(options.cwd, { op: "retain", memory });
		return memory;
	}

	pi.registerTool({
		name: "project_memory",
		label: "Project Memory",
		description: "Explicitly retain, recall, list, or forget durable project-scoped facts. Never store secrets.",
		promptSnippet: "Retain or retrieve durable project facts when the user explicitly asks",
		promptGuidelines: [
			"Use project_memory retain only when the user explicitly asks to remember a durable project fact; never retain secrets, transient task state, guesses, or raw conversation summaries.",
			"Treat recalled project_memory entries as potentially stale hints and verify them against the repository before relying on them.",
		],
		parameters: Type.Object({
			action: StringEnum(["retain", "recall", "list", "forget"] as const),
			text: Type.Optional(Type.String()),
			query: Type.Optional(Type.String()),
			id: Type.Optional(Type.String()),
			tags: Type.Optional(Type.Array(Type.String())),
			limit: Type.Optional(Type.Integer({ minimum: 1, maximum: 20 })),
		}),
		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			if (params.action === "retain") {
				if (!params.text) throw new Error("text is required for retain");
				const memory = await retain({
					cwd: ctx.cwd,
					text: params.text,
					tags: params.tags,
					sessionId: ctx.sessionManager.getSessionId(),
				});
				return { content: [{ type: "text", text: `Remembered ${memory.id}: ${memory.text}` }], details: { memory } };
			}

			const memories = await loadMemories(ctx.cwd);
			if (params.action === "forget") {
				if (!params.id) throw new Error("id is required for forget");
				if (!memories.some((memory) => memory.id === params.id)) throw new Error(`Unknown memory id: ${params.id}`);
				await appendMemoryEvent(ctx.cwd, { op: "forget", id: params.id, at: new Date().toISOString() });
				return { content: [{ type: "text", text: `Forgot memory ${params.id}.` }], details: { id: params.id } };
			}

			const selected = params.action === "recall"
				? relevantMemories(memories, params.query ?? "", params.limit ?? 5)
				: memories.slice(0, params.limit ?? 20);
			let text = "No matching project memories.";
			if (selected.length > 0) {
				text = selected
					.map((memory) => {
						const tags = memory.tags.length > 0 ? ` #${memory.tags.join(" #")}` : "";
						return `[${memory.id}] ${memory.text}${tags}`;
					})
					.join("\n");
			}
			return { content: [{ type: "text", text }], details: { memories: selected } };
		},
	});

	pi.registerCommand("remember", {
		description: "Store an explicit project memory",
		handler: async (args, ctx) => {
			if (!args.trim()) {
				ctx.ui.notify("Usage: /remember <durable project fact>", "error");
				return;
			}
			try {
				const memory = await retain({ cwd: ctx.cwd, text: args, sessionId: ctx.sessionManager.getSessionId() });
				ctx.ui.notify(`Remembered ${memory.id}.`, "info");
			} catch (error) {
				ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
			}
		},
	});

	pi.registerCommand("memories", {
		description: "List project memories",
		handler: async (_args, ctx) => {
			const memories = await loadMemories(ctx.cwd);
			ctx.ui.notify(
				memories.length ? memories.slice(0, 20).map((memory) => `[${memory.id}] ${memory.text}`).join("\n") : "No project memories.",
				"info",
			);
		},
	});

	pi.registerCommand("forget", {
		description: "Forget a project memory by id",
		handler: async (args, ctx) => {
			const id = args.trim();
			if (!id) {
				ctx.ui.notify("Usage: /forget <memory-id>", "error");
				return;
			}
			await appendMemoryEvent(ctx.cwd, { op: "forget", id, at: new Date().toISOString() });
			ctx.ui.notify(`Forgot memory ${id}.`, "info");
		},
	});

	pi.on("before_agent_start", async (event) => {
		const recalled = relevantMemories(await loadMemories(event.systemPromptOptions.cwd), event.prompt, 5);
		if (recalled.length === 0) return;
		return {
			message: {
				customType: "project-memory-context",
				content: `Potentially relevant project memories (verify before relying on them):\n${recalled.map((memory) => `- [${memory.id}] ${memory.text}`).join("\n")}`,
				display: false,
			},
		};
	});

	pi.on("context", (event) => {
		let latest = -1;
		for (let index = event.messages.length - 1; index >= 0; index -= 1) {
			const message = event.messages[index] as AgentMessage & { customType?: string };
			if (message.customType === "project-memory-context") {
				latest = index;
				break;
			}
		}
		return {
			messages: event.messages.filter((message, index) => {
				const candidate = message as AgentMessage & { customType?: string };
				return candidate.customType !== "project-memory-context" || index === latest;
			}),
		};
	});
}
