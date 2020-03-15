require 'pathname'

class App
  def self.run
    Dir.glob('*.in').sort.each do |file_name|
      run_file(file_name)
    end
  end

  def self.run_file(file_name)
    file_path = Pathname.new(file_name)
    max_slices = 0
    total_types = 0

    output_file = File.open("#{file_name.split('.').first}.out", 'w')
    File.readlines(file_path).each_with_index do |line, index|
      line_components = line.split(/ /)
      if index == 0
        max_slices = line_components.first.to_i
        total_types = line_components.last.to_i
      else
        order = Order.new(max_slices, total_types)
        result = order.process(line_components.map(&:to_i))

        output_file.puts result[:number_of_pizzas]
        output_file.puts result[:pizza_types]

        output_file.close
      end
    end
  end
end

class Order
  def initialize(max_slices, total_types)
    @max_slices = max_slices
    @total_types = total_types
  end

  def process(slices_list)
    return SubSetSum.new(slices_list, max_slices).result
  end

  private

  def max_slices
    @max_slices
  end
end

class SubSetSum
  def initialize(numbers_list, target_sum_number)
    @numbers_list = numbers_list
    @target_sum_number = target_sum_number
    @best_indexes = []
    @best_sum = 0
  end

  def result
    raise(TypeError, "numbers_list must be an array of Integers") unless numbers_list.is_a?(Array)
    raise(TypeError, "target_sum_number must be an Integer") unless target_sum_number.is_a?(Integer)

    set_size = numbers_list.size
    half_size = set_size / 2
    half_size += 1 if set_size.odd?
    downto_index = set_size - 1
    upto_index = 0

    while downto_index >= half_size do
      while upto_index < set_size do
        indexes = []

        if upto_index == downto_index #avoid to sum duplicated combination
          downto_index -= 1
          upto_index = 0
          break
        end

        downto_value = numbers_list[downto_index]
        upto_value = numbers_list[upto_index]
        sum = (downto_value + upto_value)

        indexes.push(downto_index, upto_index)

        if sum == target_sum_number #exit if match
          save_answer(sum, indexes)
          return final_answer
        end

        if upto_index > 0
          (0..(upto_index - 1)).to_a.each do |subset_upto_index|
            subset_upto_value = numbers_list[subset_upto_index]
            sum += subset_upto_value

            indexes.push(subset_upto_index)
            if sum == target_sum_number #exit if match
              save_answer(sum, indexes)
              return final_answer
            end
          end
        end

        if sum > target_sum_number
          downto_index -= 1
          upto_index = 0
          break
        end

        if sum > best_sum
          save_answer(sum, indexes)
        end

        upto_index += 1
      end

      downto_index -= 1
    end

    final_answer
  end

  private

  def numbers_list
    @numbers_list
  end

  def best_sum
    @best_sum
  end

  def target_sum_number
    @target_sum_number
  end

  def save_answer(sum, indexes)
    @best_sum = sum
    @best_indexes = indexes
  end

  def final_answer
    { best_sum: @best_sum,
      number_of_pizzas: @best_indexes.size,
      pizza_types: @best_indexes.sort.join(' ') }
  end
end

App.run