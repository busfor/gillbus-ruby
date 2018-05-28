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
        raise "Bad doc #{doc.inspect}" unless doc.size == 2
        instance.id = doc.first.fetch('ID')
        instance.name = doc.last
      else
        raise "Bad doc #{doc.inspect}"
      end
      instance
    end
  end
end
