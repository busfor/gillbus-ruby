require 'multi_xml'

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

    def self.parse(data, instance: new, options: options)
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
      xml = MultiXml.parse(xml_string)
      # <DATA/> is a valid response
      return ParseError.new(xml_string) unless xml.key?('DATA')
      data = xml['DATA'] || {}
      parse(data, instance: new, options: options)
    rescue MultiXml::ParseError, ArgumentError
      ParseError.new(xml_string)
    end
  end
end
