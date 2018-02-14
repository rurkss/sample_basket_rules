defmodule Basket do
  @moduledoc """
  Module Basket. Structure for storing
  - basket items
  - rules, that applied to the basket products
  - basket totals
  - basket discount
  """

  defstruct items: [], rules: [], total: 0.00, discount: 0.00
end
