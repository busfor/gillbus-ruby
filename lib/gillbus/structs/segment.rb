class Gillbus
  class Segment
    extend Fields
    include UpdateAttrs

    # Порядковый номер сегмента рейса.
    # => "0"
    field :segment_number

    # Признак сегмента обратного направления искусственного рейса туда-обратно.
    # Если TRIP_MODE = 8 и искались обратные рейсы, то параметр будет равен true.
    # => "false"
    field :back_segment, :bool

    # => "393409381686201016"
    field :id

    # Идентификатор стороннего поставщика. 0 - gillbus
    # => "0"
    field :res_id

    # => "Москва-Санкт-Петербург"
    field :number

    # => "Москва"
    field :start_city_name

    # => "Санкт-Петербург"
    field :end_city_name

    # => "10.10.2014"
    field :start_date, :date

    # => "11.10.2014"
    field :end_date, :date

    # => "22:50"
    field :start_time, :time

    # => "Europe/Moscow"
    field :start_timezone

    # => "08:00"
    field :end_time, :time

    # => "Europe/Kiev"
    field :end_timezone

    # => "Сетра S 315 НDH"
    field :bus_model

    # => true
    field :trip_seats_map, :bool

    # => "49"
    field :places_count, :int

    # => "10"
    field :free_places_count, :int

    # => "10/49"
    field :free_busy_places

    # => "ABCDEE23413"
    field :carrier_id

    # => "RU \"ПЕТРОКОМ - АВТО ПЛЮС\" ООО"
    field :carrier_name

    # => "RU \"Еременчук Е.А.\" ИП"
    field :carrier_legal_name

    # => "260802027265"
    field :carrier_inn

    # => "г СНТ Лилия, Московская, Наро-фоминский"
    field :carrier_address_fact

    # => "г СНТ Лилия, Московская, Наро-фоминский"
    field :carrier_address_leg

    # => "316265100057314"
    field :carrier_egrul_egis

    # => "09:10"
    field :time_in_road, :time

    # => "м. \"Речной Вокзал\""
    field :station_begin_name

    # => "ул. Фестивальная, дом 11, метро \"Речной Вокзал\""
    field :station_begin_address

    # => "м. \"Бухарестская\""
    field :station_end_name

    # => "ул. Бухарестская, 30/32 торговый дом \"Континент\", метро \"Бухарестская\""
    field :station_end_address

    # => "true"
    field :reservation_enabled, :bool

    # => "true"
    field :sale_enabled, :bool

    # => "false"
    field :return_enabled, :bool

    # => "25"
    field :time_for_cancel, :int

    # => "false"
    field :trip_full_sale, :bool

    # => "true"
    field :can_discount, :bool

    # => "false"
    field :international, :bool

    # => "false"
    field :join_book_buy, :bool

    # => "1"
    field :trip_mode, :int

    # => "1"
    field :custom_status, :int

    # => "null"
    field :image_url

    # => "null"
    field :start_point_type

    # => "null"
    field :vehicle_description

    # => "null"
    field :vehicle_features

    # => "false"
    field :branded, :bool

    # => "1100"
    field :total_cost, :money

    # => "RUB"
    field :currency

    # => "643"
    field :currency_code

    field :tariffs, [:tariff], key: 'TARIFF'

    field :points, [Point], key: 'POINT'

    field :segments, [Segment], key: 'SEGMENT'

    field :options, TripOptions, key: 'OPTIONS'

    field :bus_photos, [BusPhoto], key: 'BUS_PHOTO'

    field :start_at, :datetime_combined, key: 'START'

    field :end_at, :datetime_combined, key: 'END'

    parser do
      def money(val)
        Monetize.parse(val, doc['CURRENCY'])
      end

      def tariff(val)
        Tariff.parse(val.merge(_currency: doc['CURRENCY']))
      end
    end

    # to hold unserialized data
    attr_accessor :data

    # rubocop:disable Lint/UnusedMethodArgument
    def self.parse(doc, instance: nil, parent: nil, options: {})
      instance = super
      instance.data = doc
      instance
    end
  end
end
