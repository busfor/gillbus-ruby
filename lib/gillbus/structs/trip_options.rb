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

    # признак рекламируемого рейса, передается как <PROMO><ITEM>ADVERTISING</ITEM></PROMO>
    field :advertising, :adertising_bool, root: 'PROMO', key: 'ITEM'

    # признак рекомендованого рейса, передается как <PROMO><ITEM>BUSFOR_RECOMMEND</ITEM></PROMO>
    field :busfor_recommend, :recommend_bool, root: 'PROMO', key: 'ITEM'

    parser do # better not to let flag value out of this gem
      def adertising_bool(vals)
        vals.include?('ADVERTISING')
      end

      def recommend_bool(vals)
        vals.include?('BUSFOR_RECOMMEND')
      end
    end

    def self.build_blank
      options = new
      field_definitions.each do |name:, type:, key:, root:|
        options.send(:"#{name}=", []) if type.is_a?(Array)
      end
      options
    end
  end
end
