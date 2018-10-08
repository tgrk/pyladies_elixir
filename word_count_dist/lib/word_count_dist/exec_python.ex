
defmodule WordCountDist.ExecPython do
  use GenServer

  alias Porcelain.Result

  def start_link(options \\ []) do
    :gen_server.start_link(__MODULE__, options, [])
  end

  def word_count(sentence) do
    :gen_server.call(pid, {:word_count, sentence})
  end

  def init(_options) do
    {:ok, nil}
  end

  def handle_call({:word_count, sentence}, _from, _state) do
    {:reply, call_python(sentence), _state}
  end

  defp call_python(sentence) do
    "./bin/word_count.py \"#{sentence}\""
    |> Porcelain.shell()
    |> handle_result()
  end

  defp handle_result(%Result{out: output, status: status}) do
    IO.inspect status, label:"RESULt"
    {:ok, output}
  end
end
