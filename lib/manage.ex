defmodule Manage do

  def check do

    basket = %Basket{}

    basket = Map.update(basket, :items, [], &([%Shirt{} | &1]))
    basket = Map.update(basket, :items, [], &([%Shirt{} | &1]))
    basket = Map.update(basket, :items, [], &([%Shirt{} | &1]))
    basket = Map.update(basket, :items, [], &([%Mug{} | &1]))
    basket = Map.update(basket, :items, [], &([%Mug{} | &1]))

    items = basket.items
     |> Enum.group_by(&(&1.__struct__))
     |> Enum.reduce([], fn
        {Shirt, shirts}, acc -> [ update_discount(shirts) | acc]
        {_,val}, acc -> [val | acc]
        end)
     |> List.flatten

     basket = Map.update(basket, :items, [], &(&1=items))

     {total, discount} = basket.items
      |> Enum.reduce({0.00, 0.00}, fn(item, {total, discount}) -> {total + item.price, discount + item.discount} end)


    basket |> Map.put(:total, total) |> Map.put(:discount, discount)
  end

  def update_discount(items) when length(items) > 2 do
    items
    |> Enum.map(&(%{&1 | discount: 1.00 }))
  end

  def update_discount(items), do: items


end
