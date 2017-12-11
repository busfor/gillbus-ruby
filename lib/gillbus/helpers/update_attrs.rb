class Gillbus
  module UpdateAttrs
    def initialize(attrs={})
      update_attrs attrs if attrs
    end

    def update_attrs(attrs={})
      attrs.each do |k, v|
        public_send "#{k}=", v
      end
    end
  end
end
