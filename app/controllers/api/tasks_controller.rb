module Api
  class TasksController < ApplicationController
    before_action :set_task, only: [:show, :update, :destroy, :move]

    # GET /tasks
    def index
      limit = 100
      tasks = Task.order(:position).limit(limit)
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
      prev_task_id = params[:prev_task_id]
      prev_task = Task.find(prev_task_id) if prev_task_id
      prev_task_position = prev_task ? prev_task.position : 0

      next_task_id = params[:next_task_id]
      next_task = Task.find(next_task_id) if next_task_id

      if next_task
        new_position = (prev_task_position + next_task.position) / 2
      else
        last_position = Task.maximum(:position)
        if @task.position == last_position
          render json: { error: "Task is already in last position" }, status: :unprocessable_entity
          return
        end
        new_position = last_position + 1000
      end

      @task.update!(position: new_position)
      render json: @task
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
