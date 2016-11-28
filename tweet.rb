
require 'twitter'

class Tweet < Post

  @@CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key = "el5bwQe8PLoOXZtWnXd10RneG"
    config.consumer_secret = "wPxEPA2Z7xjpuvSfTbdE4plKuBr6137PY4T1FSvCwU3NKEcjb2"
    config.access_token = "799919582156849152-h3f0fBDIwJ6orKw0qPyQc7UpJwqwleD"
    config.access_token_secret = "KU9facUwkdyBQYhaIu10iKOUIRtZXmPqpnNPUnMMVPbjP"
  end

  def read_from_console
    puts "Новый твит (140 символов)"

    @text = STDIN.gets.chomp[0..140]

    puts "Отправляю ваш твит: #{@text.encode("UTF-8")}"

    @@CLIENT.update(@text.encode("UTF-8"))

    puts "Твит запощен"
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")}"

    return @text.unshift(time_string) # unshift добавляет в начало каждой строчки массива то что в скобочках
  end

  def to_db_hash
    return super.merge(
        {
            'text' => @text.encode("UTF-8")
        }
    )
  end

  # загружаем свои поля из хэш массива
  def load_data(data_hash)
    super(data_hash) # сперва дергаем родительский метод для общих полей

    # теперь прописываем свое специфичное поле
    @text = data_hash['text'].split('\n\r')
  end

end