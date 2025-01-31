module Api
  class TasksController < ApplicationController
    before_action :set_tasks, only: [:show, :update, :destroy, :move]

    # GET /tasks
    def index
      limit = params[:limit] or 1_000
      offset_id = params[:offset_id]
      query = <<-SQL
        WITH RECURSIVE traverse(id, title, description, status, prev_task_id, next_task_id) AS (
          SELECT id, title, description, status, prev_task_id, next_task_id
          FROM tasks
          WHERE #{offset_id ? "id = ?" : "prev_task_id IS NULL"}
          UNION ALL
          SELECT t.id, t.title, t.description, t.status, t.prev_task_id, t.next_task_id
          FROM tasks t
          INNER JOIN traverse trav ON trav.id = t.id
        )
        SELECT id, title, description, status
        FROM traverse
        LIMIT ?
      SQL
      params = offset_id ? [offset_id, limit] : [limit]
      tasks = Task.find_by_sql([query, *params])
      render json: tasks
    end

    # GET /tasks/:id
    def show
      render json: @task
    end

    # POST /tasks
    def create
      last_position = Task.maximum(:position) || 0
      @task = Task.new(task_params.merge(position: last_position + 1))

      if @task.save
        render json: @task, status: :created
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /tasks/:id
    def update
      if @task.update(task_params)
        render json: @task
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    # DELETE /tasks/:id
    def destroy
      if @task.soft_delete
        render json: { message: 'Task deleted successfully' }
      else
        render json: { error: 'Failed to delete task' }, status: :unprocessable_entity
      end
    end

    # PATCH /tasks/:id/move
    def move
      new_prev_id = params[:prev_task_id]
      @task.move_after(new_prev_id)
      render json: @task.todo_list.tasks
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :status, :position)
    end
  end
end
