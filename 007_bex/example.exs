tree =
  Bex.new(5) # 5 is the maximum fan-out
  |> Bex.insert(3, "three")
  |> Bex.insert(1, "one")
  |> Bex.insert(5, "five")
  |> Bex.insert(2, "two")
  |> Bex.insert(4, "four")

Bex.find(tree, 2) |> IO.inspect
Bex.find(tree, 6) |> IO.inspect

# Outputs:
#
#   {:ok, "two"}
#   {:error, :not_found}
