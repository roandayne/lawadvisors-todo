statuses = ['incomplete', 'doing', 'complete', 'pending']
tasks = []

prev_task = nil

1_000_000.times do |i|
  task = Task.new(
    title: "Task #{i + 1}",
    description: "Description for task #{i + 1}",
    status: statuses.sample,
    prev_task: prev_task,
    next_task: nil
  )

  # If there's a previous task, set its next_task to the current task
  prev_task&.update(next_task: task) if prev_task
  tasks << task

  if tasks.size >= 1000
    Task.import(tasks)
    tasks = []
  end
end

Task.import(tasks) if tasks.any?

puts "Successfully created 1,000,000 tasks."
