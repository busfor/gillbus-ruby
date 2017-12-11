class Gillbus
  # Gives a bunch of class methods
  # to parse gillbus responses hash and define accessors
  #
  # Warning:
  #   resulting definitions won't work properly in subclass
  #
  # Usage:
  #     class MyClass
  #       extend Gillbus::Fields
  #       field :foo, :date
  #     end
  #
  #     MyClass.parse(hash)
  module Fields
    def parser_class
      if defined? @parser_class
        @parser_class || Gillbus::Parser
      else
        Gillbus::Parser
      end
    end

    def parse(doc, instance = new, parent = nil)
      instance ||= new
      parser_class.new(
        doc: doc,
        instance: instance,
        fields: field_definitions,
        parent: parent
      ).parse
      instance
    end

    def parser(&definition)
      @parser_class = Class.new(parser_class, &definition)
    end

    private

    def field_definitions
      @fields ||= []
    end

    def field(name, type=:string, key: name.to_s.upcase, root: nil)
      field_definitions << {name: name, key: key, type: type, root: root}
      attr_accessor name
    end
  end
end
