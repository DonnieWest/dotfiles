import { mkdir, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { Browser, Page } from "puppeteer-core";
import puppeteer from "puppeteer-core";
import { StringEnum } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const DEFAULT_CDP_URL = "http://127.0.0.1:9224";
const MAX_TEXT_LENGTH = 20_000;

const actionSchema = StringEnum(["list_tabs", "inspect", "screenshot", "navigate", "click", "type"] as const);
type Action = "list_tabs" | "inspect" | "screenshot" | "navigate" | "click" | "type";

function shorten(text: string): string {
	return text.length > MAX_TEXT_LENGTH ? `${text.slice(0, MAX_TEXT_LENGTH)}\n\n[Output truncated]` : text;
}

async function connect(cdpUrl: string): Promise<Browser> {
	return puppeteer.connect({ browserURL: cdpUrl, protocolTimeout: 15_000, targetFilter: (target) => target.type() === "page" });
}

async function pages(browser: Browser): Promise<Page[]> {
	return browser.pages();
}

async function selectPage(browser: Browser, target: string | undefined): Promise<Page> {
	const available = await pages(browser);
	if (available.length === 0) throw new Error("No controllable browser pages are open.");
	if (!target) return available[0]!;

	const matches = await Promise.all(
		available.map(async (page) => ({ page, url: page.url(), title: await page.title() })),
	);
	const matching = matches.filter(({ url, title }) => url.includes(target) || title.includes(target));
	if (matching.length === 1) return matching[0]!.page;
	if (matching.length === 0) throw new Error(`No page matched target: ${target}`);
	throw new Error(`Target matched ${matching.length} pages. Use a more specific URL or title substring.`);
}

async function confirmInteractiveAction(
	ctx: { hasUI: boolean; ui: { confirm(title: string, message: string): Promise<boolean> } },
	action: Action,
	page: Page,
	selector?: string,
): Promise<void> {
	if (!ctx.hasUI) throw new Error(`${action} requires interactive approval and is unavailable in non-interactive mode.`);
	const title = await page.title();
	const approved = await ctx.ui.confirm(
		"Browser action approval",
		`Allow ${action} on ${title || page.url()}${selector ? ` using selector ${selector}` : ""}?`,
	);
	if (!approved) throw new Error("Browser action was not approved.");
}

export default function browserControlExtension(pi: ExtensionAPI): void {
	pi.registerTool({
		name: "browser_control",
		label: "Browser Control",
		description:
			"Inspect and control a live Chromium DevTools Protocol browser session. Defaults to qutebrowser on http://127.0.0.1:9224; pass cdpUrl for another CDP-enabled Chromium browser. Interactive actions always require approval.",
		promptSnippet: "Inspect a live qutebrowser or CDP-enabled Chromium browser, with approval-gated interaction",
		promptGuidelines: [
			"Use browser_control for authenticated live pages only when the user requests browser inspection or control; inspect before interacting and never perform consequential actions without explicit user approval.",
		],
		parameters: Type.Object({
			action: actionSchema,
			cdpUrl: Type.Optional(Type.String({ description: "HTTP DevTools discovery URL; defaults to qutebrowser at http://127.0.0.1:9224" })),
			target: Type.Optional(Type.String({ description: "Unique URL or title substring that selects an open page" })),
			selector: Type.Optional(Type.String({ description: "CSS selector for click or type" })),
			text: Type.Optional(Type.String({ description: "Text for type" })),
			url: Type.Optional(Type.String({ description: "Destination URL for navigate" })),
		}),
		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			const action = params.action as Action;
			const browser = await connect(params.cdpUrl ?? DEFAULT_CDP_URL);
			try {
				if (action === "list_tabs") {
					const result = await Promise.all(
						(await pages(browser)).map(async (page, index) => ({ index, title: await page.title(), url: page.url() })),
					);
					return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }], details: { action, tabs: result } };
				}

				const page = await selectPage(browser, params.target);
				if (action === "inspect") {
					const text = await page.$eval("body", (body) => body.innerText).catch(() => "");
					const result = { title: await page.title(), url: page.url(), text: shorten(text) };
					return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }], details: { action, ...result } };
				}

				if (action === "screenshot") {
					const directory = join(tmpdir(), "pi-browser-control");
					await mkdir(directory, { recursive: true });
					const path = join(directory, `screenshot-${Date.now()}.png`);
					await writeFile(path, await page.screenshot({ type: "png" }));
					return { content: [{ type: "text", text: `Screenshot saved to ${path}` }], details: { action, path, url: page.url() } };
				}

				await confirmInteractiveAction(ctx, action, page, params.selector);
				if (action === "navigate") {
					if (!params.url) throw new Error("navigate requires url.");
					await page.goto(params.url, { waitUntil: "domcontentloaded", timeout: 30_000 });
				} else if (action === "click") {
					if (!params.selector) throw new Error("click requires selector.");
					await page.click(params.selector);
				} else if (action === "type") {
					if (!params.selector || params.text === undefined) throw new Error("type requires selector and text.");
					await page.type(params.selector, params.text);
				} else {
					throw new Error(`Unsupported action: ${action}`);
				}
				return { content: [{ type: "text", text: `${action} completed on ${page.url()}` }], details: { action, url: page.url() } };
			} finally {
				await browser.disconnect();
			}
		},
	});
}
