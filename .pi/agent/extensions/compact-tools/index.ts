import { homedir } from "node:os";
import {
	createBashTool,
	createEditTool,
	createFindTool,
	createGrepTool,
	createLsTool,
	createReadTool,
	createWriteTool,
	type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import { Container, Text } from "@earendil-works/pi-tui";

interface TextResult {
	content: Array<{ type: string; text?: string }>;
}

function shortPath(path: string): string {
	const home = homedir();
	return path.startsWith(home) ? `~${path.slice(home.length)}` : path;
}

function oneLine(value: string, limit = 110): string {
	const compact = value.replace(/\s+/g, " ").trim();
	return compact.length > limit ? `${compact.slice(0, limit - 1)}…` : compact;
}

function compactResult(
	result: TextResult,
	expanded: boolean,
	isError: boolean,
	color: (name: "error" | "toolOutput", text: string) => string,
) {
	const text = result.content
		.flatMap((part) => (part.type === "text" && typeof part.text === "string" ? [part.text] : []))
		.join("\n")
		.trim();

	if (!text || (!expanded && !isError)) return new Container();
	const visible = isError && !expanded ? text.split("\n").slice(0, 6).join("\n") : text;
	return new Text(color(isError ? "error" : "toolOutput", visible), 2, 0);
}

function toolLine(label: string, detail: string, theme: { fg(name: "toolTitle" | "accent" | "muted", text: string): string }) {
	const marker = theme.fg("muted", "›");
	const name = theme.fg("toolTitle", label);
	const value = detail ? ` ${theme.fg("accent", detail)}` : "";
	return new Text(`${marker} ${name}${value}`, 1, 0);
}

export default function compactToolsExtension(pi: ExtensionAPI): void {
	const cwd = process.cwd();
	const read = createReadTool(cwd);
	const bash = createBashTool(cwd);
	const edit = createEditTool(cwd);
	const write = createWriteTool(cwd);
	const grep = createGrepTool(cwd);
	const find = createFindTool(cwd);
	const ls = createLsTool(cwd);

	pi.registerTool({
		...read,
		renderShell: "self",
		renderCall: (args, theme) => toolLine("read", shortPath(args.path || ""), theme),
		renderResult: (result, options, theme, context) =>
			compactResult(result, options.expanded, context.isError, (name, text) => theme.fg(name, text)),
	});

	pi.registerTool({
		...bash,
		renderShell: "self",
		renderCall: (args, theme, context) =>
			toolLine("$", context.expanded ? (args.command || "").trim() : oneLine(args.command || ""), theme),
		renderResult: (result, options, theme, context) =>
			compactResult(result, options.expanded, context.isError, (name, text) => theme.fg(name, text)),
	});

	pi.registerTool({
		...edit,
		renderShell: "self",
		renderCall: (args, theme) => {
			let count = "";
			if (Array.isArray(args.edits)) {
				const noun = args.edits.length === 1 ? "change" : "changes";
				count = ` · ${args.edits.length} ${noun}`;
			}
			return toolLine("edit", `${shortPath(args.path || "")}${count}`, theme);
		},
		renderResult: (result, options, theme, context) =>
			compactResult(result, options.expanded, context.isError, (name, text) => theme.fg(name, text)),
	});

	pi.registerTool({
		...write,
		renderShell: "self",
		renderCall: (args, theme) => toolLine("write", shortPath(args.path || ""), theme),
		renderResult: (result, options, theme, context) =>
			compactResult(result, options.expanded, context.isError, (name, text) => theme.fg(name, text)),
	});

	pi.registerTool({
		...grep,
		renderShell: "self",
		renderCall: (args, theme) => toolLine("grep", `${oneLine(args.pattern || "", 72)} · ${shortPath(args.path || ".")}`, theme),
		renderResult: (result, options, theme, context) =>
			compactResult(result, options.expanded, context.isError, (name, text) => theme.fg(name, text)),
	});

	pi.registerTool({
		...find,
		renderShell: "self",
		renderCall: (args, theme) => toolLine("find", `${args.pattern || "*"} · ${shortPath(args.path || ".")}`, theme),
		renderResult: (result, options, theme, context) =>
			compactResult(result, options.expanded, context.isError, (name, text) => theme.fg(name, text)),
	});

	pi.registerTool({
		...ls,
		renderShell: "self",
		renderCall: (args, theme) => toolLine("ls", shortPath(args.path || "."), theme),
		renderResult: (result, options, theme, context) =>
			compactResult(result, options.expanded, context.isError, (name, text) => theme.fg(name, text)),
	});
}
