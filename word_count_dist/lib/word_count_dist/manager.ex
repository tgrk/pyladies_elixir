defmodule WordCountDist.Manager do
  use GenServer

  require Logger

  alias WordCountDist.Cluster

  @number_of_chunks 1

  def start_link(options \\ []) do
    :gen_server.start_link(__MODULE__, options, [])
  end

  def get_results(pid) do
    :gen_server.call(pid, :get_results)
  end

  def clear_results(pid) do
    :gen_server.call(pid, :clear_results)
  end

  def start_processing(pid, language, file_path) do
    :gen_server.call(pid, {:start_processing, language, file_path})
  end

  def init(_options) do
    {:ok, %{}}
  end

  def handle_call(:get_results, _from, state) do
    {:reply, state, state}
  end
  def handle_call(:clear_results, _from, _state) do
    {:reply, :ok, %{}}
  end
  def handle_call({:start_processing, language, file_path}, _from, state) do
    file_path
    |> File.stream!()
    |> Stream.chunk_every(@number_of_chunks)
    |> Enum.each(fn chunk ->
      if chunk != ["\n"] do
        distribute_work(language, hd(chunk))
      end
    end)

    {:reply, :ok, state}
  end

  def handle_info({_ref, {:ok, node, json_result}}, state) do
    result = Jason.decode!(json_result)

    Logger.info("Receiving results from worker node '#{node}'...")

    {:noreply, aggregate_results(state, result)}
  end

  defp get_random_node do
    Cluster.nodes()
    |> Enum.filter(fn n -> n != :epl@localhost end)
    |> Enum.random()
  end

  def distribute_work(language, sentence) do
    node = get_random_node()

    Logger.info("Sending chunk to worker node '#{node}'...")

    {:ok, worker_pid} = Cluster.call(node, WordCountDist.Worker, :start_link, [])
    :ok = WordCountDist.Worker.word_count(worker_pid, language, sentence)
  end

  def dataset_path(:small) do
    "priv/datasets/small_file.txt"
  end

  def dataset_path(:large) do
    "priv/datasets/plrabn12.txt"
  end

  defp aggregate_results(results, result) do
    Enum.reduce(result, results, fn {word, count}, acc ->
      case Map.get(acc, word) do
        nil ->
          Map.put(acc, word, count)

        existing_count ->
          Map.put(acc, word, existing_count + count)
      end
    end)
  end
end
