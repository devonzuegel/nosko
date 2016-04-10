RSpec.configure do |config|
  config.include Omniauth::Mock
  config.include Omniauth::SessionHelpers, type: :feature
  config.include Utils
end
OmniAuth.config.test_mode = true
