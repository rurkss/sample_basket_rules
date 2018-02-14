defprotocol Rule.Discount do
  @moduledoc """
  A protocol for dealing with the
  various forms of rule resources.
  For now there are rules only for Vouchers and Tshirts.
  Protocol needs to be implemented by all rules
  """

  @doc """
  All rules has to implement protocol's
  method calculate

  """
  @spec calculate(Rule.t()) :: List.t()
  def calculate(rule)
end
