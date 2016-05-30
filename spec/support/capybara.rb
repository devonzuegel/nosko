# require 'capybara/poltergeist'

# Capybara.register_driver :poltergeist do |app|
#    options = {
#       :js_errors => false ,
#       # :timeout => 120,
#       # :debug => true,
#       # :inspector => true,
#       # :window_size => [1280, 1024],
#       # :logger => false,
#       # :inspector => false,
#       # :visible => false,
#       :js => true,
#       :timeout => 10000,
#       :phantomjs_options => %w[--load-images=no]

#    }
#    Capybara::Poltergeist::Driver.new(app, options) end

# Capybara.javascript_driver = :poltergeist

#################################################################

# PORT = 8001
# Capybara.asset_host = "http://localhost:#{PORT}"
# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, browser: :phantomjs, js: true)
# end
# Capybara.javascript_driver = :selenium

# # Selenium::WebDriver.for :remote, url: "http://localhost:#{PORT}"

# # Capybara.register_driver :poltergeist do |app|
# #   Capybara::Poltergeist::Driver.new(app, {
# #     js_errors: true,
# #     inspector: true,
# #     phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],
# #     timeout: 120
# #   })
# # end

# # Capybara.javascript_driver = :poltergeist

# Capybara.server_port       = PORT
# Capybara.app_host          = "http://localhost:#{PORT}"
# # Capybara.default_wait_time = 15

# # # Capybara.register_driver :poltergeist_debug do |app|
# # #   Capybara::Poltergeist::Driver.new(app, :inspector => true)
# # # end

# # # Capybara.javascript_driver = :poltergeist_debug

