defmodule SimpleMarkdownExtensionCLI.RendererTest do
    use ExUnit.Case

    test "rendering line break" do
        assert "\n" == [{ :line_break, [] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end

    test "rendering header" do
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}\n\n" == [{ :header, ["test"], 1 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}\n\n" == [{ :header, ["test"], 2 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}\n\n" == [{ :header, ["test"], 3 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}\n\n" == [{ :header, ["test"], 4 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}\n\n" == [{ :header, ["test"], 5 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.bright}test#{IO.ANSI.reset}\n\n" == [{ :header, ["test"], 6 }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end

    test "rendering list" do
        assert "• a\n• b\n\n" == [{ :list, [{ :item, ["a"] }, { :item, ["b"] }], :unordered }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "1) a\n2) b\n\n" == [{ :list, [{ :item, ["a"] }, { :item, ["b"] }], :ordered }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end

    test "rendering preformatted code" do
        assert "    #{IO.ANSI.cyan}test#{IO.ANSI.reset}\n\n" == [{ :preformatted_code, ["test"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "    #{IO.ANSI.cyan}<test>#{IO.ANSI.reset}\n\n" == [{ :preformatted_code, ["<test>"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "    #{IO.ANSI.cyan}test#{IO.ANSI.reset}\n\n" == [{ :preformatted_code, ["test"], :syntax }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render

        assert "a\n    #{IO.ANSI.cyan}test#{IO.ANSI.reset}\n\n" == """
        a
            test
        """ |> SimpleMarkdown.convert(render: &SimpleMarkdownExtensionCLI.Renderer.render/1)

        assert "a\n\n    #{IO.ANSI.cyan}test#{IO.ANSI.reset}\n\n" == """
        a

            test
        """ |> SimpleMarkdown.convert(render: &SimpleMarkdownExtensionCLI.Renderer.render/1)
    end

    test "rendering paragraph" do
        assert "test\n\n" == [{ :paragraph, ["test"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render

        assert "a test\n\n" == """
          a
          test
        """ |> SimpleMarkdown.convert(render: &SimpleMarkdownExtensionCLI.Renderer.render/1)
    end

    test "rendering code" do
        assert "#{IO.ANSI.cyan}test#{IO.ANSI.reset}" == [{ :code, ["test"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
        assert "#{IO.ANSI.cyan}<test>#{IO.ANSI.reset}" == [{ :code, ["<test>"] }] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end

    test "rendering examples" do
        assert "#{IO.ANSI.bright}Heading#{IO.ANSI.reset}\n\n#{IO.ANSI.bright}Sub-heading#{IO.ANSI.reset}\n\n#{IO.ANSI.bright}Another deeper heading#{IO.ANSI.reset}\n\nParagraphs are separatedby a blank line.\n\nTwo spaces at the end of a line leave a\nline break.\n\nText attributes italic, bold, #{IO.ANSI.cyan}monospace#{IO.ANSI.reset}.\n\nBullet list:\n\n• apples\n• oranges\n• pears\n\nNumbered list:\n\n1) apples\n2) oranges\n3) pears\n\nA link (http://example.com).\n\n" == [
            { :header, ["Heading"], 1 },
            { :header, ["Sub-heading"], 2 },
            { :header, ["Another deeper heading"], 3 },
            { :paragraph, ["Paragraphs are separated", "by a blank line."] },
            { :paragraph, ["Two spaces at the end of a line leave a", { :line_break, [] }, "line break."] },
            { :paragraph, ["Text attributes ", { :emphasis, ["italic"], :regular }, ", ", { :emphasis, ["bold"], :strong }, ", ", { :code, ["monospace"] }, "."] },
            { :paragraph, ["Bullet list:"] },
            { :list, [item: ["apples"], item: ["oranges"], item: ["pears"]], :unordered },
            { :paragraph, ["Numbered list:"] },
            { :list, [item: ["apples"], item: ["oranges"], item: ["pears"]], :ordered },
            { :paragraph, ["A ", { :link, ["link"], "http://example.com" }, "."] }
        ] |> SimpleMarkdown.ast_to_structs |> SimpleMarkdownExtensionCLI.Renderer.render
    end
end
