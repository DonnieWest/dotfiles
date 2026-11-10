/**
 * Plan Mode Extension
 *
 * Read-only exploration mode for safe code analysis.
 * When enabled, built-in write tools are disabled.
 *
 * Features:
 * - /plan command or Shift+Tab to toggle
 * - Bash restricted to allowlisted read-only commands
 * - Extracts numbered plan steps from "Plan:" sections
 * - Can execute approved plans in a fresh linked session
 * - [DONE:n] markers to complete steps during execution
 * - Progress tracking widget during execution
 */

import type { AgentMessage } from "@earendil-works/pi-agent-core";
import type { AssistantMessage, TextContent } from "@earendil-works/pi-ai";
import { type ExtensionAPI, type ExtensionContext } from "@earendil-works/pi-coding-agent";
import { extractTodoItems, isSafeCommand, markCompletedSteps, type TodoItem } from "./utils.ts";

// Tools
const PLAN_MODE_TOOLS = ["read", "bash", "grep", "find", "ls", "question"];
const NORMAL_MODE_TOOLS = ["read", "bash", "edit", "write", "grep", "find", "ls"];
const PLAN_MODE_DISABLED_TOOLS = new Set<string>(["edit", "write"]);
const PLAN_MANAGED_TOOLS = new Set<string>([...PLAN_MODE_TOOLS, ...NORMAL_MODE_TOOLS]);

interface PlanModeState {
	enabled: boolean;
	reviewing?: boolean;
	todos?: TodoItem[];
	executing?: boolean;
	toolsBeforePlanMode?: string[];
	pendingPlanHandoff?: PendingPlanHandoff;
}

interface PendingPlanHandoff {
	planText: string;
}

const PLAN_HANDOFF_MARKER = "[PI PLAN HANDOFF]";

// Type guard for assistant messages
function isAssistantMessage(m: AgentMessage): m is AssistantMessage {
	return m.role === "assistant" && Array.isArray(m.content);
}

// Extract text content from an assistant message
function getTextContent(message: AssistantMessage): string {
	return message.content.flatMap((block) => (block.type === "text" ? [block.text] : [])).join("\n");
}

