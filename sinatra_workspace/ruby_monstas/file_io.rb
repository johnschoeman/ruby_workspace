# File.write('text.txt', File.read('text.txt').gsub(/two/, 'four'))

def update_name(filename, old_name, new_name)
  File.write(filename, File.read(filename).gsub(old_name, new_name))
end

update_name('text.txt', 'three', 'two')

def remove_name(filename, name)
  old_lines = File.readlines(filename)
  new_lines = old_lines.reject { |line| line =~ /#{name}/ }
  File.open(filename, 'w') do |file|
    new_lines.each do |line|
      file.write line
    end
  end
end

remove_name('text.txt', 'four')