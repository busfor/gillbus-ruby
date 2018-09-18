# результаты поиска по соседним городам, берется из кеша и содержит меньше данных, чем поездка из выдачи
class Gillbus
  class NearbyCitiesTrip
    extend Fields
    include UpdateAttrs

    # => "Москва"
    field :start_city_name

    # => "A7CD147C07E7CD1BE040A8C0630328EC"
    field :start_city_guid

    # => "Europe/Moscow"
    field :start_timezone

    # => 20
    field :distance_to_start

    # => "Смоленск"
    field :end_city_name

    # => "DD253CDEE7D1555EE040B8596052093F"
    field :end_city_guid

    # => "Europe/Moscow"
    field :end_timezone

    # => 0
    field :distance_to_end

    # => "22:50"
    field :start_time, :time # XXX

    # => "08:00"
    field :end_time, :time # XXX

    # => ""Автофлот Автоколонна-1601" ООО"
    field :carrier_name # XXX

    # => "RU "Автофлот Автоколонна-1601" ООО"
    field :carrier_legal_name # XXX

    # => "390"
    field :time_in_road

    # => "1100"
    field :total_cost, :money

    # => "RUB"
    field :currency

    parser do
      def money(val)
        Monetize.parse(val, doc['CURRENCY'])
      end
    end

    # to hold unserialized data
    attr_accessor :data
  end
end
