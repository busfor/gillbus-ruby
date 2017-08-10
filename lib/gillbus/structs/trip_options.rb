class Gillbus
  class TripOptions

    extend Fields
    include UpdateAttrs

    # услуги на рейсе (Wi-Fi, розетки и т.п.)
    field :services, [TripService], root: 'TRIP_SERVICES', key: 'TRIP_SERVICE'

    # условия по багажу на рейсе
    field :luggage, [:string], root: 'LUGGAGE', key: 'ITEM'

    # условия рассадки на рейсе
    field :seating, [:string], root: 'SEATING', key: 'ITEM'

    # информация о технических остановках
    field :technical_stops, [:string], root: 'TECHNICAL_STOP', key: 'ITEM'

    # критичная информация о рейсе
    field :critical_info, [:string], root: 'CRITICAL_INFO', key: 'ITEM'

    # опции полученные от внешних ресурсов
    field :resource_options, [:string], root: 'RESOURCE_TRIP_OPTION', key: 'ITEM'

    # информация, отмеченная как "прочее"
    field :other, [:string], root: 'OTHER', key: 'ITEM'

  end
end
