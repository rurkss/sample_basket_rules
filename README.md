# Simple Checkout Basket Manager

## Requirments
Elixir 1.6.0

## Usage

Basic operations:

- Checkout.init([%Rule.Tshirt{}, %Rule.Voucher{}])
- Checkout.scan("TSHIRT")
- Checkout.scan("MUG")
- Checkout.scan("VOUCHER")
- Checkout.remove("VOUCHER")
- Checkout.show()
- Checkout.summary()
- Checkout.reset([%Rule.Tshirt{}, %Rule.Voucher{}])


Documentation can be found at https://rurkss.github.io/basket_doc/api-reference.html