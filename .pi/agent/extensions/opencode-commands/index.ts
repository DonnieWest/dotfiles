import {
	DynamicBorder,
	type ExtensionAPI,
	type ExtensionCommandContext,
} from "@earendil-works/pi-coding-agent";
import { Container, type SelectItem, SelectList, type SizeValue, Text } from "@earendil-works/pi-tui";

async function picker(
	ctx: ExtensionCommandContext,
	title: string,
	items: SelectItem[],
	options: { width?: SizeValue; anchor?: "center" | "right-center" } = {},
): Promise<string | undefined> {
	if (ctx.mode !== "tui") {
		const label = await ctx.ui.select(title, items.map((item) => item.label));
		return items.find((item) => item.label === label)?.value;
	}

	return ctx.ui.custom<string | undefined>(
		(tui, theme, _keybindings, done) => {
			const container = new Container();
			container.addChild(new DynamicBorder((text: string) => theme.fg("accent", text)));
			container.addChild(new Text(theme.fg("accent", theme.bold(` ${title} `)), 1, 0));
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
			container.addChild(new Text(theme.fg("dim", " type to filter · enter select · esc close "), 1, 0));
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
			overlayOptions: {
				anchor: options.anchor ?? "center",
				width: options.width ?? "62%",
				minWidth: 46,
				maxHeight: "82%",
				margin: 1,
			},
		},
	);
}

