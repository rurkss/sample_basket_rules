defmodule Checkout do
  @moduledoc """
  Checkout module.
  Is an interface of API.
  It has several available methods:
  - initialize basket
  - add product
  - remove product
  - reset basket
  - show basket
  - show subtotal, total, discount
  """

  alias Product.{Voucher, Tshirt, Mug}
  alias Basket.Manager

  @doc """
  Initialize checkout process.

  Returns `:ok` | `:error`.

  """
  @spec init(List.t()) :: Atom.t()
  def init(rule_list \\ []), do: Manager.init(rule_list)


  @doc """
  Put choosen product in user's basket.
  Recalculate basket totals and discount.

  There are only 3 kind of product to sell:
  - voucher
  - tshirt
  - mug

  Returns `:ok` | :`error`

  """
  @spec scan(String.t()) :: Atom.t()
  def scan("VOUCHER"), do: Manager.add_item(%Voucher{})
  def scan("TSHIRT"), do: Manager.add_item(%Tshirt{})
  def scan("MUG"), do: Manager.add_item(%Mug{})

  def scan(_), do: :error
  @doc false
  def scan(), do: :error


  @doc """
  Remove one item of product from Basket,
  and recalculate basket.

  Returns `:ok` | `error`

  """
  @spec remove(String.t()) :: Atom.t()
  def remove("VOUCHER"), do: Manager.remove_item(%Voucher{})
  def remove("TSHIRT"), do: Manager.remove_item(%Tshirt{})
  def remove("MUG"), do: Manager.remove_item(%Mug{})

  def remove(_), do: :error
  @doc false
  def remove(), do: :error


  @doc """
  Clean up users basket.

  Returns `:ok`.

  """
  def reset(rule_list \\ []), do: Manager.reset(rule_list)


  @doc """
  Show Stored Basket

  Returns `%Basket{}`.

  """
  def show(), do: Manager.basket()


  @doc """
  Show Total Basket Price And Discount

  Returns `%{total: 0.00, discount: 0.00}`.

  """
  def summary(), do: Manager.total()

end
