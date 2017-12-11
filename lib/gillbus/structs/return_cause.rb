class Gillbus
  class ReturnCause
    extend Fields
    include UpdateAttrs

    # The return condition ID
    field :id

    # Approx. return amount in sale currency
    field :approximate_amount, :money

    # The return reason’s description.
    field :cause

    parser do
      def money(val)
        Monetize.parse(val, doc[:_currency])
      end
    end
  end
end
