class Link < Post

  def initialize
    super #Берется метод с таким же названием у родительсокго класса

    @url = ''
  end

  def read_from_console
    puts 'Введите адрес ссылки'

    @url = STDIN.gets.chomp

    puts "Опишите ссылку"

    @text = STDIN.gets.chomp
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")}"

    return [@url, @text, time_string]
  end

  def to_db_hash
    return super.merge(
                    {
                        'text' => @text,
                        'url' => @url
                    }
    )
  end

  # загружаем свои поля из хэш массива
  def load_data(data_hash)
    super(data_hash) # сперва дергаем родительский метод для общих полей

    # теперь прописываем свое специфичное поле
    @url = data_hash['url']
  end
end