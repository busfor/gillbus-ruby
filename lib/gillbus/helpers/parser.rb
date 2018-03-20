require 'bigdecimal'
require 'active_support/time'

class Gillbus
  class Parser
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
      if key.is_a?(Regexp)
        doc.select { |k| k =~ key }
      elsif root
        doc[root] && doc[root][key]
      else
        doc[key]
      end
    end

    def make_one_or_many(type, val)
      # [:type]
      if type.is_a? Array
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
      return if val == 'null'
      val
    end

    def bool(val)
      val == 'true'
    end

    def yesno_bool(val)
      val == 'Y'
    end

    def int(val)
      val.to_i
    end

    def date(val)
      Date.strptime(val, '%d.%m.%Y')
    end

    # rubocop:disable Style/GuardClause, Style/IfUnlessModifier
    def time(val)
      if val =~ /^ ( \d\d:\d\d ) (?: :\d\d )? $/x
        $1
      end
    end

    def datetime(val)
      ActiveSupport::TimeZone[default_timezone].parse(val)
    end

    def datetime_combined(key)
      date_string = doc["#{key}_DATE"]
      time_string = doc["#{key}_TIME"]
      timezone = doc["#{key}_TIMEZONE"] || default_timezone
      ActiveSupport::TimeZone[timezone].parse("#{date_string} #{time_string}")
    end

    def default_timezone
      @options[:timezone] || 'Europe/Kiev'
    end

    def decimal(val)
      BigDecimal.new(val)
    end
  end
end
