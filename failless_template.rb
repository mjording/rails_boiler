# HTML 5 Boiler Plate
#apply 'https://gist.github.com/806066.txt'
# Rails 3 simple template
# USE ONLY ON EMPTY APPS - USAGE:rails new app_name -m rails3-templates/base.rb 

#Set up .gitignore files
run 'rm .gitignore'
run 'touch tmp/.gitignore log/.gitignore vendor/.gitignore'
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
vendor/rails
#vim swap file
**.swp
**.swo
**.swn
**.*~

END

# get the gems
run "rm Gemfile"
file 'Gemfile', <<-FILE
source 'http://rubygems.org'
gem 'rails', '3.2.1'
#gem 'haml-rails'
gem 'sass'
gem 'devise'
gem 'oa-oauth', :require => 'omniauth/oauth'
gem 'rails3-generators'
gem 'rack-cache', :require => 'rack/cache'
gem 'carrierwave'
gem 'resque'
#gem 'dynamic_form'
gem 'simple_form'
gem 'mini_magick'
#gem 'meta-search'
gem 'pg'
gem 'jquery-rails'


group :development, :test do
  #gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'unicorn'
  gem 'ruby-debug19'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'rspec-rails'
  gem 'pickler'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'faker'
end
group :test do
  gem 'testify'
end

FILE


# Remove Default
#run 'mv public/index.html public/test-rails3.html'

#inside('public/javascripts') do
 ## FileUtils.rm_rf %w(controls.js dragdrop.js effects.js prototype.js rails.js)
  ## Download latest jQuery.min
  #get "http://code.jquery.com/jquery-latest.min.js", "public/javascripts/jquery.js"

  ## Download latest jQuery drivers
  #get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"


#end


# Remove jQuery Comments in application.rb
#gsub_file 'config/application.rb', /#\s*(JavaScript files you want as :defaults (application.js is always included).)/, '\1'
gsub_file 'config/application.rb', /#\s*(config.action_view.javascript_expansions[:defaults] = %w(jquery rails application))/, '\1'


# Install HTML5-Boilerplate

inside '~/src' do
  run 'git clone git://github.com/h5bp/html5-boilerplate.git' unless File.directory? "html5-boilerplate"
end

inside "public" do
  #run "git clone http://github.com/paulirish/html5-boilerplate.git"
  run 'cp -R ~/src/html5-boilerplate/* .'
  #run 'rm js/*'
  #run 'mv javascripts/libs/* javascripts/'
  run 'mv css/* stylesheets/'
  run 'rm -Rf js css html5-boilerplate'
  #run 'mv index.html example-html5b.html'
  inside "javascripts" do
    #run "mv jquery-*.min.js jquery.js"
    run "mv modernizr-* modernizr.js"  
  end
  
end

run 'rm app/views/layouts/application.html.erb'

file 'app/views/layouts/application.html.erb', <<-FILE
<!DOCTYPE html>
<html>
<head>
  <title>App</title>
  <%= stylesheet_link_tag :all %>
  <%= javascript_include_tag :all %>

	<%= yield(:head) %>

  <%= csrf_meta_tag %>
</head>
<body>
  <div id='container'>
    <%= yield %>
  </div>

</body>
</html>


FILE

file 'public/stylesheets/application.css', <<-FILE

#flash_notice {
  background-color: #CFC;
  border: solid 1px #6C6;
}

#flash_error {
  background-color: #FCC;
  border: solid 1px #C66;
}

.fieldWithErrors {
  display: inline;
}

#errorExplanation {
  width: 400px;
  border: 2px solid #CF0000;
  padding: 0px;
  padding-bottom: 12px;
  margin-bottom: 20px;
  background-color: #f0f0f0;
}

#errorExplanation h2 {
  text-align: left;
  font-weight: bold;
  padding: 5px 5px 5px 15px;
  font-size: 12px;
  margin: 0;
  background-color: #c00;
  color: #fff;
}

