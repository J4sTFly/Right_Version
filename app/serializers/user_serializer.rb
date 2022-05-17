class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :username, :email

  attribute :created_date do Time.now
  end
end
