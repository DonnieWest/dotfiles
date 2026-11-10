import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const READ_TOOLS = new Set([
	"read",
	"grep",
	"find",
	"ls",
	"question",
	"web_search",
	"source_check",
	"fetch_content",
	"get_search_content",
	"lens_diagnostics",
	"lsp_diagnostics",
	"symbol_search",
	"project_report",
	"module_report",
	"read_symbol",
	"read_enclosing",
]);
const WRITE_TOOLS = new Set(["edit", "write", "ast_grep_replace"]);

type ApprovalMode = "always-ask" | "write" | "yolo";
type ToolTier = "read" | "write" | "exec";

interface ApprovalState {
	mode: ApprovalMode;
	allowedTools: string[];
}

function classifyTool(name: string): ToolTier {
	if (READ_TOOLS.has(name)) return "read";
	if (WRITE_TOOLS.has(name)) return "write";
	return "exec";
}

function previewInput(input: unknown): string {
	if (!input || typeof input !== "object") return "";
	const record = input as Record<string, unknown>;
	for (const key of ["command", "path", "query", "action", "task"]) {
		const value = record[key];
		if (typeof value === "string" && value.trim()) {
			const compact = value.replace(/\s+/g, " ").trim();
			return compact.length > 300 ? `${compact.slice(0, 299)}…` : compact;
		}
	}
	return "";
}

export default function approvalModeExtension(pi: ExtensionAPI): void {
	let mode: ApprovalMode = "yolo";
	const allowedTools = new Set<string>();

	function updateStatus(ctx: ExtensionContext): void {
		pi.events.emit("approval-mode:state", { mode });
		if (mode === "yolo") {
			ctx.ui.setStatus("approval-mode", undefined);
			return;
		}
		const color = mode === "always-ask" ? "warning" : "accent";
		ctx.ui.setStatus("approval-mode", ctx.ui.theme.fg(color, `◆ ${mode}`));
	}

	function persist(): void {
		pi.appendEntry("approval-mode", { mode, allowedTools: [...allowedTools] } satisfies ApprovalState);
	}

	pi.registerCommand("approval", {
		description: "Set tool approval mode: ask, write, yolo, reset, or status",
		handler: async (args, ctx) => {
			const requested = args.trim().toLowerCase();
			if (!requested || requested === "status") {
				ctx.ui.notify(`Approval mode: ${mode}\nSession allowances: ${[...allowedTools].join(", ") || "none"}`, "info");
				return;
			}
			if (requested === "reset") {
				allowedTools.clear();
				updateStatus(ctx);
				persist();
				ctx.ui.notify("Session tool allowances cleared.", "info");
				return;
			}

			let nextMode: ApprovalMode | undefined;
			if (requested === "ask") nextMode = "always-ask";
			if (requested === "write" || requested === "yolo") nextMode = requested;
			if (!nextMode) {
				ctx.ui.notify("Usage: /approval [ask|write|yolo|reset|status]", "error");
				return;
			}
			mode = nextMode;
			allowedTools.clear();
			updateStatus(ctx);
			persist();
			ctx.ui.notify(`Approval mode set to ${mode}.`, "info");
		},
	});

	pi.on("tool_call", async (event, ctx) => {
		const tier = classifyTool(event.toolName);
		let shouldPrompt = false;
		if (mode === "always-ask") shouldPrompt = tier !== "read";
		if (mode === "write") shouldPrompt = tier === "exec";
		if (!shouldPrompt || allowedTools.has(event.toolName)) return;
		if (!ctx.hasUI) return { block: true, reason: `${event.toolName} requires approval in ${mode} mode` };

		const detail = previewInput(event.input);
		const choice = await ctx.ui.select(`Allow ${tier} tool: ${event.toolName}?`, [
			"Allow once",
			`Allow ${event.toolName} for this session`,
			"Deny",
		]);
		if (choice?.startsWith("Allow ") && choice.includes("session")) {
			allowedTools.add(event.toolName);
			persist();
			return;
		}
		if (choice === "Allow once") return;
		return { block: true, reason: `User denied ${event.toolName}${detail ? `: ${detail}` : ""}` };
	});

	pi.on("session_start", (_event, ctx) => {
		const latest = ctx.sessionManager
			.getBranch()
			.filter((entry) => entry.type === "custom" && entry.customType === "approval-mode")
			.at(-1);
		if (latest?.type === "custom") {
			const state = latest.data as Partial<ApprovalState> | undefined;
			if (state?.mode === "always-ask" || state?.mode === "write" || state?.mode === "yolo") mode = state.mode;
			allowedTools.clear();
			for (const tool of state?.allowedTools ?? []) allowedTools.add(tool);
		}
		updateStatus(ctx);
	});
}