#errorExplanation p {
  color: #333;
  margin-bottom: 0;
  padding: 8px;
}

#errorExplanation ul {
  margin: 2px 24px;
}

#errorExplanation ul li {
  font-size: 12px;
  list-style: disc;
}
FILE

run 'mv public/index.html public/test-rails3.html'
# Install JQuery
#inside "public/javascripts" do
  #run "wget https://github.com/rails/jquery-ujs/raw/master/src/rails.js --no-check-certificate"
#end
generators = <<-GENERATORS
    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.fixture_replacement :fabrication, :dir => "spec/fabricators"
      g.integration_tool :rspec
    end
GENERATORS

#file 'config/initializers/dragonfly', <<-FILE
  #require 'dragonfly/rails/images'

#FILE

run "rm public/stylesheets/application.css"
file 'public/stylesheets/application.css', <<-FILE
body {
  #background-color: #4B7399;
  font-family: Verdana, Helvetica, Arial;
  font-size: 14px;
}

a img {
  border: none;
}

a {
  color: #0000FF;
}

.clear {
  clear: both;
  height: 0;
  overflow: hidden;
}

#container {
  width: 75%;
  margin: 0 auto;
  background-color: #FFF;
  padding: 20px 40px;
  border: solid 1px #E0FFFF;
  #margin-top: 20px;
}

#flash_notice, #flash_error {
  padding: 5px 8px;
  margin: 10px 0;
}

#flash_notice {
  background-color: #CFC;
  border: solid 1px #6C6;
}

#flash_error {
  background-color: #FCC;
  border: solid 1px #C66;
}

.fieldWithErrors {
  display: inline;
}

#errorExplanation {
  width: 400px;
  border: 2px solid #CF0000;
  padding: 0px;
  padding-bottom: 12px;
  margin-bottom: 20px;
  background-color: #f0f0f0;
}

#errorExplanation h2 {
  text-align: left;
  font-weight: bold;
  padding: 5px 5px 5px 15px;
  font-size: 12px;
  margin: 0;
  background-color: #c00;
  color: #fff;
}

#errorExplanation p {
  color: #333;
  margin-bottom: 0;
  padding: 8px;
}

#errorExplanation ul {
  margin: 2px 24px;
}

#errorExplanation ul li {
  font-size: 12px;
  list-style: disc;
}
FILE

run "rm config/database.yml"
file 'config/database.yml', <<-FILE
development:
  adapter: postgresql
  database: #{@app_name}_development
  username: posttest
  password: please
  host: localhost
  template: template0

test:
  adapter: postgresql
  database: #{@app_name}_test
  username: posttest
  password: please
  host: localhost
  template: template0

production:
  adapter: postgresql
  database: #{@app_name}_production
  username: posttest
  password: please
  host: localhost
  template: template0

FILE

#run "rm public/javascripts/jquery.js"
run "rm -rf public/build"
run "rm -rf public/demo"
run "rm -rf public/test"
#run "rm public/index.html"
# JQuery
#apply "~/src/rails_templates/jquery.template"

run "rvm use --create --rvmrc default@#{app_name}"

run "sed -i 's/config.action_view.debug_rjs/#config.action_view.debug_rjs/g' config/environments/development.rb"

run "bundle install"
run "rake db:drop"
run "rake db:create"
run "rails generate rspec:install"
run "rails generate cucumber:install --rspec --capybara"
run "rails generate devise:install"
run "rails generate devise:views"
run "rails generate devise User"
run "rails g controller welcome index"
run "sed -i '' 's/# root :to/root :to/g' config/routes.rb"

run "rake db:migrate"

run "cp ~/src/rails_templates/devise_steps.rb features/step_definitions/"

#apply "~/src/rails_templates/devise_steps.rb"
#run "rake rails:update"

#run "mvim ~/src/#{app_name}"

