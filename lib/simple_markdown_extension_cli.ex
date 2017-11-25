defmodule SimpleMarkdownExtensionCLI do
    @moduledoc """
      This extension provides a renderer for CLI output.

      The renderer (`SimpleMarkdownExtensionCLI.Renderer.render/1`)
      can be used by simply passing it as the render option to
      `SimpleMarkdown.convert/2`. Alternatively if the text
      should be formatted in a way that makes it more presentable
      on certain devices, the `SimpleMarkdownExtensionCLI.Formatter.format/1`
      or `SimpleMarkdownExtensionCLI.Formatter.format/2` variant
      can be used instead.
    """
end
