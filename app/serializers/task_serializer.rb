class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :position
end