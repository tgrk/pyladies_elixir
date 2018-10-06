defmodule Pyladies.WordCountTest do
  use ExUnit.Case

  alias Pyladies.WordCount

  test "simple sentence" do
    expected = %{"hello" => 1, "pyladies" => 1}
    assert WordCount.count("Hello Pyladies") == expected
  end

  test "count only words" do
    expected = %{"hello" => 1, "world" => 1}
    assert WordCount.count("Hello, World!") == expected
  end

  test "ignore letter case" do
    expected = %{"elixir" => 2, "python" => 1}
    assert WordCount.count("Elixir elixir python") == expected
  end
end
