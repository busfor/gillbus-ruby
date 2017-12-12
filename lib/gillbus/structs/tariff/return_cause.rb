class Gillbus
  class Tariff
    class ReturnCause
      extend Fields
      include UpdateAttrs

      field :lossless, :bool

      field :cause, :string

      # rubocop:disable Lint/UnusedMethodArgument
      def self.parse(doc, instance: nil, parent: nil, options: {})
        instance = super
        if doc.is_a? Hash
          instance.cause = doc['__content__']
          instance.lossless = doc['lossless'] == 'true'
        else
          instance.cause = doc
          instance.lossless = false
        end
        instance
      end
    end
  end
end
