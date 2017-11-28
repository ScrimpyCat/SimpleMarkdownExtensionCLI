defprotocol SimpleMarkdownExtensionCLI.Renderer do
    @moduledoc """
      A renderer protocol for ANSI escaped text.

      Individual rule renderers can be overriden or new ones may be
      added. Works in the same way as `SimpleMarkdown.Renderer.HTML`.

      Example
      -------
        defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.Code do
            def render(%{ input: input }), do: IO.ANSI.cyan <> SimpleMarkdownExtensionCLI.Renderer.render(input) <> IO.ANSI.reset
        end
    """

    @fallback_to_any true

    @doc """
      Render the parsed markdown as ANSI escaped text.
    """
    @spec render([SimpleMarkdown.attribute | String.t] | SimpleMarkdown.attribute | String.t) :: String.t
    def render(ast)
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: Any do
    def render(%{ input: input }) do
        SimpleMarkdownExtensionCLI.Renderer.render(input)
    end
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: List do
    def render(ast) do
        Enum.reduce(ast, "", fn
            attribute = %{ __struct__: SimpleMarkdown.Attribute.PreformattedCode }, string when bit_size(string) > 0 ->
                if(String.ends_with?(string, "\n"), do: string, else: string <> "\n") <> SimpleMarkdownExtensionCLI.Renderer.render(attribute)
            attribute, string ->
                string <> SimpleMarkdownExtensionCLI.Renderer.render(attribute)
        end)
    end
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: BitString do
    def render(string), do: string
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.LineBreak do
    def render(_), do: "\n"
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.Header do
    def render(%{ input: input }), do: IO.ANSI.bright <> String.trim(SimpleMarkdownExtensionCLI.Renderer.render(input)) <> IO.ANSI.reset <> "\n\n"
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.List do
    def render(%{ input: input, option: :unordered }) do
        list = Enum.map(input, fn item ->
            "• " <> SimpleMarkdownExtensionCLI.Renderer.render(item)
        end)
        |> Enum.join("\n")

        list <> "\n\n"
    end
    def render(%{ input: input, option: :ordered }) do
        list = Enum.with_index(input, 1)
        |> Enum.map(fn { item, number } ->
            "#{number}) " <> SimpleMarkdownExtensionCLI.Renderer.render(item)
        end)
        |> Enum.join("\n")

        list <> "\n\n"
    end
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.PreformattedCode do
    def render(%{ input: input }), do: "    " <> IO.ANSI.cyan <> SimpleMarkdownExtensionCLI.Renderer.render(input) <> IO.ANSI.reset <> "\n\n"
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.Paragraph do
    def render(%{ input: input }), do: String.trim(SimpleMarkdownExtensionCLI.Renderer.render(input)) <> "\n\n"
end

defimpl SimpleMarkdownExtensionCLI.Renderer, for: SimpleMarkdown.Attribute.Code do
    def render(%{ input: input }), do: IO.ANSI.cyan <> SimpleMarkdownExtensionCLI.Renderer.render(input) <> IO.ANSI.reset
end
