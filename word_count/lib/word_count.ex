defmodule Pyladies.WordCount do
  @moduledoc """
  Count the number of words in the sentence excluding puntantion and ignoring
  capitalization.
  """

  @non_words ~r/!|"|\#|\$|%|&|'|\(|\)|\*|\+|,|\.|\/|:|;|<|=|>|\?|@|\[|\\|]|\^|_|`|\{|\||}|~/

  @doc """
  Count the number of words in the sentence.
  """
  @spec count(String.t()) :: map()
  def count(sentence) do
    sentence
    |> String.downcase()
    |> remove_punctuation()
    |> split_sentence()
    |> summarize()
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
