defmodule SimpleMarkdownExtensionCLI.RendererTest do
    use ExUnit.Case

    test "rendering line break" do
        assert "\n" == [{ :line_break, [] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end

    test "rendering header" do
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}" == [{ :header, ["test"], 1 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}" == [{ :header, ["test"], 2 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}" == [{ :header, ["test"], 3 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}" == [{ :header, ["test"], 4 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}" == [{ :header, ["test"], 5 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}" == [{ :header, ["test"], 6 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end

    test "rendering list" do
        assert "• a\n• b" == [{ :list, [{ :item, ["a"] }, { :item, ["b"] }], :unordered }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "1) a\n2) b" == [{ :list, [{ :item, ["a"] }, { :item, ["b"] }], :ordered }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end

    test "rendering preformatted code" do
        assert "\n    #{IO.ANSI.cyan}test#{IO.ANSI.reset}\n\n" == [{ :preformatted_code, ["test"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "\n    #{IO.ANSI.cyan}<test>#{IO.ANSI.reset}\n\n" == [{ :preformatted_code, ["<test>"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "\n    #{IO.ANSI.cyan}test#{IO.ANSI.reset}\n\n" == [{ :preformatted_code, ["test"], :syntax }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end

    test "rendering paragraph" do
        assert "test\n\n" == [{ :paragraph, ["test"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end

    test "rendering code" do
        assert "#{IO.ANSI.cyan}test#{IO.ANSI.reset}" == [{ :code, ["test"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.cyan}<test>#{IO.ANSI.reset}" == [{ :code, ["<test>"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end
end
