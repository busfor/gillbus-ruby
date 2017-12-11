require 'bigdecimal'
require 'active_support/time'

class Gillbus
  class Parser
    attr_accessor :doc
    attr_accessor :instance
    attr_accessor :fields
    attr_accessor :parent

    def initialize(instance:, doc:, fields:, parent:)
      @instance = instance
      @doc = doc
      @fields = fields
      @parent = parent
    end

    def parse
      fields.each do |name:, key:, type:, root:|
        raw_value =
          if key.is_a?(Regexp)
            doc.select { |k| k =~ key }
          elsif root
            doc[root] && doc[root][key]
          else
            doc[key]
          end
        value = make_one_or_many(type, raw_value)
        instance.send "#{name}=", value unless value.nil?
      end
      instance
    end

  private

    def make_one_or_many(type, val)
      # [:type]
      if type.is_a? Array
        array(val).map {|v| make_one type.first, v }
      # :type
      else
        make_one type, val
      end
    end

    def make_one(type, val)
      return if val.nil?
      if type.is_a? Class
        type.parse(val, nil, instance)
      else
        send type, val
      end
    end

    private

    # nil => []
    # [] => []
    # {} => [{}]
    def array(arg)
      return [arg] if arg.is_a? Hash
      Array(arg)
    end

    def string(val)
      return if val == "null"
      val
    end

    def bool(val)
      val == "true"
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

    def time(val)
      if val =~ /^ ( \d\d:\d\d ) (?: :\d\d )? $/x
        $1
      else
        nil
      end
    end

    def datetime(val)
      ActiveSupport::TimeZone["Europe/Kiev"].parse(val)
    end

    def decimal(val)
      BigDecimal.new(val)
    end
  end
end
