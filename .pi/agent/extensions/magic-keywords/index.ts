import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type Keyword = "ultrathink" | "orchestrate" | "workflowz";

const notices: Record<Keyword, string> = {
	ultrathink:
		"For this turn, reason carefully before acting. Inspect relevant evidence, consider failure modes and alternatives, and verify the result rather than relying on intuition.",
	orchestrate:
		"For this turn, use the subagent tool for substantial independent work. Keep one writer per worktree, parallelize research and review, verify each phase, and keep the parent session as final decision-maker.",
	workflowz:
		"For this turn, express substantial delegation as one deterministic subagent workflowScript with stable run keys, explicit dependencies, distinct review lanes, and a synthesized result.",
};

function proseOnly(text: string): string {
	return text
		.replace(/```[\s\S]*?```|~~~[\s\S]*?~~~/g, " ")
		.replace(/`[^`]*`/g, " ")
		.replace(/<!--[\s\S]*?-->/g, " ")
		.replace(/<([A-Za-z][\w:-]*)\b[^>]*>[\s\S]*?<\/\1>/g, " ")
		.replace(/<[^>]+>/g, " ");
}

function findKeywords(text: string): Keyword[] {
	const prose = proseOnly(text);
	return (Object.keys(notices) as Keyword[]).filter((keyword) => {
		const pattern = new RegExp(`(^|[^A-Za-z0-9_./\\\\:-])${keyword}(?=$|[^A-Za-z0-9_./\\\\:-])`);
		return pattern.test(prose);
	});
}

export default function magicKeywordsExtension(pi: ExtensionAPI): void {
	let previousThinking: ReturnType<typeof pi.getThinkingLevel> | undefined;

	pi.on("before_agent_start", (event, ctx) => {
		const matched = findKeywords(event.prompt);
		if (matched.length === 0) return;

		if (matched.includes("ultrathink")) {
			previousThinking ??= pi.getThinkingLevel();
			pi.setThinkingLevel("max");
		}
		ctx.ui.setStatus("magic-keywords", ctx.ui.theme.fg("accent", `✦ ${matched.join("+")}`));
		return {
			systemPrompt: `${event.systemPrompt}\n\nTurn-specific directives:\n${matched.map((keyword) => `- ${notices[keyword]}`).join("\n")}`,
		};
	});

	pi.on("agent_settled", (event, ctx) => {
		void event;
		if (previousThinking !== undefined) {
			pi.setThinkingLevel(previousThinking);
			previousThinking = undefined;
		}
		ctx.ui.setStatus("magic-keywords", undefined);
	});
}
