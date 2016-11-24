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
end