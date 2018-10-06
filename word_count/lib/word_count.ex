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
  end
end