export default function planModeExtension(pi: ExtensionAPI): void {
	let planModeEnabled = false;
	let reviewModeEnabled = false;
	let executionMode = false;
	let todoItems: TodoItem[] = [];
	let toolsBeforePlanMode: string[] | undefined;
	let pendingPlanHandoff: PendingPlanHandoff | undefined;

	pi.registerFlag("plan", {
		description: "Start in plan mode (read-only exploration)",
		type: "boolean",
		default: false,
	});

	function updateStatus(ctx: ExtensionContext): void {
		let mode = "idle";
		if (executionMode) mode = "build";
		if (reviewModeEnabled) mode = "review";
		if (planModeEnabled) mode = "plan";
		pi.events.emit("plan-mode:state", {
			mode,
			completed: todoItems.filter((item) => item.completed).length,
			total: todoItems.length,
		});

		// Footer status
		if (executionMode && todoItems.length > 0) {
			const completed = todoItems.filter((t) => t.completed).length;
			ctx.ui.setStatus("plan-mode", ctx.ui.theme.fg("accent", `📋 ${completed}/${todoItems.length}`));
		} else if (planModeEnabled) {
			ctx.ui.setStatus("plan-mode", ctx.ui.theme.fg("warning", "⏸ plan"));
		} else if (reviewModeEnabled) {
			ctx.ui.setStatus("plan-mode", ctx.ui.theme.fg("accent", "◇ review"));
		} else {
			ctx.ui.setStatus("plan-mode", undefined);
		}

		// Widget showing todo list
		if (executionMode && todoItems.length > 0) {
			const lines = todoItems.map((item) => {
				if (item.completed) {
					return (
						ctx.ui.theme.fg("success", "☑ ") + ctx.ui.theme.fg("muted", ctx.ui.theme.strikethrough(item.text))
					);
				}
				return `${ctx.ui.theme.fg("muted", "☐ ")}${item.text}`;
			});
			ctx.ui.setWidget("plan-todos", lines);
		} else {
			ctx.ui.setWidget("plan-todos", undefined);
		}
	}

	function uniqueToolNames(toolNames: string[]): string[] {
		return [...new Set(toolNames)];
	}

	function getPlanModeTools(activeToolNames: string[]): string[] {
		return uniqueToolNames([
			...activeToolNames.filter((name) => !PLAN_MODE_DISABLED_TOOLS.has(name)),
			...PLAN_MODE_TOOLS,
		]);
	}

	function getNormalModeTools(activeToolNames: string[]): string[] {
		return uniqueToolNames([
			...NORMAL_MODE_TOOLS,
			...activeToolNames.filter((name) => !PLAN_MANAGED_TOOLS.has(name)),
		]);
	}

	function enablePlanModeTools(): void {
		if (toolsBeforePlanMode === undefined) {
			toolsBeforePlanMode = pi.getActiveTools();
		}
		pi.setActiveTools(getPlanModeTools(toolsBeforePlanMode));
	}

	function restoreNormalModeTools(): void {
		pi.setActiveTools(toolsBeforePlanMode ?? getNormalModeTools(pi.getActiveTools()));
		toolsBeforePlanMode = undefined;
	}

	function persistState(): void {
		pi.appendEntry("plan-mode", {
			enabled: planModeEnabled,
			reviewing: reviewModeEnabled,
			todos: todoItems,
			executing: executionMode,
			toolsBeforePlanMode,
			pendingPlanHandoff,
		});
	}

	function buildExecutionPrompt(planText: string): string {
		return `${PLAN_HANDOFF_MARKER}

## Approved plan

${planText}

## Task

Execute the approved plan in this fresh session. Reinspect the repository where needed, implement each step in order, and run the narrowest relevant verification. After completing a numbered step, include a [DONE:n] marker in your response so progress can be tracked.`;
	}

	function togglePlanMode(ctx: ExtensionContext): void {
		planModeEnabled = !planModeEnabled;
		reviewModeEnabled = false;
		executionMode = false;
		todoItems = [];
		pendingPlanHandoff = undefined;

		if (planModeEnabled) {
			enablePlanModeTools();
			ctx.ui.notify("Plan mode enabled. Built-in write tools disabled.");
		} else {
			restoreNormalModeTools();
			ctx.ui.notify("Plan mode disabled. Full access restored.");
		}
		updateStatus(ctx);
		persistState();
	}

	pi.registerCommand("plan", {
		description: "Toggle plan mode (read-only exploration)",
		handler: async (_args, ctx) => togglePlanMode(ctx),
	});

	pi.registerCommand("review", {
		description: "Toggle review mode, or run a parallel review with /review run [target]",
		handler: async (args, ctx) => {
			const trimmed = args.trim();
			if (trimmed === "run" || trimmed.startsWith("run ")) {
				const target = trimmed.slice(3).trim();
				pi.sendUserMessage(`/omp-review${target ? ` ${target}` : ""}`, { expandPromptTemplates: true });
				return;
			}

			reviewModeEnabled = !reviewModeEnabled;
			planModeEnabled = false;
			executionMode = false;
			todoItems = [];
			if (reviewModeEnabled) {
				enablePlanModeTools();
				ctx.ui.notify("Review mode enabled. Edit and write tools disabled.", "info");
			} else {
				restoreNormalModeTools();
				ctx.ui.notify("Review mode disabled. Full access restored.", "info");
			}
			updateStatus(ctx);
			persistState();
		},
	});

	pi.registerCommand("todos", {
		description: "Show current plan todo list",
		handler: async (_args, ctx) => {
			if (todoItems.length === 0) {
				ctx.ui.notify("No todos. Create a plan first with /plan", "info");
				return;
			}
			const list = todoItems.map((item, i) => `${i + 1}. ${item.completed ? "✓" : "○"} ${item.text}`).join("\n");
			ctx.ui.notify(`Plan Progress:\n${list}`, "info");
		},
	});

	pi.registerCommand("plan-handoff", {
		description: "Manually hand off the current plan to a fresh session (add 'draft' to review first)",
		handler: async (args, ctx) => {
			const handoff = pendingPlanHandoff;
			if (!handoff) {
				ctx.ui.notify("No plan is waiting to be handed off. Create a plan in /plan mode first.", "error");
				return;
			}

			const mode = args.trim();
			if (mode && mode !== "draft") {
				ctx.ui.notify("Usage: /plan-handoff [draft]", "error");
				return;
			}

			pendingPlanHandoff = undefined;
			persistState();
			const parentSession = ctx.sessionManager.getSessionFile();
			const executionPrompt = buildExecutionPrompt(handoff.planText);
			await ctx.waitForIdle();

			const result = await ctx.newSession({
				parentSession,
				withSession: async (replacementCtx) => {
					if (mode !== "draft") {
						await replacementCtx.sendUserMessage(executionPrompt);
						return;
					}

					replacementCtx.ui.setEditorText(executionPrompt);
					replacementCtx.ui.notify("Plan copied to a fresh chat. Review it, then submit when ready.", "info");
				},
			});

			if (result.cancelled) {
				pendingPlanHandoff = handoff;
				persistState();
				ctx.ui.notify("Plan handoff cancelled.", "info");
			}
		},
	});

	pi.registerShortcut("shift+tab", {
		description: "Toggle plan mode",
		handler: async (ctx) => togglePlanMode(ctx),
	});

	// Block destructive bash commands in plan mode
	pi.on("tool_call", async (event) => {
		if (!planModeEnabled || event.toolName !== "bash") return;

		const command = event.input.command as string;
		if (!isSafeCommand(command)) {
			return {
				block: true,
				reason: `Plan mode: command blocked (not allowlisted). Use /plan to disable plan mode first.\nCommand: ${command}`,
			};
		}
	});

	// Filter stale mode instructions after switching workflows.
	pi.on("context", async (event) => {
		return {
			messages: event.messages.filter((m) => {
				const msg = m as AgentMessage & { customType?: string };
				if (msg.customType === "plan-mode-context") return planModeEnabled;
				if (msg.customType === "review-mode-context") return reviewModeEnabled;
				if (msg.role !== "user") return true;

				const content = msg.content;
				const isCurrentModeText = (text: string) => {
					if (!planModeEnabled && text.includes("[PLAN MODE ACTIVE]")) return false;
					if (!reviewModeEnabled && text.includes("[REVIEW MODE ACTIVE]")) return false;
					return true;
				};
				if (typeof content === "string") return isCurrentModeText(content);
				if (Array.isArray(content)) {
					return content.every((part) => part.type !== "text" || isCurrentModeText((part as TextContent).text ?? ""));
				}
				return true;
			}),
		};
	});

	// Inject plan/execution context before agent starts
	pi.on("before_agent_start", async (event, ctx) => {
		if (event.prompt.includes(PLAN_HANDOFF_MARKER)) {
			const handedOffTodos = extractTodoItems(event.prompt);
			if (handedOffTodos.length > 0) {
				planModeEnabled = false;
				reviewModeEnabled = false;
				executionMode = true;
				todoItems = handedOffTodos;
				toolsBeforePlanMode = undefined;
				updateStatus(ctx);
				persistState();
			}
		}

		if (reviewModeEnabled) {
			return {
				message: {
					customType: "review-mode-context",
					content: `[REVIEW MODE ACTIVE]
You are reviewing the current repository state. Built-in edit and write tools are disabled.
Inspect the diff and relevant code, run appropriate non-destructive checks, and report findings ordered by severity with file and line references. Do not modify files.`,
					display: false,
				},
			};
		}

		if (planModeEnabled) {
			return {
				message: {
					customType: "plan-mode-context",
					content: `[PLAN MODE ACTIVE]
You are in plan mode - a read-only exploration mode for safe code analysis.

Restrictions:
- Built-in edit and write tools are disabled
- Other currently active tools remain available
- Bash is restricted to an allowlist of read-only commands

Ask clarifying questions using the question tool when a decision materially affects the plan.
Use available web tools for external research when current information or documentation is needed.
Do not execute or hand off a completed plan automatically. Wait for the user's next instruction; they can run /plan-handoff to execute it in a fresh session, or /plan-handoff draft to review the handoff prompt first.

Create a detailed numbered plan under a "Plan:" header:

Plan:
1. First step description
2. Second step description
...

Do NOT attempt to make changes - just describe what you would do.`,
					display: false,
				},
			};
		}

		if (executionMode && todoItems.length > 0) {
			const remaining = todoItems.filter((t) => !t.completed);
			const todoList = remaining.map((t) => `${t.step}. ${t.text}`).join("\n");
			return {
				message: {
					customType: "plan-execution-context",
					content: `[EXECUTING PLAN - Full tool access enabled]

Remaining steps:
${todoList}

Execute each step in order.
After completing a step, include a [DONE:n] tag in your response.`,
					display: false,
				},
			};
		}
	});

	// Track progress after each turn
	pi.on("turn_end", async (event, ctx) => {
		if (!executionMode || todoItems.length === 0) return;
		if (!isAssistantMessage(event.message)) return;

		const text = getTextContent(event.message);
		if (markCompletedSteps(text, todoItems) > 0) {
			updateStatus(ctx);
		}
		persistState();
	});

	// Handle plan completion and plan mode UI
	pi.on("agent_end", async (event, ctx) => {
		// Check if execution is complete
		if (executionMode && todoItems.length > 0) {
			if (todoItems.every((t) => t.completed)) {
				const completedList = todoItems.map((t) => `~~${t.text}~~`).join("\n");
				pi.sendMessage(
					{ customType: "plan-complete", content: `**Plan Complete!** ✓\n\n${completedList}`, display: true },
					{ triggerTurn: false },
				);
				executionMode = false;
				todoItems = [];
				updateStatus(ctx);
				persistState(); // Save cleared state so resume doesn't restore old execution mode
			}
			return;
		}

		if (!planModeEnabled || !ctx.hasUI) return;

		// Extract todos from last assistant message
		const lastAssistant = event.messages.toReversed().find(isAssistantMessage);
		const planText = lastAssistant ? getTextContent(lastAssistant) : "";
		if (!planText) return;
		const extracted = extractTodoItems(planText);
		if (extracted.length === 0) return;
		todoItems = extracted;

		pendingPlanHandoff = { planText };
		persistState();
		ctx.ui.notify(
			"Plan ready. Run /plan-handoff when you want to continue in a fresh session (add 'draft' to review first).",
			"info",
		);
	});

	// Restore state on session start/resume
	pi.on("session_start", async (_event, ctx) => {
		if (pi.getFlag("plan") === true) {
			planModeEnabled = true;
		}

		const entries = ctx.sessionManager.getEntries();

		// Restore persisted state
		const planModeEntry = entries
			.filter((e: { type: string; customType?: string }) => e.type === "custom" && e.customType === "plan-mode")
			.pop() as { data?: PlanModeState } | undefined;

		if (planModeEntry?.data) {
			planModeEnabled = planModeEntry.data.enabled ?? planModeEnabled;
			reviewModeEnabled = planModeEntry.data.reviewing ?? reviewModeEnabled;
			todoItems = planModeEntry.data.todos ?? todoItems;
			executionMode = planModeEntry.data.executing ?? executionMode;
			toolsBeforePlanMode = planModeEntry.data.toolsBeforePlanMode ?? toolsBeforePlanMode;
			pendingPlanHandoff = planModeEntry.data.pendingPlanHandoff;
		}

		// On resume: re-scan messages to rebuild completion state
		// Only scan messages AFTER the last "plan-mode-execute" to avoid picking up [DONE:n] from previous plans
		const isResume = planModeEntry !== undefined;
		if (isResume && executionMode && todoItems.length > 0) {
			// Find the index of the last plan-mode-execute entry (marks when current execution started)
			let executeIndex = -1;
			for (let i = entries.length - 1; i >= 0; i--) {
				const entry = entries[i] as { type: string; customType?: string };
				if (entry.customType === "plan-mode-execute") {
					executeIndex = i;
					break;
				}
			}

			// Only scan messages after the execute marker
			const messages: AssistantMessage[] = [];
			for (let i = executeIndex + 1; i < entries.length; i++) {
				const entry = entries[i];
				if (entry.type === "message" && "message" in entry && isAssistantMessage(entry.message as AgentMessage)) {
					messages.push(entry.message as AssistantMessage);
				}
			}
			const allText = messages.map(getTextContent).join("\n");
			markCompletedSteps(allText, todoItems);
		}

		if (planModeEnabled || reviewModeEnabled) {
			enablePlanModeTools();
		}
		updateStatus(ctx);
	});
}
