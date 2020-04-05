## PARENR

def run
  tasks_groups = build_tasks_groups_from_stdin
  result = process_tasks_groups(tasks_groups)
  result_to_stdout(result)
end

def build_tasks_groups_from_stdin
  total_test_cases = gets.chomp.to_i
  raise 'test cases must be between 1 and 100' if total_test_cases > 100 || total_test_cases < 1

  should_read_inputs = true
  max_task_time = 24 * 60
  tasks_groups = []

  while should_read_inputs do
    line = gets.chomp

    unless line.include? ' '
      total_tasks = line.to_i
      raise 'total of activities must be between 2 and 1000' if total_tasks > 1000 || total_tasks < 2

      tasks_groups << []
      next
    end

    tasks = tasks_groups.last
    times = line.split(' ').map(&:to_i)
    start_time = times[0]
    end_time = times[1]

    if start_time > max_task_time || end_time > max_task_time
      raise "Invalude #{v}!!. Task Time value must be between 0 and #{max_task_time}"
    elsif start_time >= end_time
      raise "Invalude #{v}!!. Start time must be lower than end time"
    end

    tasks << times


    should_read_inputs = false if tasks_groups.size == total_test_cases && tasks.size == total_tasks
  end

  tasks_groups
end

def process_tasks_groups(tasks_groups)
  tasks_groups.map { |tasks| assign_tasks(tasks) }
end

def assign_tasks(tasks)
  assigned_tasks = []
  workers = {
    C: [],
    J: []
  }

  tasks.each do |task|
    start_time = task[0]
    end_time = task[1]

    workers.each do |worker, worker_tasks|
      if worker_tasks.empty?
        workers[worker] << task
        assigned_tasks << worker
        break
      end

      has_task_assigend = false
      worker_tasks.each do |worker_task|
        wt_start_time = worker_task[0] # 99
        wt_end_time = worker_task[1] # 150


        if start_time >= wt_end_time || end_time <= wt_start_time
          workers[worker] << task
          assigned_tasks << worker
          has_task_assigend = true
          break
        end
      end

      break if has_task_assigend
    end
  end

  return ['IMPOSSIBLE'] if assigned_tasks.size < tasks.size

  assigned_tasks
end

def result_to_stdout(result)
  result.each_with_index { |value, index| puts "Case ##{index+1}: #{value.join(' ')}"}
end

run