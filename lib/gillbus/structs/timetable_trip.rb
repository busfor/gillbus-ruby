class Gillbus
  class TimetableTrip
    extend Fields
    include UpdateAttrs

    # => "ЯРМ005 Киев-Коблево"
    field :number

    # => "Киев"
    field :start_city_name

    # => "Коблево"
    field :end_city_name

    # => "24.07.2015"
    field :start_date, :date

    # => "31.08.2015"
    field :end_date, :date

    # => "07:30"
    field :start_time, :time

    # => "14:30"
    field :end_time, :time

    # => "Neoplan 313 SHD"
    field :bus_model

    # => "38"
    field :number_seats, :int

    # => ""Ярмола А.Г." ФОП +38(044)5965112"
    field :carrier_info

    # => "3"
    field :frequency, :int

    # => "false"
    field :international, :bool

    # => "1"
    field :trip_mode, :int

    field :segments, [TimetableSegment], key: 'SEGMENT'

    field :days_of_week, :days_of_week, key: 'DAY_OR_DATE'

    field :dates, :dates, key: 'DAY_OR_DATE'

    parser do
      DAYS_INTO_WEEK = {
        1 => :sunday,
        2 => :monday,
        3 => :tuesday,
        4 => :wednesday,
        5 => :thursday,
        6 => :friday,
        7 => :saturday,
      }

      def days_of_week(value)
        return unless instance.frequency == 3
        Array(value).map { |v| day_of_week(v) }
      end

      def dates(value)
        return unless instance.frequency == 2
        Array(value).map { |v| date(v) }
      end

      def day_of_week(day)
        DAYS_INTO_WEEK[day.to_i]
      end
    end
  end
end
