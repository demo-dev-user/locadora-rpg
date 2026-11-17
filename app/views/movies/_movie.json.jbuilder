json.extract! movie, :id, :title, :status, :created_at, :updated_at
json.url movie_url(movie, format: :json)
