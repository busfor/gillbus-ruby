class Gillbus
  class Baggage
    extend Fields
    include UpdateAttrs

    # => "0"
    field :segment_number, :int

    # => "true"
    field :is_buy, :bool

    # => "50.5"
    field :baggage_tariff, :decimal

    # => "2"
    field :baggage_limit, :int

    field :segments, [Baggage], key: 'SEGMENT'
  end
end
