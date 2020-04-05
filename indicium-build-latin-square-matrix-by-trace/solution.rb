## INDICIUM

def run
  params = matrices_params_from_stdin

  result = build_latin_squares(params)
  result_to_stdout(result)
end

def matrices_params_from_stdin
  total_test_cases = gets.chomp.to_i
  raise 'test cases must be between 1 and 100' if total_test_cases > 100 || total_test_cases < 1

  params = []
  total_test_cases.times do
    matrix_params = gets.chomp.split(' ').map(&:to_i)
    matrix_size = matrix_params[0]
    raise 'matrix size must be between 2 and 100' if matrix_size > 50 || matrix_size < 2

    params << matrix_params
  end

  params
end

def build_latin_squares(matrices_params)
  result = []
  matrices_params.each do |matrix_params|
    matrix_size = matrix_params[0]
    expected_trace = matrix_params[1]

    if matrix_size == 2
      result << {text: 'IMPOSSIBLE'}
      next
    end

    matrix = build_matrix_by_size_and_trace(matrix_size, expected_trace)
    if matrix
      result << {
        text: 'POSSIBLE',
        matrix: matrix
      }
      next
    end

    result << {text: 'IMPOSSIBLE'}
  end

  result
end

def build_matrix_by_size_and_trace(size, expected_trace)
  matrix = build_matrix(size)
  trace = trace_by_matrix(matrix)
  return matrix if trace == expected_trace

  (size-1).times do
    matrix = matrix.map { |row| row.rotate }
    trace = trace_by_matrix(matrix)
    return matrix if trace == expected_trace
  end

  nil
end

def build_matrix(size)
  k = size + 1
  matrix = []

  1.upto size do |i|
    row = []
    value = k
    while value <= size do
      row << value
      value +=1
    end

    1.upto(k-1) { |value| row << value }

    k -= 1
    matrix << row
  end

  matrix
end

def trace_by_matrix(matrix)
  row_index = 0
  column_index = 0

  trace = 0

  while row_index < matrix.size
    row = matrix[row_index]

    trace += row[column_index]
    row_index += 1
    column_index += 1
  end

  trace
end

def result_to_stdout(result)
  result.each_with_index do |value, index|
    puts "Case ##{index+1}: #{value[:text]}"
    value[:matrix].each { |row| puts row.join(' ') } if value[:text].eql? 'POSSIBLE'
  end
end


run
