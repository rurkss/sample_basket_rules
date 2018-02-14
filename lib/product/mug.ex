defmodule Product.Mug do
  @moduledoc """
  Defines the Mug product struct.

  * :title - title of the product
  * :price - product price
  * :discount - product price
  * :timestamp - time when product was added

  """
  defstruct title: "Coffe Mug", price: 7.50, discount: 0.00, timestamp: nil
end
