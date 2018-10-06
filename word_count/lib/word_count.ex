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
  end

  defp split_sentence(sentence) do

  end

  defp summarize(words) do
  end

  defp add_count(word, counts) do
  end
end
