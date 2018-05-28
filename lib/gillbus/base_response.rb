require 'ox'

class Gillbus
  class BaseResponse
    extend Fields
    include UpdateAttrs

    attr_accessor :data
    attr_accessor :session_id

    attr_accessor :error_code
    attr_accessor :error_message
    attr_accessor :external_error_message
    attr_accessor :request_time

    def error?
      !error_code.nil?
    end

    def self.parse(data, instance: new, options: {})
      # ugly
      if data['MESSAGE']
        instance.error_code = data['MESSAGE']['CODE'].to_i
        instance.error_message = data['MESSAGE']['TEXT']
        instance.external_error_message = data['MESSAGE']['EXT_TEXT']
      else
        super(data, instance: instance, options: options)
      end
      # for debugging?
      instance.data = data
      instance
    end

    def self.parse_string(xml_string, **options)
      xml = Ox.load(xml_string, mode: :hash, symbolize_keys: false)
      # <DATA/> is a valid response
      return ParseError.new(xml_string, 'DATA attribute missing') unless xml.key?('DATA')
      data = xml['DATA'] || {}
      parse(data, instance: new, options: options)
    rescue Ox::ParseError, ArgumentError => e
      ParseError.new(xml_string, e.message)
    end
  end
end
