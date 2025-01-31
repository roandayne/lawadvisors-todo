class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :position
end