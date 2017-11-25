defprotocol SimpleMarkdownExtensionCLI.Renderer do
    @fallback_to_any true
    def render(ast)
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: Any do
    def render(%{ input: input }) do
        SimpleMarkdownExtensionCLI.Renderer.render(input)
    end
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: List do
    def render(ast) do
        Enum.map(ast, &SimpleMarkdownExtensionCLI.Renderer.render/1)
        |> Enum.join(" ")
    end
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: BitString do
    def render(string), do: String.trim(string)
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.LineBreak do
    def render(_), do: "\n"
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.Header do
    def render(%{ input: input }), do: IO.ANSI.bright <> SimpleMarkdownExtensionCLI.Renderer.render(input) <> IO.ANSI.reset
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.PreformattedCode do
    def render(%{ input: input }), do: "\n    " <> IO.ANSI.cyan <> SimpleMarkdownExtensionCLI.Renderer.render(input) <> IO.ANSI.reset <> "\n\n"
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.Paragraph do
    def render(%{ input: input }), do: String.trim(SimpleMarkdownExtensionCLI.Renderer.render(input)) <> "\n\n"
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.Code do
    def render(%{ input: input }), do: IO.ANSI.cyan <> SimpleMarkdownExtensionCLI.Renderer.render(input) <> IO.ANSI.reset
end