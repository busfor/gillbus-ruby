class Gillbus
  class TimetableSegment
    extend Fields
    include UpdateAttrs

    # => Киев
    field :start_name

    # => Київський Центральний Автовокзал
    field :start_station_name

    # => Московська площа, 2/1
    field :start_station_address

    # => 0123456789ABCDEF0123456789ABCDEF
    field :start_station_id

    # => Одесса
    field :end_name

    # => Автовокзал
    field :end_station_name

    # => Балківська вулиця
    field :end_station_address

    # => 0123456789ABCDEF0123456789ABCDEF
    field :end_station_id

    # => 07:30
    field :start_time, :time

    # => 12:55
    field :end_time, :time

    # => 0
    field :days, :int

    # => 1400
    field :time_in_road, :int

    # => "270.5"
    field :base_cost, :money

    parser do
      def money(val)
        Monetize.parse(val, doc['CUR_CODE'])
      end
    end
  end
end
