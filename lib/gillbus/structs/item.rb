class Gillbus
  class Item
    extend Fields
    include UpdateAttrs

    field :date, :date
    # Признак прямого рейса
    field :is_direct, :bool
    # Признак рейса с пересадкой
    field :is_transfer, :bool
  end
end
