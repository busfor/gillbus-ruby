class Gillbus
  class Tariff
    class ReturnCause
      extend Fields
      include UpdateAttrs

      field :lossless, :bool

      field :cause, :string

      # rubocop:disable Lint/UnusedMethodArgument
      def self.parse(doc, instance: nil, parent: nil, options: {})
        instance = new
        if doc.is_a?(Array)
          raise ArgumentError, "Unable to parse Tariff::ReturnCause: #{doc.inspect}" unless doc.size == 2
          instance.lossless = doc.first == {'lossless' => 'true'}
          instance.cause = doc.last
        else
          instance.cause = doc
          instance.lossless = false
        end
        instance
      end
    end
  end
end
