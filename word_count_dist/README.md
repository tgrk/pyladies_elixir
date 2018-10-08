# WordCountDist

```elixir
iex --cookie cookie --sname master@localhost -S mix

iex --cookie cookie --sname slave@localhost -S mix
```

```elixir
Node.ping(:'master@localhost')

alias WordCountDist.Cluster
{:ok, slave_pid} = Cluster.call(:'slave@localhost', WordCountDist.Echo, :start_link, [])
WordCountDist.ExecPython.word_count(slave_pid, "Hello, World!")

Enum.each(1..10_000_000, fn (_) -> Node.ping(:'slave@localhost') end)
```

## Erlang performance lab

```bash
./erlangpl -n "master@localhost"  -l "epl@localhost" --c cookie
```

URL - http://localhost:37575/traffic

## Installation
