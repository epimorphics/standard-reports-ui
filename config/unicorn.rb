if ENV["RAILS_ENV"] == "development"
  worker_processes 1
else
  #worker_processes 3
  worker_processes 1
end

timeout 300
listen 3000
