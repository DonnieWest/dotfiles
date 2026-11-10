import type { AgentMessage } from "@earendil-works/pi-agent-core";
import { type Message, uuidv7 } from "@earendil-works/pi-ai";
import {
	BorderedLoader,
	convertToLlm,
	type ExtensionAPI,
	type SessionEntry,
	serializeConversation,
} from "@earendil-works/pi-coding-agent";

const SYSTEM_PROMPT = `You create self-contained handoff prompts for a fresh coding-agent session.

Include only context relevant to the requested next task:
- decisions and constraints already established
- key findings and unresolved questions
- files discussed or modified
- implementation and verification state
- the exact next objective and acceptance criteria

Use sections named Context, Decisions, Relevant files, Current state, and Task. Clearly distinguish verified facts from assumptions. Do not include conversational filler or say that you are generating a prompt.`;

function entryToMessage(entry: SessionEntry): AgentMessage | undefined {
	if (entry.type === "message") return entry.message;
	if (entry.type === "compaction") {
		return {
			role: "compactionSummary",
			summary: entry.summary,
			tokensBefore: entry.tokensBefore,
			timestamp: new Date(entry.timestamp).getTime(),
		};
	}
	return undefined;
}

function handoffMessages(branch: SessionEntry[]): AgentMessage[] {
	let compactionIndex = -1;
	for (let index = branch.length - 1; index >= 0; index -= 1) {
		if (branch[index]?.type === "compaction") {
			compactionIndex = index;
			break;
		}
	}
	if (compactionIndex < 0) return branch.flatMap((entry) => entryToMessage(entry) ?? []);

	const compaction = branch[compactionIndex];
	const firstKeptIndex =
		compaction?.type === "compaction" ? branch.findIndex((entry) => entry.id === compaction.firstKeptEntryId) : -1;
	const compacted = [
		compaction,
		...(firstKeptIndex >= 0 ? branch.slice(firstKeptIndex, compactionIndex) : []),
		...branch.slice(compactionIndex + 1),
	].filter((entry): entry is SessionEntry => entry !== undefined);
	return compacted.flatMap((entry) => entryToMessage(entry) ?? []);
}

export default function handoffExtension(pi: ExtensionAPI): void {
	pi.registerCommand("handoff", {
		description: "Generate a focused prompt and continue in a fresh linked session",
		handler: async (args, ctx) => {
			if (ctx.mode !== "tui" || !ctx.model) {
				ctx.ui.notify("Handoff requires interactive mode and an active model.", "error");
				return;
			}
			const goal = args.trim();
			if (!goal) {
				ctx.ui.notify("Usage: /handoff <goal for the new session>", "error");
				return;
			}

			const messages = handoffMessages(ctx.sessionManager.getBranch());
			if (messages.length === 0) {
				ctx.ui.notify("There is no conversation to hand off.", "error");
				return;
			}
			const conversation = serializeConversation(convertToLlm(messages));
			const model = ctx.model;
			const generated = await ctx.ui.custom<string | undefined>((tui, theme, _keybindings, done) => {
				const loader = new BorderedLoader(tui, theme, "Generating focused handoff…");
				loader.onAbort = () => done(undefined);
				const message: Message = {
					role: "user",
					content: [{ type: "text", text: `Conversation:\n${conversation}\n\nNew-session goal:\n${goal}` }],
					timestamp: Date.now(),
				};
				ctx.modelRegistry
					.complete(model, { systemPrompt: SYSTEM_PROMPT, messages: [message] }, {
						signal: loader.signal,
						cacheRetention: "none",
						sessionId: uuidv7(),
					})
					.then((response) => {
						if (response.stopReason === "aborted") return done(undefined);
						done(response.content.flatMap((part) => (part.type === "text" ? [part.text] : [])).join("\n"));
					})
					.catch((error) => {
						ctx.ui.notify(`Handoff generation failed: ${error instanceof Error ? error.message : String(error)}`, "error");
						done(undefined);
					});
				return loader;
			});
			if (!generated) {
				ctx.ui.notify("Handoff cancelled.", "info");
				return;
			}

			const edited = await ctx.ui.editor("Review handoff prompt", generated);
			if (edited === undefined) return;
			const action = await ctx.ui.select("Fresh session", ["Open as draft", "Open and execute"]);
			if (!action) return;

			const parentSession = ctx.sessionManager.getSessionFile();
			await ctx.newSession({
				parentSession,
				withSession: async (replacementCtx) => {
					if (action === "Open and execute") {
						await replacementCtx.sendUserMessage(edited);
					} else {
						replacementCtx.ui.setEditorText(edited);
						replacementCtx.ui.notify("Handoff ready for review.", "info");
					}
				},
			});
		},
	});
}
