# FIXME it's possible I got currency for some fields wrong.
class Gillbus
  class Commission

    extend Fields
    include UpdateAttrs

    # Collecting type
    field :type

    # Symbolic collecting code
    field :code

    # Collecting description
    field :description

    # Value of collecting in sale currency
    field :value, :money

    # Value of collecting VAT in sale currency
    field :vat, :money

    # Collecting currency
    field :currency

    # Exchange rate of collecting to sale currency
    field :rate

    # Value of collecting in currency in which it is brought
    field :value_in_currency, :money

    # Value of collecting VAT in currency in which it is brought
    field :vat_in_currency, :money

    # The return amount from collecting in sale currency (w/o VAT)
    field :return_value, :money

    # The return amount from collecting VAT in sale currency
    field :return_vat, :money

    # The return amount from collecting in currency in which it is brought  (w/o VAT)
    field :return_value_in_currency, :money

    # The return amount from collecting VAT in currency in which it is brought.
    field :return_vat_in_currency, :money

    parser do
      def money(val)
        Monetize.parse(val, doc['CURRENCY'])
      end
    end

  end
end
