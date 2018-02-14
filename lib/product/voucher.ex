defmodule Product.Voucher do
  @moduledoc """
  Defines the Voucher product struct.

  * :title - title of the product
  * :price - product price
  * :discount - product price
  * :timestamp - time when product was added

  """
  defstruct title: "Voucher", price: 5.00, discount: 0.00, timestamp: nil
end
