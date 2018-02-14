defmodule Rule.Tshirt do
  @moduledoc """
  Tshirt Rule Structure
  Calculate discounts applying a rule
  Steps:
  - Find Tshirt Proudcts by grouping them by struct type
  - Iterate over grouped products
  - Upply rule &_update_discount/1 for Tshirt products
  """
  defstruct description: "You buy 3 or more TSHIRT items, the price per unit should be 19.00€",
            items: []
end


defimpl Rule.Discount, for: Rule.Tshirt do

  # implementation of protool's behaviour &/calculcate/1
  @spec calculate(Rule.Tshirt.t()) :: List.t()
  def calculate(rule) do

    rule.items
     |> Enum.group_by(&(&1.__struct__)) # group all products by type
     |> Enum.reduce([], fn
        {Product.Tshirt, shirts}, # pattern matching on particular product
          acc -> [ _update_discount(shirts) | acc] # apply rule &_update_discount/1 to the list of items
        {_,val},
          acc -> [val | acc] # do not apply discount if it is no Product
        end)
     |> List.flatten
  end

  # update discounts for each Tshirt product
  defp _update_discount(items) when length(items) > 2 do
    items
      |> Enum.map(&(%{&1 | discount: 1.00 })) # set discount equals to 1 if there are more than 2 items
  end

  # return list if there are less than 2 Tshirts in basket
  defp _update_discount(items), do: items

end
