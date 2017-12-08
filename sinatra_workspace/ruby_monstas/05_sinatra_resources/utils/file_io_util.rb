def save_name(filename, string)
  File.open(filename, 'a+') do |file|
    file.puts(string)
  end
end

def read_names(filename)
  return [] unless File.exists?(filename)
  File.read(filename).split("\n")
end

def update_name(filename, old_name, new_name)
  File.write(filename, File.read(filename).gsub(old_name, new_name))
end

def remove_name(filename, name)
  old_lines = File.readlines(filename)
  new_lines = old_lines.reject { |line| line =~ /#{name}/ }
  File.open(filename, 'w') do |file|
    new_lines.each do |line|
      file.write line
    end
  end
end