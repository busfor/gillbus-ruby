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
      ! error_code.nil?
    end

    def self.parse(data, instance=new)
      # ugly
      if data["MESSAGE"]
        instance.error_code = data["MESSAGE"]["CODE"].to_i
        instance.error_message = data["MESSAGE"]["TEXT"]
        instance.external_error_message = data["MESSAGE"]["EXT_TEXT"]
      else
        super(data, instance)
      end
      # for debugging?
      instance.data = data
      instance
    end

    def self.parse_string(xml_string)
      xml = MultiXml.parse(xml_string)
      # <DATA/> is a valid response
      xml.key?("DATA") or return ParseError.new(xml_string)
      data = xml["DATA"] || {}
      parse(data)
    rescue MultiXml::ParseError, ArgumentError
      ParseError.new(xml_string)
    end
  end
end
