defmodule Rule.Voucher do
  @moduledoc """
  Voucher Rule Structure
  Calculate discounts applying a rule
  Steps:
  - Find Voucher Proudcts by grouping them by struct type
  - Iterate over grouped products
  - Upply rule &_update_discount/1 for Vouchers
  """
  defstruct description: "2-for-1 promotions (buy two of the same product, get one free)",
            items: []
end


defimpl Rule.Discount, for: Rule.Voucher do

  # implementation of protool's behaviour &/calculcate/1
  @spec calculate(Rule.Vouchers.t()) :: List.t()
  def calculate(rule) do

    rule.items
      |> Enum.group_by(&(&1.__struct__)) # group all products by type
      |> Enum.reduce([], fn
        {Product.Voucher, voucher}, # pattern matching on particular product
          acc -> [ _update_discount(voucher) | acc] # apply rule &_update_discount/1 to the list of items
        {_,val},
          acc -> [val | acc] # do not apply if it is not Voucher
        end)
      |> List.flatten

  end

  # update discounts for each Voucher product if there are more than 1 item of Voucher
  defp _update_discount(items) when length(items) > 1 do
    items
      |> Enum.chunk_every(2) # Split all items by List of 2 items
      |> Enum.map( &_set_discount/1) # Apply discount to the chunk
      |> List.flatten
  end

  # return list if there are less than 2 Voucher in basket
  defp _update_discount(items), do: items


  defp _set_discount(items) when length(items) == 2 do
    [hd | tail] = items                 # take first element from chunk
    hd = %{hd | discount: hd.price}     # set discount to the product price ( discount == price )
    [hd | tail]                         # return updated chunk
  end

  # return chunk as it is if there are less than 2 items of Voucher
  defp _set_discount(items), do: items
end
