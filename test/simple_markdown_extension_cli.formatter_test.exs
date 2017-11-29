defmodule SimpleMarkdownExtensionCLI.FormatterTest do
    use ExUnit.Case
    doctest SimpleMarkdownExtensionCLI.Formatter

    test "preserving whitespace" do
        assert "a b c d e f\n\n" == "a b c d e f" |> SimpleMarkdown.convert(render: &SimpleMarkdownExtensionCLI.Formatter.format(&1, 80))
        assert "a b\nc d\ne f\n\n" == "a b c d e f" |> SimpleMarkdown.convert(render: &SimpleMarkdownExtensionCLI.Formatter.format(&1, 4))
        assert "    #{IO.ANSI.cyan}a b c d e f#{IO.ANSI.reset}\n\n" == "    a b c d e f" |> SimpleMarkdown.convert(render: &SimpleMarkdownExtensionCLI.Formatter.format(&1, 80))
        assert "    #{IO.ANSI.cyan}a b c d e f#{IO.ANSI.reset}\n\n" == "    a b c d e f" |> SimpleMarkdown.convert(render: &SimpleMarkdownExtensionCLI.Formatter.format(&1, 4))
    end
end
