require 'capybara/poltergeist'

Capybara.asset_host        = 'http://localhost:3000'
Capybara.javascript_driver = :poltergeist

# Capybara.register_driver :poltergeist_debug do |app|
#   Capybara::Poltergeist::Driver.new(app, :inspector => true)
# end

# Capybara.javascript_driver = :poltergeist_debug
