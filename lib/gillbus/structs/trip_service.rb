class Gillbus
  class TripService

    extend Fields
    include UpdateAttrs

    # уникальный идентификатор услуги со справочника
    field :id, :int, key: 'ID'

    # название услуги в автобусе
    field :name, :string, key: '__content__'

  end
end
