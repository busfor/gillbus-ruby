class Gillbus
  # not a request, neither a response part
  # just a params record for SearchTrips
  class PassengerDiscount < BaseRequest
    def self.wrap(passenger_or_params)
      return passenger_or_params if passenger_or_params.is_a? self
      new(passenger_or_params)
    end

    # passenger0birthday... passengerNbirthday (обязательный для авиаперевозки)
    # Дата рождения пассажира с порядковым номером 0...N.
    attr_accessor :birthday

    # passenger0studentTicket... passengerNstudentTicket (не обязательный)
    # Номер студенческого билета пассажира с порядковым номером 0... N.
    attr_accessor :student_ticket

    # passenger0studentYear... passengerNstudentYear (не обязательный)
    # Курс, на котором учится пассажир с порядковым номером 0...N, если он студент.
    # Для просчета более выгодной скидки.
    attr_accessor :student_year

    # passenger0ISIC...passengerNISIC (не обязательный)
    # Номер ISIC пассажира с порядковым номером 0...N.
    attr_accessor :isic

    # passenger0withSeat...passengerNwithSeat (не обязательный), boolean
    # Признак обязательного предоставления места пассажиру с порядковым номером 0…N.
    # По-умолчанию false. Если true, то пассажиру будет подобран тариф
    # с предоставлением места, если такой имеется.
    attr_accessor :with_seat

    def params(prefix = '')
      compact(
        birthday: date(birthday),
        studentTicket: student_ticket,
        studentYear: student_year,
        ISIC: isic,
        withSeat: bool(with_seat),
      ).map { |k, v| [:"#{prefix}#{k}", v] }.to_h
    end
  end
end
