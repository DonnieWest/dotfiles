import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const Option = Type.Object({
  label: Type.String({ description: "Short option label" }),
  description: Type.Optional(Type.String({ description: "Tradeoff or consequence" })),
});

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "question",
    label: "Question",
    description: "Ask the user one focused question with concrete options when their decision is required. Do not use for questions answerable from the repository.",
    promptSnippet: "Ask a focused multiple-choice question when a material user decision is required",
    promptGuidelines: [
      "Use question only when user input materially affects scope, behavior, risk, or an irreversible choice; inspect available context first.",
    ],
    executionMode: "sequential",
    parameters: Type.Object({
      question: Type.String({ description: "A concise, specific question" }),
      options: Type.Array(Option, { minItems: 1, maxItems: 6 }),
      allowOther: Type.Optional(Type.Boolean({ description: "Allow a free-form response; defaults to true" })),
    }),
    async execute(_id, params, _signal, _update, ctx) {
      if (!ctx.hasUI) throw new Error("User interaction is unavailable in this mode");
      const labels = params.options.map((option) =>
        option.description ? `${option.label} — ${option.description}` : option.label,
      );
      if (params.allowOther !== false) labels.push("Other…");
      const selected = await ctx.ui.select(params.question, labels);
      if (!selected) return { content: [{ type: "text", text: "User cancelled the question." }], details: { answer: null } };
      if (selected === "Other…") {
        const answer = await ctx.ui.input(params.question, "Type your answer");
        return { content: [{ type: "text", text: answer?.trim() ? `User answered: ${answer.trim()}` : "User cancelled the question." }], details: { answer: answer?.trim() || null } };
      }
      const index = labels.indexOf(selected);
      const answer = params.options[index]?.label ?? selected;
      return { content: [{ type: "text", text: `User selected: ${answer}` }], details: { answer, index } };
    },
  });
}
