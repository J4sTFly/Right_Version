object@news
attributes :id, :title, :abstract, :body, :location, :published_at, :important, :comments

child author: :author do
    attributes :id, :username, :name
end

child comments: :comments do
    attributes :id, :body
    child user: :user do
        attributes :id, :username
    end
end