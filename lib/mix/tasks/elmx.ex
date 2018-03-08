defmodule Mix.Tasks.Elmx.New do

  use Mix.Task

  @shortdoc "Create a Phoenix + Elm project"
  def run([name]) do
    Mix.Task.run("phx.new", [name])

    Mix.shell.info [:green, "* running ", :default_color, "create-elm-app"]
    System.cmd "create-elm-app", ["elm"], cd: name <> "/assets"
    System.cmd "npm", ["install","--save-dev", "elm-brunch"], [cd: name <> "/assets", stderr_to_stdout: true]
    configure_elm(name)

    Mix.shell.info [:cyan, "\nElm was configured successfully!\n"]
  end

  defp configure_elm(project_name) do
    Mix.shell.info [:green, "* configuring ", :default_color, "elm app"]
    File.cp! brunch_config(), project_name <> "/assets/brunch-config.js"
    File.cp! app_js(), project_name <> "/assets/js/app.js"
    File.cp! index(), project_name <> "/lib/" <> project_name <> "_web/templates/page/index.html.eex"
    File.cp! main(), project_name <> "/assets/elm/src/Main.elm"
    System.cmd "mv", [ project_name <> "/assets/elm/public/logo.svg", project_name <> "/assets/static/images/logo.svg"]
  end

  defp brunch_config, do: Path.expand "../../../priv/brunch-config.js", __DIR__
  defp app_js, do: Path.expand "../../../priv/app.js", __DIR__ 
  defp index, do: Path.expand "../../../priv/index.html.eex", __DIR__ 
  defp main, do: Path.expand "../../../priv/Main.elm", __DIR__ 

end