class Gillbus
  class Tariff
    extend Fields
    include UpdateAttrs

    # => "Y"
    field :short_name

    # => "Базовый тариф"
    field :full_name

    # => nil
    field :start_date, :date

    # => nil
    field :end_date, :date

    # => "Базовый тариф стоимости проезда одного пассажиров в одном направлении\n"
    field :description

    # => "24"
    field :time_to_buy_reserved, :int

    # => "6"
    field :time_to_stop_booking, :int

    # Время на выкуп брони, то же что и date_to_pay у ticket'а
    field :time_to_pay_reservation, :datetime

    # => "1100"
    field :cost, :money

    # => "true"
    field :after_dispatch_no_return, :bool

    # => nil
    field :passenger_birthday

    # => nil
    field :passenger_isic_number

    # => nil
    field :passenger_student_ticket

    # => "..."
    field :return_cause, [ReturnCause]

    # => "66.61"
    field :note

    field :is_exclusive_price, :bool

    field :insurance_id, :int

    field :insurance_cost, :insurance_money

    field :insurance_sum, :insurance_money

    parser do
      def money(val)
        Monetize.parse(val, doc[:_currency])
      end

      def insurance_money(val)
        Monetize.parse(val, doc['INSURANCE_CUR'])
      end

      def string_with_possible_attributes(val)
        [val].flatten.map do |value|
          if value.is_a? Hash
            value['__content__']
          else
            value
          end
        end
      end
    end
  end
end
