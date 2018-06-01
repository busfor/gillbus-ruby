class Gillbus
  class Trip
    extend Fields
    include UpdateAttrs

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

    # => "VIP"
    field :bus_class

    # => "168689517A076A9AE0508E5B3557184F"
    field :bus_id

    # => true
    field :has_transfer, :bool

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

    # => "09:10"
    field :time_in_road, :time

    # => D547A366D02526A7E040B85960523246
    field :station_begin_id

    # => "м. \"Речной Вокзал\""
    field :station_begin_name

    # => "ул. Фестивальная, дом 11, метро \"Речной Вокзал\""
    field :station_begin_address

    # => D547A366D02526A7E040B85960523246
    field :station_end_id

    # => "м. \"Бухарестская\""
    field :station_end_name

    # => "ул. Бухарестская, 30/32 торговый дом \"Континент\", метро \"Бухарестская\""
    field :station_end_address

    # => "true"
    field :reservation_enabled, :bool

    # => "true"
    field :recommended, :bool

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

    # => "false"
    field :fake_time_in_road, :bool

    field :redirect_url

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
      instance.options = TripOptions.build_blank if instance.options.nil?
      instance
    end
  end
end
