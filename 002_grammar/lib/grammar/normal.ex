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

  def generate(r \\ rand(6))

  # Places
  def generate(1) do
    "#{place_type} #{one_name}"
  end

  # Two-syllable name
  def generate(2) do
    two_syllable_name
  end

  # Two-syllable name followed by another name
  def generate(3) do
    "#{two_syllable_name} #{one_name}"
  end

  # Three-syllable name
  def generate(4) do
    three_syllable_name
  end

  # Three-syllable name followed by another name
  def generate(5) do 
    "#{three_syllable_name} #{one_name}"
  end

  # Name with in, en or i
  def generate(6) do
    of_name
  end

  defp of_name(r \\ rand(3))
  defp of_name(1), do: "#{one_name}-in-#{one_name}"
  defp of_name(2), do: "#{one_name}-en-#{one_name}"
  defp of_name(3), do: "#{one_name}-i-#{one_name}"

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
