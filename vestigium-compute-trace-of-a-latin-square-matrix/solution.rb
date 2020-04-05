## VESTIGIUM

def run
  matrices = build_matrices_from_stdin
  result = parse_matrices(matrices)
  response_result_to_stdout(result)
end

def build_matrices_from_stdin
  total_test_cases = gets.chomp.to_i
  raise 'test cases must be between 1 and 100' if total_test_cases > 100 || total_test_cases < 1

  matrices = []
  matrix_size = 0
  should_read_inputs = true
  while should_read_inputs do
    line = gets.chomp

    unless line.include? ' '
      matrix_size = line.to_i
      raise 'matrix size must be between 2 and 100' if matrix_size > 100 || matrix_size < 2

      matrices << []
      next
    end

    matrix = matrices.last
    values = line.split(' ').map(&:to_i)

    values.each do |v|
      message = "Invalude #{v}!!. Matrix cell value must be between 1 and #{matrix_size}"
      raise message if v < 1 || v > matrix_size
    end

    matrix << values
    matrices[matrices.size - 1] = matrix


    should_read_inputs = false if matrices.size == total_test_cases && matrix.size == matrix_size
  end

  matrices
end

def parse_matrices(matrices)
  matrices.map { |m| solve_matrix_trace m }
end

def solve_matrix_trace(matrix)
  row_index = 0
  column_index = 0

  trace = 0
  total_dup_row_values = 0
  total_dup_column_values = 0

  while row_index < matrix.size
    row = matrix[row_index]
    total_dup_row_values += 1 if row.uniq.size  < row.size

    trace += row[column_index]
    row_index += 1
    column_index += 1
  end

  0.upto(matrix.size - 1) do |column_index|
    uniq_value = {}
    matrix.each do |row|
      column_value = row[column_index]
      if uniq_value[column_value]
        total_dup_column_values += 1
        break
      end

      uniq_value[column_value] = 1
    end
  end

  {
    trace: trace,
    total_dup: {
      row_values: total_dup_row_values,
      column_values: total_dup_column_values
    }
  }
end

def response_result_to_stdout(result)
  result.each_with_index do |value, index|
    puts "Case ##{index+1}: #{value[:trace]} #{value[:total_dup][:row_values]} #{value[:total_dup][:column_values]}"
  end
end

run