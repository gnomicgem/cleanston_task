class PluralizeWordService
  def initialize(number, krokodil, krokodila, krokodilov)
    @number = number
    @krokodil = krokodil
    @krokodila = krokodila
    @krokodilov = krokodilov
  end

  def call
    if @number == nil || !@number.is_a?(Numeric)
      @number == 0
    end

    remainder_100 = @number % 100

    if remainder_100 >= 11 && remainder_100 <= 14
      return @krokodilov
    end

    remainder_10 = @number % 10

    if remainder_10 == 1
      return @krokodil
    end

    if remainder_10 >= 2 && remainder_10 <= 4
      return @krokodila
    end

    if remainder_10 > 4 || remainder_10 == 0
      @krokodilov
    end
  end
end
