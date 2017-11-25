defmodule SimpleMarkdownExtensionCLI.Formatter do
    @doc """
      Format the text output to fit the width of the CLI window.

        iex> SimpleMarkdown.convert("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", render: &SimpleMarkdownExtensionCLI.Formatter.format/1)
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\\n\\n"

        iex> SimpleMarkdown.convert("Lorem ipsum `dolor sit amet, consectetur` adipiscing `elit, sed do eiusmod` tempor incididunt ut `labore` et dolore magna aliqua.", render: &SimpleMarkdownExtensionCLI.Formatter.format/1)
        "Lorem ipsum \\e[36mdolor sit amet, consectetur\\e[0m adipiscing \\e[36melit, sed do eiusmod\\e[0m tempor incididunt ut \\e[36mlabore\\e[0m et dolore magna aliqua.\\n\\n"
    """
    @spec format([SimpleMarkdown.attribute | String.t]) :: String.t
    def format(ast) do
        case :io.columns() do
            { :ok, width } -> format(ast, width)
            _ -> SimpleMarkdownExtensionCLI.Renderer.render(ast)
        end
    end

    @doc """
      Format the text output to fit the specified width.

        iex> SimpleMarkdown.convert("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", render: &SimpleMarkdownExtensionCLI.Formatter.format(&1, 20))
        "Lorem ipsum dolor\\nsit amet,\\nconsectetur\\nadipiscing elit,\\nsed do eiusmod\\ntempor incididunt\\nut labore et dolore\\nmagna aliqua.\\n\\n"

        iex> SimpleMarkdown.convert("Lorem ipsum `dolor sit amet, consectetur` adipiscing `elit, sed do eiusmod` tempor incididunt ut `labore` et dolore magna aliqua.", render: &SimpleMarkdownExtensionCLI.Formatter.format(&1, 20))
        "Lorem ipsum \\e[36mdolor sit amet, consectetur\\e[0m\\nadipiscing \\e[36melit, sed do eiusmod\\e[0m\\ntempor incididunt\\nut \\e[36mlabore\\e[0m\\net dolore magna\\naliqua.\\n\\n"
    """
    @spec format([SimpleMarkdown.attribute | String.t], integer) :: String.t
    def format(ast, width) do
        Enum.map(ast, fn node ->
            line = SimpleMarkdownExtensionCLI.Renderer.render(node)
            tokenize([line], Enum.sort(fixed_width_inputs(node), &(String.length(&1) > String.length(&2))))
            |> Enum.filter(&(&1 != ""))
            |> Enum.reduce("", fn
                { :fixed, string }, acc -> acc <> string
                string, acc ->
                    String.split(string, " ")
                    |> Enum.intersperse(" ")
                    |> Enum.chunk_while(acc, fn
                        " ", acc -> { :cont, acc <> " " }
                        word, "" -> { :cont, word }
                        word, acc ->
                            if String.length(remove_ansi_codes(word)) + String.length(remove_ansi_codes(acc)) >= width do
                                { :cont, String.trim(acc), word }
                            else
                                { :cont, acc <> word }
                        end
                    end, &({ :cont, &1, "" }))
                    |> Enum.map(&String.trim_leading/1)
                    |> Enum.join("\n")
            end)
        end)
        |> Enum.join()
    end

    @spec remove_ansi_codes(String.t) :: String.t
    defp remove_ansi_codes(string), do: String.replace(string, ~r/(\x9b|\x1b\[)[0-?]*[ -\/]*[@-~]/, "")

    @spec fixed_width_inputs([SimpleMarkdown.attribute | String.t], [String.t]) :: [String.t]
    defp fixed_width_inputs(ast, inputs \\ [])
    defp fixed_width_inputs(%{ input: [] }, inputs), do: inputs
    defp fixed_width_inputs(ast = %{ __struct__: name }, inputs) when name in [SimpleMarkdown.Attribute.Code, SimpleMarkdown.Attribute.PreformattedCode] do
        [SimpleMarkdownExtensionCLI.Renderer.render(ast)|inputs]
    end
    defp fixed_width_inputs(ast = %{}, inputs), do: Enum.reduce(ast.input, inputs, &fixed_width_inputs/2)
    defp fixed_width_inputs(_, inputs), do: inputs

    @spec tokenize([String.t | { :fixed, String.t }], [String.t]) :: [String.t | { :fixed, String.t }]
    defp tokenize(tokens, []), do: tokens
    defp tokenize(tokens, [input|inputs]) do
        Enum.reduce(tokens, [], fn
            token, acc when is_tuple(token) -> acc ++ [token]
            string, acc -> acc ++ Enum.intersperse(String.split(string, input), { :fixed, input })
        end)
        |> tokenize(inputs)
    end
end