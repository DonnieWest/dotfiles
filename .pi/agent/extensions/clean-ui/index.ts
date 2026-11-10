import type { AssistantMessage, ToolResultMessage, Usage } from "@earendil-works/pi-ai";
import { basename } from "node:path";
import {
	CustomEditor,
	DynamicBorder,
	type ExtensionAPI,
	type ExtensionContext,
	type KeybindingsManager,
	SessionManager,
	type Theme,
} from "@earendil-works/pi-coding-agent";
import type { EditorTheme, TUI, TuiMouseEvent, TuiMouseEventResult } from "@earendil-works/pi-tui";
import { Container, Key, type SelectItem, SelectList, Text, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const SPINNER_FRAMES = ["·", "•", "●", "•"];

type WorkflowMode = "PLAN" | "BUILD" | "REVIEW";

function relativeTime(date: Date): string {
	const seconds = Math.max(0, Math.floor((Date.now() - date.getTime()) / 1000));
	if (seconds < 60) return "now";
	if (seconds < 3600) return `${Math.floor(seconds / 60)}m ago`;
	if (seconds < 86400) return `${Math.floor(seconds / 3600)}h ago`;
	return `${Math.floor(seconds / 86400)}d ago`;
}

function formatCount(count: number): string {
	if (count < 1000) return `${Math.round(count)}`;
	if (count < 10_000) return `${(count / 1000).toFixed(1)}K`;
	if (count < 1_000_000) return `${Math.round(count / 1000)}K`;
	if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
	return `${Math.round(count / 1_000_000)}M`;
}

function formatDuration(milliseconds: number): string {
	if (milliseconds < 1000) return `${Math.max(1, Math.round(milliseconds))}ms`;
	return `${(milliseconds / 1000).toFixed(1)}s`;
}

function titleCase(value: string): string {
	return value
		.split(/[-_\s]+/)
		.filter(Boolean)
		.map((part) => part.charAt(0).toUpperCase() + part.slice(1))
		.join(" ");
}

function providerName(provider: string | undefined): string {
	if (!provider) return "No provider";
	if (provider === "github-copilot") return "GitHub Copilot";
	if (provider === "vertex-claude") return "Vertex AI";
	return titleCase(provider);
}

function modelName(ctx: ExtensionContext): string {
	return ctx.model?.name || ctx.model?.id || "No model";
}

function modeName(mode: WorkflowMode): string {
	return mode.charAt(0) + mode.slice(1).toLowerCase();
}

function joinSides(left: string, right: string, width: number): string {
	if (width <= 0) return "";
	if (!right) return truncateToWidth(left, width, "");
	if (!left) return truncateToWidth(right, width, "");

	const gap = Math.max(1, width - visibleWidth(left) - visibleWidth(right));
	if (visibleWidth(left) + visibleWidth(right) + gap <= width) {
		return left + " ".repeat(gap) + right;
	}

	const rightWidth = Math.min(visibleWidth(right), Math.max(0, Math.floor(width * 0.52)));
	const fittedRight = truncateToWidth(right, rightWidth, "");
	const leftWidth = Math.max(0, width - visibleWidth(fittedRight) - 1);
	return `${truncateToWidth(left, leftWidth, "")} ${fittedRight}`;
}

function addUsage(total: { cost: number }, usage: Usage | undefined): void {
	if (usage) total.cost += usage.cost.total;
}

function sessionCost(ctx: ExtensionContext): number {
	const total = { cost: 0 };
	for (const entry of ctx.sessionManager.getEntries()) {
		if (entry.type === "usage") {
			addUsage(total, entry.usage);
		} else if (entry.type === "message" && entry.message.role === "assistant") {
			addUsage(total, (entry.message as AssistantMessage).usage);
		} else if (entry.type === "message" && entry.message.role === "toolResult") {
			addUsage(total, (entry.message as ToolResultMessage).usage);
		} else if ((entry.type === "branch_summary" || entry.type === "compaction") && entry.usage) {
			addUsage(total, entry.usage);
		}
	}
	return total.cost;
}

function quoteUserMarkdown(markdown: string): string {
	return markdown
		.split("\n")
		.map((line) => (line.length > 0 ? `> ${line}` : ">"))
		.join("\n");
}

function applyBackground(theme: Theme, text: string): string {
	const marker = "\u0000";
	const styledMarker = theme.bg("selectedBg", marker);
	const markerIndex = styledMarker.indexOf(marker);
	if (markerIndex < 0) return theme.bg("selectedBg", text);
	const prefix = styledMarker.slice(0, markerIndex);
	const suffix = styledMarker.slice(markerIndex + marker.length);
	return `${prefix}${text.replaceAll("\x1b[0m", `\x1b[0m${prefix}`)}${suffix}`;
}

export default function cleanUiExtension(pi: ExtensionAPI): void {
	let enabled = true;
	let isWorking = false;
	let spinnerIndex = 0;
	let spinnerTimer: ReturnType<typeof setInterval> | undefined;
	let activeTui: TUI | undefined;
	let workflowMode: WorkflowMode = "BUILD";
	let activeTool: string | undefined;
	let turnStartedAt: number | undefined;
	let lastTurnDuration: number | undefined;

	function stopSpinner(): void {
		if (spinnerTimer) clearInterval(spinnerTimer);
		spinnerTimer = undefined;
	}

	function modeColor(): "warning" | "success" | "accent" {
		if (workflowMode === "PLAN") return "warning";
		if (workflowMode === "REVIEW") return "success";
		return "accent";
	}

	function applyUi(ctx: ExtensionContext): void {
		if (ctx.mode !== "tui") return;

		ctx.ui.setTitle(`pi — ${basename(ctx.cwd)}`);
		ctx.ui.setToolsExpanded(false);
		ctx.ui.setWorkingVisible(false);

		ctx.ui.setHeader(() => ({
			invalidate() {},
			render(): string[] {
				return [];
			},
		}));

		ctx.ui.setWidget(
			"opencode-turn-status",
			(_tui, theme) => ({
				invalidate() {},
				render(width: number): string[] {
					if (lastTurnDuration === undefined && !isWorking) return [];
					const marker = theme.fg(modeColor(), isWorking ? SPINNER_FRAMES[spinnerIndex] : "▣");
					const mode = theme.fg("text", modeName(workflowMode));
					const detail = isWorking
						? theme.fg("dim", ` · ${activeTool ?? "working"}`)
						: theme.fg("dim", ` · ${modelName(ctx)} · ${formatDuration(lastTurnDuration ?? 0)}`);
					return [truncateToWidth(`     ${marker}  ${mode}${detail}`, width, ""), ""];
				},
			}),
			{ placement: "aboveEditor" },
		);

		ctx.ui.setFooter((_tui, theme) => ({
			invalidate() {},
			render(width: number): string[] {
				const usage = ctx.getContextUsage();
				const tokens = usage?.tokens === null || usage?.tokens === undefined ? "—" : formatCount(usage.tokens);
				const percent = usage?.percent === null || usage?.percent === undefined ? "?" : `${Math.round(usage.percent)}%`;
				const cost = sessionCost(ctx);
				const left = theme.fg("dim", `   ${ctx.cwd}`);
				const stats = theme.fg("dim", `${tokens} (${percent}) · $${cost.toFixed(2)}`);
				const detailsShortcut = `${theme.fg("text", "ctrl+o")} ${theme.fg("dim", "details")}`;
				const commandsShortcut = `${theme.fg("text", "ctrl+p")} ${theme.fg("dim", "commands")}`;
				let right = detailsShortcut;
				if (width >= 60) right = `${detailsShortcut}  ${commandsShortcut}`;
				if (width >= 85) right = `${stats}  ${right}`;
				return [joinSides(left, right, width)];
			},
		}));

		class OpenCodeEditor extends CustomEditor {
			private syntheticStart = -1;
			private syntheticCount = 0;

			constructor(tui: TUI, theme: EditorTheme, keybindings: KeybindingsManager) {
				super(tui, theme, keybindings, { paddingX: 2 });
				activeTui = tui;
			}

			protected renderTopBorder(width: number, hiddenLineCount: number): string {
				const label = hiddenLineCount > 0 ? ` ↑ ${hiddenLineCount} more` : "";
				const rail = ctx.ui.theme.fg(modeColor(), "┃");
				return `${rail}${ctx.ui.theme.fg("dim", truncateToWidth(label, Math.max(0, width - 1), ""))}${" ".repeat(
					Math.max(0, width - 1 - visibleWidth(label)),
				)}`;
			}

			protected renderBottomBorder(width: number, hiddenLineCount: number): string {
				if (width <= 0) return "";
				const label = hiddenLineCount > 0 ? ` ↓ ${hiddenLineCount} more ` : "";
				const fill = label
					? truncateToWidth(label + "▀".repeat(width), Math.max(0, width - 1), "")
					: "▀".repeat(Math.max(0, width - 1));
				return ctx.ui.theme.fg(modeColor(), "╹") + ctx.ui.theme.fg("borderMuted", fill);
			}

			render(width: number): string[] {
				const lines = super.render(width);
				if (lines.length < 2) return lines;

				const bottomIndex = lines.findIndex((line) => line.includes("╹"));
				if (bottomIndex < 0) return lines;

				const theme = ctx.ui.theme;
				for (let index = 1; index < bottomIndex; index++) {
					const line = lines[index] ?? "";
					const content = line.startsWith("  ") ? line.slice(2) : line;
					const row = truncateToWidth(`${theme.fg(modeColor(), "┃")} ${content}`, width, "");
					lines[index] = applyBackground(theme, row);
				}
				lines[0] = applyBackground(theme, truncateToWidth(lines[0] ?? "", width, ""));

				const paddingRows = Math.max(0, 3 - bottomIndex);
				const blank = applyBackground(theme, `${theme.fg(modeColor(), "┃")}${" ".repeat(Math.max(0, width - 1))}`);
				const status = applyBackground(
					theme,
					truncateToWidth(
						`${theme.fg(modeColor(), "┃")}  ${theme.fg(modeColor(), modeName(workflowMode))} ${theme.fg("dim", "·")} ${theme.fg(
							"text",
							modelName(ctx),
						)} ${theme.fg("dim", providerName(ctx.model?.provider))}${" ".repeat(width)}`,
						width,
						"",
					),
				);
				const inserted = [...Array<string>(paddingRows).fill(blank), status];
				this.syntheticStart = bottomIndex;
				this.syntheticCount = inserted.length;
				lines.splice(bottomIndex, 0, ...inserted);
				return lines;
			}

			handleMouse(event: TuiMouseEvent): TuiMouseEventResult | undefined {
				if (this.syntheticStart >= 0 && event.y >= this.syntheticStart) {
					if (event.y < this.syntheticStart + this.syntheticCount) {
						return { handled: true, focus: true };
					}
					return super.handleMouse({ ...event, y: event.y - this.syntheticCount });
				}
				return super.handleMouse(event);
			}
		}

		ctx.ui.setEditorComponent((tui, theme, keybindings) => new OpenCodeEditor(tui, theme, keybindings));
	}

	function restoreUi(ctx: ExtensionContext): void {
		stopSpinner();
		isWorking = false;
		ctx.ui.setWidget("opencode-turn-status", undefined);
		ctx.ui.setHeader(undefined);
		ctx.ui.setFooter(undefined);
		ctx.ui.setEditorComponent(undefined);
		ctx.ui.setWorkingVisible(true);
		ctx.ui.setTitle("pi");
	}

	pi.registerMarkdownTransformer((markdown, context) => {
		if (!enabled || context.messageType !== "user") return markdown;
		return quoteUserMarkdown(markdown);
	});

	pi.registerCommand("sessions", {
		description: "List and switch between sessions",
		handler: async (_args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("The session sidebar requires interactive mode.", "error");
				return;
			}

			const sessions = await SessionManager.list(ctx.cwd);
			sessions.sort((a, b) => b.modified.getTime() - a.modified.getTime());
			if (sessions.length === 0) {
				ctx.ui.notify("No saved sessions for this project.", "info");
				return;
			}

			const currentFile = ctx.sessionManager.getSessionFile();
			const items: SelectItem[] = sessions.map((session) => {
				const current = session.path === currentFile;
				const fallback = session.firstMessage || "Untitled session";
				return {
					value: session.path,
					label: `${current ? "● " : "  "}${session.name || truncateToWidth(fallback, 44, "…")}`,
					description: `${relativeTime(session.modified)} · ${session.messageCount} messages`,
				};
			});

			const selected = await ctx.ui.custom<string | undefined>(
				(tui, theme, _keybindings, done) => {
					const container = new Container();
					container.addChild(new DynamicBorder((text: string) => theme.fg("accent", text)));
					container.addChild(new Text(theme.fg("accent", theme.bold(" Sessions ")), 1, 0));
					container.addChild(new Text(theme.fg("dim", ` ${basename(ctx.cwd)} · ${sessions.length} saved `), 1, 0));
					const list = new SelectList(items, Math.min(items.length, 16), {
						selectedPrefix: (text) => theme.fg("accent", text),
						selectedText: (text) => theme.fg("accent", text),
						description: (text) => theme.fg("muted", text),
						scrollInfo: (text) => theme.fg("dim", text),
						noMatch: (text) => theme.fg("warning", text),
					});
					list.onSelect = (item) => done(item.value);
					list.onCancel = () => done(undefined);
					container.addChild(list);
					container.addChild(new Text(theme.fg("dim", " type to filter · enter open · esc close "), 1, 0));
					container.addChild(new DynamicBorder((text: string) => theme.fg("border", text)));
					return {
						render: (width) => container.render(width),
						invalidate: () => container.invalidate(),
						handleInput: (data) => {
							list.handleInput(data);
							tui.requestRender();
						},
					};
				},
				{
					overlay: true,
					overlayOptions: { anchor: "right-center", width: "48%", minWidth: 44, maxHeight: "85%", margin: 1 },
				},
			);

			if (selected && selected !== currentFile) await ctx.switchSession(selected);
		},
	});

	pi.registerShortcut(Key.ctrlAlt("s"), {
		description: "Open session sidebar",
		handler: async (ctx) => {
			if (!ctx.isIdle()) {
				ctx.ui.notify("Wait for the current turn before switching sessions.", "info");
				return;
			}
			pi.sendUserMessage("/sessions", { expandPromptTemplates: true });
		},
	});

	pi.registerCommand("clean-ui", {
		description: "Toggle the OpenCode-style interface",
		handler: async (_args, ctx) => {
			enabled = !enabled;
			if (enabled) {
				applyUi(ctx);
				ctx.ui.notify("OpenCode-style UI enabled", "info");
			} else {
				restoreUi(ctx);
				ctx.ui.notify("Built-in UI restored", "info");
			}
		},
	});

	pi.events.on("plan-mode:state", (state) => {
		const next = state as { mode?: string };
		workflowMode = "BUILD";
		if (next.mode === "plan") workflowMode = "PLAN";
		if (next.mode === "review") workflowMode = "REVIEW";
		activeTui?.requestRender();
	});

	pi.on("session_start", (_event, ctx) => {
		workflowMode = "BUILD";
		activeTool = undefined;
		turnStartedAt = undefined;
		lastTurnDuration = undefined;
		if (enabled) applyUi(ctx);
	});

	pi.on("tool_execution_start", (event) => {
		activeTool = event.toolName;
		activeTui?.requestRender();
	});

	pi.on("tool_execution_end", () => {
		activeTool = undefined;
		activeTui?.requestRender();
	});

	pi.on("model_select", () => activeTui?.requestRender());
	pi.on("thinking_level_select", () => activeTui?.requestRender());

	pi.on("agent_start", () => {
		if (!enabled) return;
		isWorking = true;
		turnStartedAt = performance.now();
		stopSpinner();
		spinnerTimer = setInterval(() => {
			spinnerIndex = (spinnerIndex + 1) % SPINNER_FRAMES.length;
			activeTui?.requestRender();
		}, 120);
		activeTui?.requestRender();
	});

	pi.on("agent_settled", () => {
		isWorking = false;
		if (turnStartedAt !== undefined) lastTurnDuration = performance.now() - turnStartedAt;
		turnStartedAt = undefined;
		stopSpinner();
		activeTui?.requestRender();
	});

	pi.on("session_shutdown", () => {
		stopSpinner();
		activeTui = undefined;
	});
}
