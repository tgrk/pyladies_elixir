defmodule WordCountDist.MixProject do
  use Mix.Project

  def project do
    [
      app: :word_count_dist,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:porcelain, "~> 2.0"},
      {:observer_cli, "~> 1.4"}
    ]
  end
end
