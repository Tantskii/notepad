class Memo < Post

  def read_from_console
    puts "Новая заметка (буду записывать строки до слова \"end\") "

    @text = []

    line = nil

    while line != "end" do
      line = STDIN.gets.chomp

      @text << line
    end

    @text.pop
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")}"

    return @text.unshift(time_string) # unshift добавляет в начало каждой строчки массива то что в скобочках
  end

  def to_db_hash
    return super.merge(
                    {
                        'text' => @text.join('\n\r')
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