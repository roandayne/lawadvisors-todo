statuses = ['incomplete', 'doing', 'complete', 'pending']
tasks = []

prev_task = nil

1_000_000.times do |i|
  tasks << Task.new(
    title: "Task #{i + 1}",
    description: "Description for task #{i + 1}",
    status: statuses.sample,
    position: (i + 1) * 1000
  )

  if tasks.size >= 1000
    Task.import(tasks)
    tasks = []
  end
end

Task.import(tasks) if tasks.any?

puts "Successfully created 1,000,000 tasks."
