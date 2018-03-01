class Gillbus
  class BusPhoto
    extend Fields
    include UpdateAttrs

    # => "https://busfor-gds-production.s3-eu-central-1.amazonaws.com/ImagesBuses/4764FC6955D3204EE0530300F00AF0E8/mercedes_aa_5939_aa.jpg"
    field :original_url

    # => "https://busfor-gds-production.s3-eu-central-1.amazonaws.com/ImagesBuses/4764FC6955D3204EE0530300F00AF0E8/Thumb/_mercedes_aa_5939_aa.jpg"
    field :thumbnail_url
  end
end
