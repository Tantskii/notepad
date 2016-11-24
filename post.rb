require 'sqlite3'

class Post

  @@SQLITE_DB_FILE = 'notepad.sqlite'

  def self.post_types #Объявление статического метода
    {'Memo' => Memo, 'Link' => Link, 'Task' => Task}
  end

  def self.create(types)
    return post_types[types].new
  end

  def initialize
    @created_at = Time.now
    @text = nil
  end

  def read_from_console
    #to do
  end

  def to_strings    #Возвращает содержимое объекта в виде массива строк
    #to do
  end

  def save
    file = File.new(file_path, "w:UTF-8")

    for item in to_strings do
      file.puts(item)
    end

    file.close
  end

  def file_path  #Указывает путь к файлу, куда записывается объект
    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    return current_path + "/" + file_name
  end

  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = true # возвращает результат как ассоциативный массив

    db.execute(
        "INSERT INTO posts (" +
        + to_db_hash.keys.join(',') +
        ")" +
        " VALUES (" +
        ('?,'*to_db_hash.size).chomp(',') +
        ")",
        to_db_hash.values
    )

    insert_row_id = db.last_insert_row_id

    db.close

    return insert_row_id
  end


  def to_db_hash
   {
       'type' => self.class.name,
       'created_att' => @created_at.to_s
   }
  end
end