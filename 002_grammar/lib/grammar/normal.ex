defmodule Grammar.Normal do
  @places [
    "Minas",
    "Nen",
    "Ered",
    "Dor",
    "Amon"
  ]

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

  @middle_syllables [
    "gul",
    "ar",
    "hir",
    "nor",
    "lin"
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

  def generate(r \\ rand(50))

  # Places
  def generate(r) when r < 10 do
    "#{place_type} #{one_name}"
  end

  # Two-syllable name
  def generate(r) when r < 20 do
    two_syllable_name
  end

  # Two-syllable name followed by another name
  def generate(r) when r < 30 do
    "#{two_syllable_name} #{one_name}"
  end

  # Three-syllable name
  def generate(r) when r < 40 do
    three_syllable_name
  end

  # Three-syllable name followed by another name
  def generate(r) do #when r < 50 do
    "#{three_syllable_name} #{one_name}"
  end

  # Name with -in-
  # Name with -en-
  # Name with -i-

  defp place_type do
    @places |> Enum.shuffle |> hd
  end

  defp one_name(r \\ rand(2))
  defp one_name(1), do: two_syllable_name
  defp one_name(2), do: three_syllable_name

  defp two_syllable_name do
    start_syllable <> end_syllable
  end

  defp three_syllable_name do
    start_syllable <> middle_syllable <> end_syllable
  end

  defp start_syllable do
    @start_syllables |> Enum.shuffle |> hd
  end

  defp middle_syllable do
    @middle_syllables |> Enum.shuffle |> hd
  end

  defp end_syllable do
    @end_syllables |> Enum.shuffle |> hd
  end

  # Random number from 1 to max
  defp rand(max) do
    :rand.uniform(max)
  end
end
