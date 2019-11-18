class Gillbus
  class Luggage
    extend Fields

    # => "0"
    field :segment_number, :int

    # => "true"
    field :is_buy, :bool

    # => "50.5"
    field :luggage_tariff, :decimal, key: 'BAGGAGE_TARIFF'

    # => "2"
    field :luggage_limit, :int, key: 'BAGGAGE_LIMIT'

    field :segments, [Luggage], key: 'SEGMENT'
  end
end
