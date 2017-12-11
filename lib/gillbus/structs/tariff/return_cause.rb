class Gillbus
  class Tariff
    class ReturnCause
      extend Fields
      include UpdateAttrs

      field :lossless, :bool

      field :cause, :string

      def self.parse(doc, _ = nil, _ = nil)
        instance = super
        if doc.kind_of? Hash
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
