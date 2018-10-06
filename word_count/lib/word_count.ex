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
    # 1st convert strings to lower case
    # 2nd remove characters that are not words
    # 3rd split sentence into individual words
    # 4th create map with words as keys and number of
    #     ocurences as values
    # 5th return map with summary
  end
end
