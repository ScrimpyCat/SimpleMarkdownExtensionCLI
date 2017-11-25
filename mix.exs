defmodule SimpleMarkdownExtensionCLI.Mixfile do
    use Mix.Project

    def project do
        [
            app: :simple_markdown_extension_cli,
            description: "An extension for SimpleMarkdown to add renderer for CLI output.",
            version: "0.0.1",
            elixir: "~> 1.5",
            start_permanent: Mix.env == :prod,
            deps: deps(),
            package: package()
        ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
        [extra_applications: [:logger]]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
        [{ :simple_markdown, "~> 0.3.0" }]
    end

    defp package do
        [
            maintainers: ["Stefan Johnson"],
            licenses: ["BSD 2-Clause"],
            links: %{ "GitHub" => "https://github.com/ScrimpyCat/SimpleMarkdownExtensionCLI" }
        ]
    end
end
