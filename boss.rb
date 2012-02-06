initializer 'generators.rb', <<-RUBY
  Rails.application.config.generators do |g|
end
RUBY

template = {"orm"=>"activerecord", "unit_testing"=>"rspec", "integration_testing"=>"cucumber", "javascript"=>"jquery", "authentication"=>"devise", "templating"=>"on", "css"=>"sass"}
recipes = template.values.flatten

def say_recipe(name); say "\033[36m" + "recipe".rjust(10) + "\033[0m" + "    Running #{name} recipe..." end
def say_wizard(text); say "\033[36m" + "wizard".rjust(10) + "\033[0m" + "    #{text}" end

@after_blocks = []
def after_bundler(&block); @after_blocks << block; end

# >-----------------------------[ ActiveRecord ]------------------------------<

# Use the default ActiveRecord database store.
say_recipe 'ActiveRecord'
# No additional code required.
# >---------------------------------[ RSpec ]---------------------------------<

# Use RSpec for unit testing for this Rails app.
say_recipe 'RSpec'

gem 'rspec-rails', '>= 2.0.1', :group => [:development, :test]

inject_into_file "config/initializers/generators.rb", :after => "Rails.application.config.generators do |g|\n" do
  "    g.test_framework = :rspec\n"
end

after_bundler do
  generate 'rspec:install'
end

# >-------------------------------[ Cucumber ]--------------------------------<

# Use Cucumber for integration testing with Capybara.
say_recipe 'Cucumber'

gem 'cucumber-rails', :group => :test
gem 'capybara', :group => :test

after_bundler do
  generate "cucumber:install --capybara#{' --rspec' if recipes.include?('rspec')}#{' -D' unless recipes.include?('activerecord')}"
end

# >--------------------------------[ jQuery ]---------------------------------<

# Adds the latest jQuery and Rails UJS helpers for jQuery.
say_recipe 'jQuery'

inside "public/javascripts" do
  get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "rails.js"
  get "http://code.jquery.com/jquery-1.5.min.js", "jquery.js"
end

application do
  "\nconfig.action_view.javascript_expansions[:defaults] = %w(jquery rails)\n"
end

gsub_file "config/application.rb", /# JavaScript.*\n/, ""
gsub_file "config/application.rb", /# config\.action_view\.javascript.*\n/, ""

# >--------------------------------[ Devise ]---------------------------------<

# Utilize Devise for authentication, automatically configured for your selected ORM.
say_recipe 'Devise'

gem 'devise'

after_bundler do
  generate 'devise:install'

  case template['orm']
    when 'mongo_mapper'
      gem 'mm-devise'
      gsub_file 'config/intializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongo_mapper_active_model'
    when 'mongoid'
      gsub_file 'config/intializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongoid'
    when 'active_record'
      # Nothing to do
      
    generate 'devise user'
  end
end

# >---------------------------------[ SASS ]----------------------------------<

# Utilize SASS (through the HAML gem) for really awesome stylesheets!
say_recipe 'SASS'

unless recipes.include? 'haml'
  gem 'haml', '>= 3.0.0'
end




# >-----------------------------[ Run Bundler ]-------------------------------<

say_wizard "Running Bundler install. This will take a while."
run 'bundle install'
say_wizard "Running after Bundler callbacks."
@after_blocks.each{|b| b.call}
