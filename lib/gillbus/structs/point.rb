class Gillbus
  class Point
    extend Fields
    include UpdateAttrs

    # => "0"
    field :number

    # => "Москва"
    field :geography_name

    # => "м. \"Речной Вокзал\""
    field :name

    # => "ул. Фестивальная, дом 11, метро \"Речной Вокзал\""
    field :address

    # => "10.10.2014"
    field :arrival_date, :date

    # => nil
    field :arrival_time, :time

    # => "10.10.2014"
    field :dispatch_date, :date

    # => "22:50"
    field :dispatch_time, :time

    # => "false"
    field :check_point, :bool

    # Признак наличия пересадки в пункте
    # => "false"
    field :transfer_point, :bool
  end
end
