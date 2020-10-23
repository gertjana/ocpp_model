defmodule OcppModel.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ocpp_model,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.json": :test, "coveralls.html": :test]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:typed_struct, "~> 0.2.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:credo, "~> 1.5.0-rc-2", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
    ]
  end

  defp aliases do
    [
      all: ["compile --warnings-as-errors", "test --trace", "coveralls", "credo --strict"],
      tt: ["test --trace"]
    ]
  end

  defp docs do
    [
      extras: [
        "README.md"
      ],
      source_ref: "v#{@version}",
      source_url: "https://github.com/gertjana/ocpp_model",
    ]
  end
end
