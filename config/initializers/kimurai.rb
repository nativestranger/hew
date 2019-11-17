Kimurai.configure do |config|
  # Default logger has colored mode in development.
  # If you would like to disable it, set `colorize_logger` to false.
  # config.colorize_logger = false

  # Logger level for default logger:
  # config.log_level = :info

  # Custom logger:
  # config.logger = Logger.new(STDOUT)

  # Custom time zone (for logs):
  # config.time_zone = "UTC"
  # config.time_zone = "Europe/Moscow"

  if Rails.env.production?
    # Provide custom chrome binary path (default is any available chrome/chromium in the PATH):
    config.selenium_chrome_path = "/app/.apt/usr/bin/google-chrome"
    # Provide custom selenium chromedriver path (default is "/usr/local/bin/chromedriver"):
    config.chromedriver_path = "/app/.chromedriver/bin/chromedriver"
  end
end