export default function opencodeCommands(pi: ExtensionAPI): void {
	const openCommandPalette = async (ctx: ExtensionCommandContext) => {
		const builtIns: SelectItem[] = [
			{ value: "plan", label: "/plan", description: "Plan without modifying files" },
			{ value: "review", label: "/review", description: "Review changes without editing" },
			{ value: "sessions", label: "/sessions", description: "List and switch sessions" },
			{ value: "models", label: "/models", description: "Select a model" },
			{ value: "themes", label: "/themes", description: "Select a theme" },
			{ value: "details", label: "/details", description: "Toggle tool details" },
			{ value: "approval", label: "/approval", description: "Configure read/write/exec approvals" },
			{ value: "role", label: "/role", description: "Select or configure a model role" },
			{ value: "checkpoint", label: "/checkpoint", description: "Bookmark conversation state" },
			{ value: "rewind", label: "/rewind", description: "Return to a conversation checkpoint" },
			{ value: "memories", label: "/memories", description: "List durable project memories" },
			{ value: "handoff", label: "/handoff", description: "Continue a focused task in a fresh session" },
			{ value: "editor", label: "/editor", description: "Open the expanded message editor" },
			{ value: "compact", label: "/compact", description: "Compact the current session" },
			{ value: "new", label: "/new", description: "Start a new session" },
			{ value: "share", label: "/share", description: "Share the current session" },
			{ value: "export", label: "/export", description: "Export the current session" },
			{ value: "settings", label: "/settings", description: "Open Pi settings" },
			{ value: "hotkeys", label: "/hotkeys", description: "Show keyboard shortcuts" },
			{ value: "close", label: "/close", description: "Close Pi gracefully" },
		];
		const selected = await picker(ctx, "Command palette", builtIns);
		if (selected) ctx.ui.setEditorText(`/${selected}`);
	};

	pi.registerCommand("commands", {
		description: "Open the searchable command palette",
		handler: async (_args, ctx) => openCommandPalette(ctx),
	});

	pi.registerCommand("help", {
		description: "Show the OpenCode-style command palette",
		handler: async (_args, ctx) => openCommandPalette(ctx),
	});

	pi.registerShortcut("ctrl+p", {
		description: "Open command palette",
		handler: async (ctx) => {
			if (!ctx.isIdle()) {
				ctx.ui.notify("Wait for the current turn before opening the command palette.", "info");
				return;
			}
			pi.sendUserMessage("/commands", { expandPromptTemplates: true });
		},
	});

	pi.registerCommand("continue", {
		description: "List and switch between sessions",
		handler: async (_args, ctx) => {
			if (!ctx.isIdle()) {
				ctx.ui.notify("Wait for the current turn before switching sessions.", "info");
				return;
			}
			pi.sendUserMessage("/sessions", { expandPromptTemplates: true });
		},
	});

	pi.registerCommand("details", {
		description: "Toggle tool execution details",
		handler: async (_args, ctx) => {
			const expanded = !ctx.ui.getToolsExpanded();
			ctx.ui.setToolsExpanded(expanded);
			ctx.ui.notify(`Tool details ${expanded ? "expanded" : "collapsed"}.`, "info");
		},
	});

	pi.registerCommand("editor", {
		description: "Open the expanded message editor",
		handler: async (_args, ctx) => {
			const content = await ctx.ui.editor("Compose message", ctx.ui.getEditorText());
			if (content !== undefined) ctx.ui.setEditorText(content);
		},
	});

	pi.registerCommand("models", {
		description: "List and select available models",
		handler: async (_args, ctx) => {
			const models = ctx.scopedModels.length > 0
				? ctx.scopedModels.map((entry) => entry.model)
				: ctx.modelRegistry.getAvailable();
			const items: SelectItem[] = models.map((model) => ({
				value: `${model.provider}\u0000${model.id}`,
				label: `${model.id}${ctx.model?.provider === model.provider && ctx.model.id === model.id ? " (active)" : ""}`,
				description: `${model.provider} · ${(model.contextWindow / 1000).toFixed(0)}k context`,
			}));
			const selected = await picker(ctx, "Models", items);
			if (!selected) return;
			const separator = selected.indexOf("\u0000");
			if (separator < 0) {
				ctx.ui.notify("Unable to parse the selected model.", "error");
				return;
			}
			const provider = selected.slice(0, separator);
			const id = selected.slice(separator + 1);
			const model = ctx.modelRegistry.find(provider, id);
			if (!model || !(await pi.setModel(model))) {
				ctx.ui.notify(`Unable to select ${provider}/${id}. Check provider authentication.`, "error");
			}
		},
	});

	pi.registerCommand("themes", {
		description: "List and select themes",
		handler: async (_args, ctx) => {
			const themes = ctx.ui.getAllThemes();
			const selected = await picker(
				ctx,
				"Themes",
				themes.map((theme) => ({ value: theme.name, label: theme.name, description: theme.path ?? "built in" })),
			);
			if (!selected) return;
			const result = ctx.ui.setTheme(selected);
			if (!result.success) ctx.ui.notify(result.error ?? `Unable to select theme ${selected}.`, "error");
		},
	});

	pi.registerCommand("summarize", {
		description: "Compact the current session",
		handler: async (_args, ctx) => {
			ctx.compact({
				onComplete: () => ctx.ui.notify("Session compacted.", "info"),
				onError: (error) => ctx.ui.notify(error.message, "error"),
			});
		},
	});

	pi.registerCommand("clear", {
		description: "Start a new session",
		handler: async (_args, ctx) => {
			await ctx.newSession({
				parentSession: ctx.sessionManager.getSessionFile(),
				withSession: async (replacementCtx) => replacementCtx.ui.notify("New session ready.", "info"),
			});
		},
	});

	pi.registerCommand("init", {
		description: "Create or improve project AGENTS.md instructions",
		handler: async (_args, ctx) => {
			if (!ctx.isIdle()) {
				ctx.ui.notify("Wait for the current turn before running /init.", "info");
				return;
			}
			pi.sendUserMessage(
				"Inspect this repository and create or improve its AGENTS.md with concise, project-specific build, test, style, and architecture guidance. Preserve useful existing instructions and do not include generic advice.",
			);
		},
	});

	pi.registerCommand("connect", {
		description: "Open Pi provider login",
		handler: async (_args, ctx) => {
			ctx.ui.setEditorText("/login");
			ctx.ui.notify("Pi handles provider setup through /login. Press Enter to continue.", "info");
		},
	});

	const exit = async (ctx: ExtensionCommandContext) => ctx.shutdown();
	pi.registerCommand("exit", { description: "Exit Pi", handler: async (_args, ctx) => exit(ctx) });
	pi.registerCommand("close", { description: "Close Pi gracefully", handler: async (_args, ctx) => exit(ctx) });
	pi.registerCommand("q", { description: "Exit Pi", handler: async (_args, ctx) => exit(ctx) });
}
