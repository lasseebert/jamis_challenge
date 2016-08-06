defmodule Grammar.Normal do
  @start_syllables [
    "And",
    "Ara",
    "Cele",
    "El",
    "Fin",
    "Mith",
    "Mith",
    "Mor",
    "Nim"
  ]

  @end_syllables [
    "dal",
    "dor",
    "fang",
    "fin",
    "gorn",
    "gul",
    "gund",
    "hir",
    "hoth",
    "iath",
    "ion",
    "lin",
    "nor",
    "or",
    "ram",
    "ras",
    "rath",
    "rill",
    "rim",
    "rod",
    "uin",
    "waith",
    "waith",
    "wen"
  ]

  def generate do
    type(rand(100))
  end

  # Places
  defp type(r) when r < 10 do
    "#{place_type(rand(5))} #{one_name}"
  end

  # Two-syllable name
  defp type(r) do# when r < 20 do
    two_syllable_name
  end

  # Two-syllable name followed by another name
  # Three-syllable name
  # Three-syllable name followed by another name
  # Name with -in-
  # Name with -en-
  # Name with -i-

  defp place_type(1), do: "Minas"
  defp place_type(2), do: "Nen"
  defp place_type(3), do: "Ered"
  defp place_type(4), do: "Dor"
  defp place_type(5), do: "Amon"

  defp one_name do
    # TODO
    two_syllable_name
  end

  defp two_syllable_name do
    start_syllable <> end_syllable
  end

  defp start_syllable do
    @start_syllables |> Enum.shuffle |> hd
  end

  defp end_syllable do
    @end_syllables |> Enum.shuffle |> hd
  end

  # Random number from 1 to max
  defp rand(max) do
    :rand.uniform(max)
  end
end
