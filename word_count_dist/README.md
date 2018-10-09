# WordCountDist

```elixir
iex --cookie cookie --sname master@localhost -S mix

iex --cookie cookie --sname worker1@localhost -S mix
iex --cookie cookie --sname worker2@localhost -S mix
```

```elixir
Node.ping(:'worker1@localhost')
Node.ping(:'worker2@localhost')
Node.list() # see other nodes without itself - Node.self()

...


alias WordCountDist.Manager

{:ok, pid} = Manager.start_link()

Manager.start_processing(pid, :elixir, Manager.dataset_path(:small))
Manager.start_processing(pid, :elixir, Manager.dataset_path(:large))

...

Manager.get_results(pid)

...

Enum.each(1..100_000, fn (_) -> Node.list() |> Enum.random() |> Node.ping() end)
```

## Erlang performance lab

```bash
./erlangpl -v -n "master@localhost"  -s "epl@localhost" -c cookie
```

URL - http://localhost:37575/traffic

## Installation
