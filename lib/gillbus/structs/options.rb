class Gillbus
  class Options

    extend Fields
    include UpdateAttrs

    field :options, [:string]

    def self.parse doc
      instance = super
      instance.options = doc['OPTION']
      instance
    end
  end
end
