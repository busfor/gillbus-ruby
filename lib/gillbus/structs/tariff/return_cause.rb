class Gillbus
  class Tariff
    class ReturnCause
      LOSSLESS = 'lossless'.freeze

      extend Fields
      include UpdateAttrs

      field :lossless, :bool

      field :cause, :string

      # rubocop:disable Lint/UnusedMethodArgument
      def self.parse(doc, instance: nil, parent: nil, options: {})
        instance = new
        if doc.is_a?(Array) && doc.size == 2 && doc.first.is_a?(Hash) && doc.last.is_a?(String)
          instance.lossless = doc.first[LOSSLESS] == Parser::TRUE_CONST
          instance.cause = doc.last
        elsif doc.is_a?(Hash) && doc.has_key?('__content__')
          instance.lossless = (doc['lossless'] == 'true')
          instance.cause = doc['__content__']
        else
          instance.cause = doc
          instance.lossless = false
        end
        instance
      end
    end
  end
end
