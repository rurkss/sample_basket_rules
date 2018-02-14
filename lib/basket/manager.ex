defmodule Basket.Manager do
  @moduledoc """
  Basket Manager module.
  Used for manipulate products in basket
  """


  @doc """
  Starts Gen Server and hold basket as state of it
  Returns `{:ok, #PID}`.

  """
  @spec init(List.t()) :: Struct.t()
  def init(rule_list) do
    Agent.start_link(fn -> %Basket{rules: rule_list} end, name: __MODULE__)
  end


  @doc """
  Update Agent state
  Steps:
  - Get Basket from Agent
  - Insert new product in Basket item list and set timestamp to item struct
  - Apply discount rules
  - recalculate Basket total and discount
  - save new state to Gen Server

  Returns `:ok`.

  """
  @spec add_item(Struct.t()) :: Atom.t()
  def add_item(item) do

    basket = basket()

    basket
      |> Map.update(:items, [], # add to Basket Items new Item
        &([%{item | timestamp: :calendar.universal_time()} | &1])) # and update items timestamp
      |> apply_rules
      |> recalculate
      |> basket
  end


  @doc """
  Remove item of product from basket
  Steps:
  - group items by __struct__
  - pop item from matched list
  - Apply discount rules (if they are exists)
  - recalculate Basket total and discount
  - save new state to Agent

  Returns `:ok`.

  """
  def remove_item((%_{} = item)) do
    basket = basket()

    struct = item.__struct__ # get struct name, will be pattern matching on it

    items = basket.items
      |> Enum.group_by(&(&1.__struct__)) # group by products (by struct name)
      |> Enum.reduce([], fn
        {^struct, items}, # pattern match on product that should be removed
          acc -> [ remove_item(items) | acc]
        {_,val},
          acc -> [val | acc] # do nothing for items of another product in Basket
        end)
      |> List.flatten

    Map.update(basket, :items, [], &(&1=items)) # update basket with new List of items, after removal
      |> apply_rules
      |> recalculate
      |> basket
  end


  @doc false
  # pop item form list
  def remove_item(items) when is_list(items) do
    {_, list} = List.pop_at(items, 0)
    list
  end


  @doc false
  # no rules? return basket as it is!
  def apply_rules(b = %Basket{rules: []}), do: b


  @doc """
  Iterate through rules and apply each rule
  to the product list.
  But before we should set all discount to zero

  Returns `List`.

  """
  @spec apply_rules(Basket.t()) :: List.t()
  def apply_rules(basket) do

    basket_items = basket.items # iterate through all busket items
      |> Enum.map(&(%{&1 | discount: 0.00 })) # set discount to 0, before rules will be applied

    items = basket.rules # iterate through basket rules
      |> Enum.reduce(basket_items,
        &(Rule.Discount.calculate(%{&1 | items: &2}))) # pass to each rule List of items

    Map.update(basket, :items, [], &(&1=items)) # update basket with items after rules were applied
  end


  @doc """
  Update Basket's total and discount by
  calculating all items discount and items
  price separately

  Returns `%Busket{}`.

  """
  @spec recalculate(Basket.t()) :: Basket.t()
  def recalculate(basket) do

    {total, discount} = basket.items # iterate through basket items
      |> Enum.reduce({0.00, 0.00}, fn # get from Product Structure its price and discount and summarize it
        (item, {total, discount}) -> {total + item.price, discount + item.discount} end)

    basket
      |> Map.put(:total, total) # set to Basket new total
      |> Map.put(:discount, discount) # and new discount
  end


  @doc """
  Get state from Agent.
  Returns `%Basket{}`.

  """
  def basket(), do: Agent.get(__MODULE__, &(&1))


  @doc """
  Set state to Agent.
  Returns `:ok`.

  """
  def basket(basket), do: Agent.cast(__MODULE__, &(&1 = basket))


  @doc """
  Set empty List in state of Agent.

  Returns `:ok`.

  """
  def reset(rule_list), do: Agent.cast(__MODULE__, &(&1 = %Basket{rules: rule_list}))

  @doc false
  def total do
    basket = basket()
    %{
      subtotal: basket.total - basket.discount,
      total: basket.total,
      discount: basket.discount
    }
  end
end
