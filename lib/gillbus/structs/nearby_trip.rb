# результаты поиска по соседним городам, берется из кеша и содержит меньше данных, чем поездка из выдачи
class Gillbus
  class NearbyTrip
    extend Fields
    include UpdateAttrs

    # => "Москва"
    field :start_city_name

    # => "A7CD147C07E7CD1BE040A8C0630328EC"
    field :start_city_guid

    # => "Смоленск"
    field :end_city_name

    # => "DD253CDEE7D1555EE040B8596052093F"
    field :end_city_guid

    # => "22:50"
    field :time_departure, :time # XXX

    # => "08:00"
    field :time_arrival, :time # XXX

    # => "RU \"ПЕТРОКОМ - АВТО ПЛЮС\" ООО"
    field :carrier_tm # XXX

    # => "390"
    field :travel_time

    # => "1100"
    field :total_cost, :money

    parser do
      def money(val)
        Monetize.parse(val, doc['CURRENCY'])
      end
    end

    # to hold unserialized data
    attr_accessor :data
  end
end
