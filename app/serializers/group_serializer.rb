class GroupSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :user_count
end