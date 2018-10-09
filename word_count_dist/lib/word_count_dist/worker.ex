defmodule WordCountDist.Worker do
  use GenServer, restart: :temporary

  require Logger

  alias Porcelain.Result

  @non_words ~r/!|"|\#|\$|%|&|'|\(|\)|\*|\+|,|\.|\/|:|;|<|=|>|\?|@|\[|\\|]|\^|_|`|\{|\||}|~/

  def start_link(options \\ []) do
    :gen_server.start_link(__MODULE__, options, [])
  end

  def word_count(pid, language, sentence) do
    :gen_server.call(pid, {:word_count, language, sentence})
  end

  def init(_options) do
    {:ok, nil}
  end

  def handle_call({:word_count, :python, sentence}, from, _state) do
    Logger.info("Starting worker job #{inspect self()} using Python...")
    Process.spawn(fn -> call_python(from, sentence) end, [])
    {:reply, :ok, from}
  end

  def handle_call({:word_count, :elixir, sentence}, from, _state) do
    Logger.info("Starting worker job #{inspect self()} using Elixir...")
    Process.spawn(fn -> call_elixir(from, sentence) end, [])
    {:reply, :ok, from}
  end

  defp call_python(from, sentence) do
      "./bin/word_count.py \"#{sentence}\""
      |> Porcelain.shell()
      |> handle_result()
      |> reply_results(from)
  end

  defp call_elixir(from, sentence) do
      sentence
      |> String.downcase()
      |> remove_punctuation()
      |> split_sentence()
      |> summarize()
      |> Jason.encode!()
      |> reply_results(from)
  end

  defp handle_result(%Result{out: output, status: _status}) do
    output |> to_string()
  end

  defp reply_results(results, from) do
    GenServer.reply(from, {:ok, Node.self(), results})
  end

  defp remove_punctuation(string) do
    String.replace(string, @non_words, " ")
  end

  defp split_sentence(sentence) do
    List.flatten(String.split(sentence))
  end

  defp summarize(words) do
    Enum.reduce(words, %{}, &add_count/2)
  end

  defp add_count(word, counts) do
    Map.update(counts, word, 1, &(&1 + 1))
  end
end
