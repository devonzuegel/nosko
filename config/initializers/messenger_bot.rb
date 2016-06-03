Messenger::Bot.config do |config|
  config.access_token     = ENV['fb_page_access_token']
  config.validation_token = ENV['fb_verify_token']
  config.secret_token     = ENV['fb_app_secret']
end
