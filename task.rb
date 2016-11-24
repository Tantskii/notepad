require 'date'

class Task < Post

  def initialize
    super

    @due_date = Time.now
  end

  def read_from_console
    puts "Что надо сделать?"

    @text = STDIN.gets.chomp

    puts "До какого числа необходимо закончить? ДД.ММ.ГГГГ, например 12.04.2007"
    line = STDIN.gets.chomp

    @due_date = Date.parse(line)
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")}"

    deadline = "Крайний срок: #{@due_date}"

    return [deadline, @text, time_string]
  end

  def to_db_hash
    return super.merge(
                    {
                        'text' => @text,
                        'due_date' => @due_date.to_s
                    }
    )
  end

end