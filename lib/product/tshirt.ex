defmodule Product.Tshirt do
  @moduledoc """
  Defines the Tshirt product struct.

  * :title - title of the product
  * :price - product price
  * :discount - product price
  * :timestamp - time when product was added

  """
  defstruct title: "T-Shirt", price: 20.00, discount: 0.00, timestamp: nil
end
