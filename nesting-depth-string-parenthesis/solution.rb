def run
  params = read_strings_from_stdin

  result = build_strings_parenthesis(params)
  result_to_stdout(result)
end

def read_strings_from_stdin
  total_test_cases = gets.chomp.to_i
  raise 'test cases must be between 1 and 100' if total_test_cases > 100 || total_test_cases < 1

  strings = []
  total_test_cases.times do
    string = gets.chomp
    raise 'string size must be between 1 and 100' if string.size > 100 || string.size < 1

    strings << string
  end

  strings
end

def build_strings_parenthesis(strings)
  strings.map do |string|
    if string.to_i == 0
      string
    else
      grouped_chars = []
      string.chars.each_with_index do |char, index|
        last_char = grouped_chars.last

        if last_char && last_char.include?(char)
          grouped_chars[grouped_chars.size - 1] << char
          next
        end
        grouped_chars << char
      end

      grouped_chars.map do |grouped_char|
        char_to_int = grouped_char[0].to_i
        "#{'(' * char_to_int}#{grouped_char}#{')' * char_to_int}"
      end
      .join.gsub(')(', '')
    end
  end
end

def result_to_stdout(result)
  result.each_with_index do |value, index|
    puts "Case ##{index+1}: #{value}"
  end
end

run