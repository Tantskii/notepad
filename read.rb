if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require_relative 'post.rb'
require_relative 'task.rb'
require_relative 'memo.rb'
require_relative 'link.rb'

# id, limit, type

require 'optparse' #библиотека для обработки параметров из командной строки

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'какой тип постов показывать (по умолчанию любой)') { |o| options[:type] = o } #
  opt.on('--id POST_ID', 'если задан id — показываем подробно только этот пост') { |o| options[:id] = o } #
  opt.on('--limit NUMBER', 'сколько последних постов показать (по умолчанию все)') { |o| options[:limit] = o } #

end.parse!

result = Post.find(options[:limit], options[:type], options[:id])

#1 Если попросили вывести конкретный пост и указали его id
if result.is_a? Post
  puts "Запись #{result.class.name} id: #{options[:id]}"

  result.to_strings.each do |line|
    puts line
  end
else
  #2 показываем таблицу результатов
  print "| id\t| @type\t|  @created_at\t\t\t|  @text \t\t\t| @url\t\t| @due_date \t "

  result.each do |row|
    puts
    puts " "*80

    row.each do |element|
      print "|  #{element.to_s[0..40]}\t"
    end
  end
end


