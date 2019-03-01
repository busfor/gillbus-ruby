class Gillbus
  class TripOptions
    extend Fields
    include UpdateAttrs

    # Услуги на рейсе (Wi-Fi, розетки и т.п.)
    field :services, [TripService],
      root: 'TRIP_SERVICES',
      key: 'TRIP_SERVICE'

    # Условия по багажу на рейсе.
    # Поддерживаются старый и новый форматы:
    #   <LUGGAGE>
    #     <ITEM>Text</ITEM>
    #     <LUGGAG ID="1">Text</LUGGAG>
    #   </LUGGAGE>
    field :luggage, [:string],
      root: 'LUGGAGE',
      key: ['ITEM', 'LUGGAG']

    # Условия рассадки на рейсе.
    # Поддерживаются старый и новый форматы:
    #   <SEATING>
    #     <ITEM>Text</ITEM>
    #     <SEATIN ID="1">Text</SEATIN>
    #   </SEATING>
    field :seating, [:string],
      root: 'SEATING',
      key: ['ITEM', 'SEATIN']

    # Информация о технических остановках.
    # Поддерживаются старый и новый форматы:
    #   <TECHNICAL_STOP>
    #     <ITEM>Text</ITEM>
    #     <TECHNICAL_STO ID="1">Text</TECHNICAL_STO>
    #   </TECHNICAL_STOP>
    field :technical_stops, [:string],
      root: 'TECHNICAL_STOP',
      key: ['ITEM', 'TECHNICAL_STO']

    # Критичная информация о рейсе.
    # Поддерживаются старый и новый форматы:
    #   <CRITICAL_INFO>
    #     <ITEM>Text</ITEM>
    #     <CRITICAL_INF ID="1">Text</CRITICAL_INF>
    #   </CRITICAL_INFO>
    field :critical_info, [:string],
      root: 'CRITICAL_INFO',
      key: ['ITEM', 'CRITICAL_INF']

    # Опции полученные от внешних ресурсов.
    # Поддерживаются старый и новый форматы:
    #   <RESOURCE_TRIP_OPTION>
    #     <ITEM>Text</ITEM>
    #     <RESOURCE_TRIP_OPTIO ID="1">Text</RESOURCE_TRIP_OPTIO>
    #   </RESOURCE_TRIP_OPTION>
    field :resource_options, [:string],
      root: 'RESOURCE_TRIP_OPTION',
      key: ['ITEM', 'RESOURCE_TRIP_OPTIO']

    # Информация, отмеченная как "прочее".
    # Поддерживаются старый и новый форматы:
    #   <OTHER>
    #     <ITEM>Text</ITEM>
    #     <OTHE ID="1">Text</OTHE>
    #   </OTHER>
    field :other, [:string],
      root: 'OTHER',
      key: ['ITEM', 'OTHE']

    # Поддерживаются старый и новый форматы:
    #   <PROMO>
    #     <ITEM>Text</ITEM>
    #     <PROM ID="1">Text</PROM>
    #   </PROMO>
    field :promo, [:string],
      root: 'PROMO',
      key: ['ITEM', 'PROM']

    # Опции, связанные с билетами.
    field :tickets, [TicketsOption],
      root: 'TICKETS',
      key: 'TICKET'

    def advertising
      promo.include?('ADVERTISING')
    end

    def busfor_recommend
      promo.include?('BUSFOR_RECOMMEND')
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
