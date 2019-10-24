class Gillbus
  class Seat
    extend Fields
    include UpdateAttrs

    # seat id
    field :id

    field :number

    # Тип места.
    # 0 – пустое место, ячейка прохода.
    # 1 – место заказанное.
    # 2 – заблокированное.
    # 3 – свободное.
    # 4 – забронированное.
    # 5 – проданное.
    # 6 – место под спецбронью.
    # 7 – зарегистрированное.
    # 8 – место под технической бронью.
    # 9 – приоритетное место.
    # Продажи возможно осуществлять только на места типа «3» и «9»
    field :type, :int

    field :x, :int
    field :y, :int
    field :z, :int

    def free?
      type == 3 || type == 9
    end

    def isle?
      type == 0 || type.nil?
    end
  end
end
