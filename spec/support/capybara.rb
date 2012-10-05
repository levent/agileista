require "capybara/rails"
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
Capybara.default_host = "http://app.agileista.local"
