# frozen_string_literal: true

class Interface
  def enter_name
    print 'Введите ваше имя: '
    gets.strip.capitalize
  end
end
