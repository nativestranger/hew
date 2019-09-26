if Rails.env.production?
  ENV["BLAZER_DATABASE_URL"] = ENV["DATABASE_URL"]
end
