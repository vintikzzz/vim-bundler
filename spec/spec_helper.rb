require 'rubygems'
require 'spork'
require 'rr'


Spork.prefork do
  RUBY_HEAP_MIN_SLOTS=500000
  RUBY_HEAP_SLOTS_INCREMENT=500000
  RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
  RUBY_GC_MALLOC_LIMIT=100000000 
  RUBY_HEAP_FREE_MIN=500000
  # require "rails/application"
  # Spork.trap_method(Rails::Application, :reload_routes!)
  # require 'rails/mongoid'
  # Spork.trap_class_method(Rails::Mongoid, :load_models)
  ENV['RACK_ENV'] ||= "rspec"
  require File.expand_path(File.dirname(__FILE__) + "/../lib/vim-bundler")
  # require File.expand_path("../../config/environment", __FILE__)
  # require 'rspec/rails'

  # # Requires supporting ruby files with custom matchers and macros, etc,
  # # in spec/support/ and its subdirectories.
  # Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.backtrace_clean_patterns = [
      /\/lib\d*\/ruby\//,
      /bin\//,
      #/gems/,
      /spec\/spec_helper\.rb/,
      /lib\/rspec\/(core|expectations|matchers|mocks)/
    ]
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    config.mock_with :rr
    # config.mock_with :rspec
    


    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # config.use_transactional_fixtures = true
    # require 'database_cleaner'
    #
  end
  
end

Spork.each_run do
  RSpec.configure do |config|
    config.before(:each) do
      VimBundler.ui = VimBundler::UI.new(stub!.say.subject)
    end
  end
end
