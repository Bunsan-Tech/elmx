defmodule Mix.Tasks.Elmx.New do
  use Mix.Task

  def run([name]) do
    Mix.Task.run("phx.new", [name])

    Mix.shell.info [:green, "* creating ", :default_color, name <> "/assets/elm"]
    System.cmd "create-elm-app", ["elm"], cd: name <> "/assets"
    System.cmd "npm", ["install","--save-dev", "elm-brunch"], cd: name <> "/assets"

    Mix.shell.info [:green, "* configuring ", :default_color, "elm-brunch"]

    File.stream!(name <> "/assets/brunch-config.js")
    |> Stream.map(fn line ->
      cond do
        String.contains? line, "plugins:" -> elm_brunch_config()
        String.contains? line, "ignore:" -> babel_brunch_config()
        true -> line
      end
    end)
    |> Stream.into(File.stream!(name <> "/assets/brunch-config-2.js", [:write, :utf8]))
    |> Stream.run

    Mix.shell.info [:default_color, "elm was configured"]
  end

  defp babel_brunch_config do
    [{2, "ignore: "}, {3, ~s([/vendor/,)}, {3, ~s("js/elm.js]")}]
    |> indent_lines()
  end

  defp indent_lines(lines) do
    Enum.map_reduce(lines, "", fn(line, acc) ->
      acc <> "\n" <> indent_line(line)
    end)
  end

  defp indent_line({levels, line}) do
    String.duplicate("  ", levels) <> line
  end

  defp elm_brunch_config do
    [{1, "plugins: {"}, 
    {2, "elmBrunch: {" }, 
    {3, ~s(elmFolder: "elm",)},
    {3, ~s(mainModules: ["src/Main.elm"],)},
    {3, ~s(outputFolder: "../js",)}, 
    {3, ~s(outputFile: "elm.js",)} , 
    {3, ~s(makeParameters: ["--warn"])},
    {2, "},"}] 
    |> indent_lines()
  end

end