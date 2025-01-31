statuses = ['incomplete', 'doing', 'complete', 'pending']
todos = []

1_000_000.times do |i|
  todos << Todo.new(
    title: "Todo #{i + 1}",
    description: "Description for todo #{i + 1}",
    status: statuses.sample,
    position: i + 1
  )

  if todos.size >= 1000
    Todo.import(todos)
    todos = []
  end
end

Todo.import(todos) if todos.any?

puts "Successfully created 1,000,000 todos."
