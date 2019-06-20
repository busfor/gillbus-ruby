require 'bigdecimal'
require 'active_support/time'

class Gillbus
  class Parser
    NULL_CONST = 'null'.freeze
    TRUE_CONST = 'true'.freeze
    YES_CONST = 'Y'.freeze
    DATE_FORMAT_CONST = '%d.%m.%Y'.freeze
    TIME_FORMAT_REGEXP = /^ ( \d\d:\d\d ) (?: :\d\d )? $/x.freeze
    DEFAULT_TIMEZONE = 'Europe/Kiev'.freeze

    attr_accessor :doc
    attr_accessor :instance
    attr_accessor :fields
    attr_accessor :parent

    def initialize(instance:, doc:, fields:, parent:, options: {})
      @instance = instance
      @doc = doc
      @fields = fields
      @parent = parent
      @options = options
    end

    def parse
      fields.each do |name:, key:, type:, root:|
        value =
          if type == :datetime_combined
            datetime_combined(key)
          else
            raw_value = fetch_value(key: key, root: root)
            make_one_or_many(type, raw_value)
          end
        instance.send "#{name}=", value unless value.nil?
      end
      instance
    end

    private

    def fetch_value(key:, root:)
      target_doc = root ? doc[root] : doc
      return unless target_doc

      if key.is_a?(Regexp)
        target_doc.select { |k| k =~ key }
      elsif key.is_a?(Array)
        key.map { |k| Array(target_doc[k]) }.inject(&:+)
      else
        target_doc[key]
      end
    end

    def make_one_or_many(type, val)
      # [:type]
      if type.is_a? Array
        if val.is_a?(Array) && val[0].is_a?(Hash) && !val[0].has_key?('__content__')
          val = [val] if val[1].is_a?(String) # hack to handle attribute parsing by Ox
        end
        array(val).map { |v| make_one type.first, v }
      # :type
      else
        make_one type, val
      end
    end

    def make_one(type, val)
      return if val.nil?
      if type.is_a? Class
        type.parse(val, instance: nil, parent: instance, options: @options)
      else
        send type, val
      end
    end

    # nil => []
    # [] => []
    # {} => [{}]
    def array(arg)
      return [arg] if arg.is_a? Hash
      Array(arg)
    end

    def string(val)
      return if val == NULL_CONST
      # если это тег с атрибутами - возвращаем только содержимое тега
      return val.last if val.is_a?(Array) && val.size == 2
      val
    end

    def bool(val)
      val == TRUE_CONST
    end

    def yesno_bool(val)
      val == YES_CONST
    end

    def int(val)
      val.to_i
    end

    def date(val)
      Date.strptime(val, DATE_FORMAT_CONST)
    end

    # rubocop:disable Style/GuardClause, Style/IfUnlessModifier
    def time(val)
      if val =~ TIME_FORMAT_REGEXP
        $1
      end
    end

    def datetime(val)
      ActiveSupport::TimeZone[default_timezone].parse(val)
    end

    def datetime_combined(key)
      date_string = doc["#{key}_DATE"]
      time_string = doc["#{key}_TIME"]
      timezone = doc["#{key}_TIMEZONE"].presence || default_timezone
      ActiveSupport::TimeZone[timezone].parse("#{date_string} #{time_string}")
    end

    def default_timezone
      @options[:timezone] || DEFAULT_TIMEZONE
    end

    def decimal(val)
      BigDecimal(val)
    end
  end
end
