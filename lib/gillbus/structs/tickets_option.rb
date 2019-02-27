class Gillbus
  class TicketsOption
    extend Fields
    include UpdateAttrs

    # идентификатор опции
    field :id, :int, key: 'ID'

    # текст опции
    field :text, :string, key: :__content__

    def self.parse(doc, instance: nil, parent: nil, options: {})
      instance = new
      if doc.is_a?(String)
        instance.text = doc
      elsif doc.is_a?(Array)
        raise ArgumentError, "Unable to parse TicketsOption: #{doc.inspect}" unless doc.size == 2
        instance.id = doc.first.fetch('ID').to_i
        instance.text = doc.last
      elsif doc.is_a?(Hash) #legacy data made with MultiXML
        instance.id = doc.fetch('ID')
        instance.text = doc.fetch('__content__')
      else
        raise ArgumentError, "Unable to parse TicketsOption: #{doc.inspect}"
      end
      instance
    end
  end
end
