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
  end

  def to_strings #Возвращает содержимое объекта в виде массива строк
  end

  def save
    file = File.new(file_path, "w:UTF-8")

    for item in to_strings do
      file.puts(item)
    end

    file.close
  end

  def file_path #Указывает путь к файлу, куда записывается объект
    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    return current_path + "/" + file_name
  end

  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = true # возвращает результат как ассоциативный массив

    db.execute(
        "INSERT INTO posts (" +
            +to_db_hash.keys.join(',') +
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

  # Получает на вход хэш массив данных и должен заполнить свои поля
  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_att'])
  end

  # Метод to_db_hash возвращает хэш вида {'имя_столбца' => 'значение'}
  # для сохранения в базу данных новой записи
  def to_db_hash
    {
        'type' => self.class.name,
        'created_att' => @created_at.to_s
    }
  end

  # Находит в базе запись по идентификатору или массив записей
  # из базы данных, который можно например показать в виде таблицы на экране
  def self.find(limit, type, id) #осуществляет поиск по БД
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)

    if id != nil
      db.results_as_hash = true #Возвращает массив ассоциативных массивов
                                #Где ключи - названия столбцов в бд

      result = db.execute("SELECT * FROM posts WHERE  rowid = ?", id)

      if result.is_a? Array
        result = result[0]
      end

      db.close

      if result.nil?
        puts "Такой id #{id} не найден в базе"
        return nil
      else
        post = create(result['type'])
        post.load_data(result)

        return post
      end

    else
      #Вернем таблицу записей

      db.results_as_hash = false #Вернет массив массивов

      # формируем запрос в базу с нужными условиями
      query = "SELECT rowid, * FROM posts "  #В результате вернется массив на первом месте будет
                                             #идентификатор записи(rowid), наверно есть проблемы с порядком
                                              #при передаче из бд в руби

      query += "WHERE type = :type " unless type == nil
      query += "ORDER by rowid DESC " # сортировка, самые свежие в начале

      query += "LIMIT :limit " unless limit.nil? # если задан лимит, надо добавить условие

      statement = db.prepare(query) #Готовим запрос в бд, метод prepare этим и занимается

      #Вствим вместо плейсхолдеров (:type, :limit) значения
      statement.bind_param('type', type) unless type == nil
      statement.bind_param('limit', limit) unless limit == nil

      result = statement.execute! # Вернется массив состоящий из элементов бд
                                  # Каждый элемент массива - массив, где элементы это столбцы в бд
                                  # rowid, type, created_att, text, url, due_date

      statement.close
      db.close

      return result
    end
  end
end