class Gillbus
  class Ticket
    STATUS_MAPPING = {
      '0' => :voiding,         # ticket in processing, interim status during refund;
      '1' => :reserved,        # ticket booked;
      '2' => :ticketed,        # ticket sold;
      '3' => :ordered,         # the booking, that waiting for the confirmation;
      '4' => :returned,        # ticket returned;
      '5' => :canceled,        # booking canceled;
      '6' => :voided,          # ticket canceled;
      '8' => :booked,          # the sale, that waiting for the confirmation;
      'e' => :ticketing_error, # resource failed to process this ticket;
    }.freeze

    extend Fields
    include UpdateAttrs

    # The ticket number in the system
    # => 8472
    field :ticket_number

    field :carrier_ticket_number

    # The item position system identifier (is unique for the for the every order item).
    # => 8471
    field :system_number

    # The ticket order number
    # => 14065
    field :order_number

    # The ticket status. Possible values are:
    # :reserved    1 – ticket booked;
    # :ticketed    2 – ticket sold;
    # :ordered     3 – the booking, that waiting for the confirmation;
    # :returned    4 – ticket returned;
    # :canceled    5 – booking canceled;
    # :voided      6 – ticket canceled;
    # :booked      8 – the sale, that waiting for the confirmation
    field :ticket_status, :ticket_status

    # The insurance number
    field :policy_number

    # The flag, which indicates the registration of a trip on the exchange form.
    # true – in case of the registration with the exchange form
    # false – in case of ticket registration
    field :exchange_blank, :bool

    # => Surname Firstname
    field :passenger_full_name

    # => Firstname
    field :passenger_first_name

    # => Surname
    field :passenger_last_name

    field :passenger_birthday, :date

    field :passenger_student_ticket

    # The passenger contact phone number
    # => 380000000000
    field :passenger_phone

    field :passenger_passport

    # The agent name, which sold the ticket
    # => ТОВ"Юпітер
    field :agent_name

    # => +00(044)496-08-00
    field :agent_phone

    # => ТОВ"Юпітер
    field :carrier_name

    # => +00(044)496-08-00
    field :carrier_phone

    # => Setra
    field :bus_model

    field :carriage_number

    # => 16
    field :number_seat

    # => ДЕМ059
    field :trip_number

    # The trip mode. See the returned parameters description of the /online2/searchTrips command.
    # => 1
    field :trip_mode, :int

    # => false
    field :international_trip, :bool

    # => Донецк
    field :start_city

    # => 20.02.2013
    field :start_date, :date

    # => 14:40
    field :start_time, :time

    # => Одесса
    field :end_city

    # => 06:35
    field :end_time, :time

    # Tariff short name
    # => Y
    field :type_tariff_name

    # The tariff  inside the country (country – France for example)
    # => 75.0
    field :tariff, :decimal

    # The tariff VAT inside the country
    # => 15.0
    field :tariff_vat, :decimal

    # The tariff outside the country
    # => 0.0
    field :foreign_tariff, :decimal

    # The tariff VAT outside the country
    # => 0.0
    field :foreign_tariff_vat, :decimal

    # The VAT rate
    # => 0.0
    field :vat_value

    field :note

    # Ticket barcode
    # => ЮПТ000008472ЮПТ
    field :barcode

    # => 21.02.2013
    field :end_date, :date

    # Departure station name
    # => Залізн. вокзал
    field :station_name

    # => БрокБізнесБанк
    field :insurance_name

    # => +33(333)333-33-33
    field :insurance_phone

    # Agent government registration ID
    # => 132123
    field :agent_reg

    # Carrier government registration ID
    # => 132123
    field :carrier_reg

    # => 232323223
    field :insurance_reg

    # The tariff full cost (sale currency)
    # => 75.0
    field :total_tariff, :money

    # The blanket (full) tariff in currency in which the tariff is brought
    # => 75.0
    field :total_tariff_in_currency, :tariff_money

    # The tariff full cost VAT (sale currency)
    # => 15.0
    field :total_tariff_vat, :money

    # The blanket (full) tariff VAT in currency in which the tariff is brought
    # => 15.0
    field :total_tariff_vat_in_currency, :tariff_money

    # The return amount from the common tariff in the sale currency (w/o VAT)
    field :return_total_tariff, :money

    # The return amount from the common tariff in currency in which the tariff is brought (w/o VAT)
    field :return_total_tariff_in_currency, :tariff_money

    # The return amount from the VAT from common tariff in the sale currency
    field :return_total_tariff_vat, :money

    # The return amount from the VAT from common tariff in currency in which the tariff is brought.
    field :return_total_tariff_vat_in_currency, :tariff_money

    # Общий заработок агента
    field :total_agent_income, :money

    # The description of the returning conditions
    field :return_condition

    # Sale currency
    # => UAH
    field :sale_cur_code

    # The currency in which the tariff is brought
    # => UAH
    field :tariff_cur_code

    # Sale exchange rate to currency in which the tariff is brought
    field :tariff_cur_rate

    # The total ticket cost, incliding service charge
    # => 110.0
    field :total_amount, :money

    # The total ticket returning amount
    field :return_total_amount, :money

    # => 18.33
    field :total_amount_vat, :tariff_money

    field :customer_name

    field :customer_phone

    field :customer_address

    # => м Київ, вул Якіра, д 13-б
    field :agent_address

    # => м Київ, вул Якіра, д 13-б
    field :carrier_address

    # => м. Донецьк. вул. Донецька
    field :station_address

    # => м Київ
    field :insurance_address

    # => ЮПТ
    field :agent_code

    # => Київ
    field :agent_city

    # => ЮПТ
    field :carrier_code

    # => DOK
    field :begin_aviacode

    # => ODS
    field :end_aviacode

    # The sum of all collecting over the tariff
    # => 0.0
    field :xt, :money

    # The sum of all collecting VAT over the tariff
    # => 0.0
    field :xt_vat, :money

    # Array of commissions
    field :commissions, [Commission], key: 'COMMISSION'

    # Array of commissions only for us (with additional fields)
    field :all_commissions, [Commission], key: 'COMMISSION', root: 'ALL_COMMISSIONS'

    field :return_causes, [ReturnCause], key: 'RETURN_CAUSE'

    # Date to pay reserved ticket
    field :date_to_pay, :datetime

    # Minutes to pay booked ticket
    field :minutes_for_buyout, :int

    # Ticket type: i.e. bus ticket, insurance, etc
    field :service_type

    field :start_at, :datetime_combined, key: 'START'

    field :end_at, :datetime_combined, key: 'END'

    field :is_online_refund, :bool

    field :is_luggage, :bool, key: 'IS_BAGGAGE'

    parser do
      def ticket_status(value)
        ::Gillbus::Ticket::STATUS_MAPPING[value]
      end

      def money(val)
        Monetize.parse(val, doc['SALE_CUR_CODE'])
      end

      def tariff_money(val)
        Monetize.parse(val, doc['TARIFF_CUR_CODE'])
      end

      def return_cause(val)
        ReturnCause.parse(val.merge(_currency: doc['SALE_CUR_CODE']))
      end
    end
  end
end
