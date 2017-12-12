require 'date'

class Gillbus
  class BaseRequest
    def initialize(attrs = {})
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end

    def path
      raise NotImplementedError, 'you need to define "path" method'
    end

    def params
      {}
    end

    def method
      :post
    end

    private

    def list(items)
      return if items.nil?
      Array(items).join(';')
    end

    def date(date)
      return if date.nil?
      date.strftime('%d.%m.%Y')
    end

    def bool(bool)
      return if bool.nil?
      bool ? '1' : '0'
    end

    def translated_locale(locale)
      return if locale.nil?
      {
        'ru' => 'rus',
        'en' => 'lat',
        'uk' => 'ukr',
        'th' => 'tai',
        'pl' => 'pol',

        # temporary, until changed in busfor
        'ua' => 'ukr',
      }[locale.to_s] || locale.to_s
    end

    MODES = {
      # 0 – искать все виды транспорта;
      all: 0,
      # 1 – искать автобусные рейсы;
      bus: 1,
      # 2 - искать такси (только searchTransfersTrips?)
      taxi: 2,
      # 3 – искать авиационные рейсы;
      avia: 3,
      # 4 – искать авиационные чартерные рейсы;
      charter: 4,
      # 6 – рейсы водного транспорта;
      boat: 6,
      # 31 – искать авиационные рейсы эконом-класса;
      avia_economy: 31,
      # 32 – искать авиационные рейсы бизнес-класса;
      avia_business: 32,
      # 51 – искать железнодорожные рейсы;
      train: 51,
      # 8 – искать рейсы с пересадками;
      connections: 8,
      # 9 – искать рейсы только с пересадками.
      connections_only: 9,
      # 13 - автобусно-лодочный микс
      bus_boat: 13,
    }.freeze

    def modes(items)
      list(
        Array(items).map do |item|
          if item.is_a? Symbol
            MODES[item] ||
              raise(ArgumentError, "unknown search mode #{item.inspect}", caller)
          else
            item
          end
        end,
      )
    end

    def compact(hash)
      hash.each do |k, v|
        hash.delete k if v.nil?
      end
      hash
    end
  end
end
