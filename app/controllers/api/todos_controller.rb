module Api
  class TodosController < ApplicationController
    before_action :set_todo, only: [:show, :update, :destroy, :move]

    # GET /todos
    def index
      todos = Todo.order(:position).limit(100) # Pagination to prevent slow queries
      render json: todos
    end

    # GET /todos/:id
    def show
      render json: @todo
    end

    # POST /todos
    def create
      last_position = Todo.maximum(:position) || 0
      @todo = Todo.new(todo_params.merge(position: last_position + 1))

      if @todo.save
        render json: @todo, status: :created
      else
        render json: @todo.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /todos/:id
    def update
      if @todo.update(todo_params)
        render json: @todo
      else
        render json: @todo.errors, status: :unprocessable_entity
      end
    end

    # DELETE /todos/:id
    def destroy
      if @todo.soft_delete
        render json: { message: 'Todo deleted successfully' }
      else
        render json: { error: 'Failed to delete todo' }, status: :unprocessable_entity
      end
    end

    # PATCH /todos/:id/move
    def move
      new_position = params[:position].to_i

      # Ensure the new position is valid (greater than 0 and not already taken)
      if new_position < 1
        render json: { error: "Invalid position" }, status: :unprocessable_entity
        return
      end

      # Check if the new position is already taken
      if Todo.exists?(position: new_position)
        render json: { error: "Position already taken" }, status: :unprocessable_entity
        return
      end

      ActiveRecord::Base.transaction do
        # Reorder the other todos
        if new_position > @todo.position
          Todo.where("position > ? AND position <= ?", @todo.position, new_position).update_all("position = position - 1")
        else
          Todo.where("position >= ? AND position < ?", new_position, @todo.position).update_all("position = position + 1")
        end

        @todo.update!(position: new_position)
      end

      render json: @todo
    end


    private

    def set_todo
      @todo = Todo.find(params[:id])
    end

    def todo_params
      params.require(:todo).permit(:title, :description, :status, :position)
    end
  end
end
