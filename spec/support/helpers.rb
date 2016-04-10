RSpec.configure do |config|
  config.include EvernoteClient::Mock
  config.include Omniauth::Mock
  config.include Omniauth::SessionHelpers, type: :feature
  config.include Utils
end
OmniAuth.config.test_mode = true
