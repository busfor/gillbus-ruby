class Gillbus
  class TripService
    extend Fields
    include UpdateAttrs

    # уникальный идентификатор услуги со справочника
    field :id, :int, key: 'ID'

    # название услуги в автобусе
    field :name, :string, key: :__content__

    def self.parse(doc, instance: nil, parent: nil, options: {})
      instance = new
      if doc.is_a?(Array)
        raise ArgumentError, "Unable to parse TripService: #{doc.inspect}" unless doc.size == 2
        instance.id = doc.first.fetch('ID').to_i
        instance.name = doc.last
      elsif doc.is_a?(Hash) #legacy data made with MultiXML
        instance.id = doc.fetch('ID')
        instance.name = doc.fetch('__content__')
      else
        raise ArgumentError, "Unable to parse TripService: #{doc.inspect}"
      end
      instance
    end
  end
end
