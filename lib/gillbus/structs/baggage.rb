class Gillbus
  class Baggage
    extend Fields
    include UpdateAttrs

    # => "true"
    field :is_buy, :bool

    # => "50.5"
    field :baggage_tariff, :decimal

    # => "2"
    field :baggage_limit, :int
  end
end
