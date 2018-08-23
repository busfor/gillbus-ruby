class Gillbus
  class Carrier
    extend Fields
    include UpdateAttrs

    field :id, key: 'CARRIER_ID'
    field :name, key: 'CARRIER_NAME'
    field :legal_name, key: 'CARRIER_LEGAL_NAME'
    field :inn
  end
end
