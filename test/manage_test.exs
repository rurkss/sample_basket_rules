defmodule ManageTest do
  use ExUnit.Case
  doctest Manage

  test "Items: 3xTSHIRT, check discount" do
    pricing_rules = [%Rule.Tshirt{}, %Rule.Voucher{}]
    Checkout.init(pricing_rules)

    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")

    %{:discount => discount} = Checkout.summary()
    assert discount == 3
  end

  test "Items: 3xVOUCHER, check discount" do
    pricing_rules = [%Rule.Tshirt{}, %Rule.Voucher{}]
    Checkout.init(pricing_rules)

    Checkout.scan("VOUCHER")
    Checkout.scan("VOUCHER")
    Checkout.scan("VOUCHER")

    %{:discount => discount} = Checkout.summary()
    assert discount == 5
  end

  test "Items: 3xVOUCHER, check discount after removal 2 vouchers" do
    pricing_rules = [%Rule.Tshirt{}, %Rule.Voucher{}]
    Checkout.init(pricing_rules)

    Checkout.scan("VOUCHER")
    Checkout.scan("VOUCHER")
    Checkout.scan("VOUCHER")
    Checkout.remove("VOUCHER")
    Checkout.remove("VOUCHER")

    %{
      :discount => discount,
      :subtotal => subtotal
    } = Checkout.summary()

    assert discount == 0
    assert subtotal == 5

  end


  ############# TEST CASES #################

  test "Items: VOUCHER, TSHIRT, MUG" do

    pricing_rules = [%Rule.Tshirt{}, %Rule.Voucher{}]
    Checkout.init(pricing_rules)

    Checkout.scan("VOUCHER")
    Checkout.scan("TSHIRT")
    Checkout.scan("MUG")
    %{:subtotal => subtotal} = Checkout.summary()

    assert subtotal == 32.5
  end

  test "Items: VOUCHER, TSHIRT, VOUCHER" do

    pricing_rules = [%Rule.Tshirt{}, %Rule.Voucher{}]
    Checkout.init(pricing_rules)

    Checkout.scan("VOUCHER")
    Checkout.scan("TSHIRT")
    Checkout.scan("VOUCHER")
    %{:subtotal => subtotal} = Checkout.summary()

    assert subtotal == 25.0
  end

  test "Items: TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT" do

    pricing_rules = [%Rule.Tshirt{}, %Rule.Voucher{}]
    Checkout.init(pricing_rules)

    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    Checkout.scan("VOUCHER")
    Checkout.scan("TSHIRT")

    %{:subtotal => subtotal} = Checkout.summary()

    assert subtotal == 81.0
  end

  test "Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT" do

    pricing_rules = [%Rule.Tshirt{}, %Rule.Voucher{}]
    Checkout.init(pricing_rules)

    Checkout.scan("VOUCHER")
    Checkout.scan("TSHIRT")
    Checkout.scan("VOUCHER")
    Checkout.scan("VOUCHER")
    Checkout.scan("MUG")
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")

    %{:subtotal => subtotal} = Checkout.summary()

    assert subtotal == 74.5
  end

end
