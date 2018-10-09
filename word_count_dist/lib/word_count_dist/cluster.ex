defmodule WordCountDist.Cluster do
  require Logger

  @hostname "localhost"

  def add_node(opts \\ [name: 1]) do
    name = Keyword.get(opts, :name, 1)
    {:ok, slave} = :slave.start_link(:"#{@hostname}", 'node_#{name}', inet_loader_args())
    load_paths(slave)
    {:ok, slave}
  end

  def call(slave, module, method, args) do
    :rpc.block_call(slave, module, method, args)
  end

  def nodes() do
    Node.list()
  end

  def stop() do
    Node.stop()
  end

  def setup(monitor \\ true) do
    setup(monitor, 0, 3)
  end

  def setup(monitor, retry, max_retries) do
    # maybe monitor other nodes
    :ok = :net_kernel.monitor_nodes(monitor)

    try do
      # ensure that we have distribution
      {_, 0} = System.cmd("epmd", ["-daemon"])

      # allow the creation of slaves
      {:ok, _pid} = result = Node.start(:"leader@#{@hostname}", :shortnames)
      result
    catch
      error_class, error_reason ->
        Logger.error("Unable to setup cluster due to #{error_class} - #{inspect(error_reason)}!")

        # retry with 0.5 s sleep in between retries until maximum
        # limit is reached
        if max_retries > 0 and retry < max_retries do
          :ok = :timer.sleep(500)
          Logger.warn("Retrying #{retry + 1}...")
          setup(monitor, retry + 1, max_retries)
        else
          {:error, :unable_to_start_cluster}
        end
    end
  end

  defp load_paths(slave) do
    :rpc.block_call(slave, :code, :add_paths, [:code.get_path()])
  end

  defp inet_loader_args do
    "-loader inet -hosts #{master_node()} -setcookie #{:erlang.get_cookie()}" |> to_charlist()
  end

  defp master_node do
    "masternode@" <> @hostname
  end
end
