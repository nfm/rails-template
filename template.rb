def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)), 'templates')]
end

@sidekiq = yes?('Use sidekiq?')

# Set up Gemfile
remove_file 'Gemfile'
template 'overrides/Gemfile.erb', 'Gemfile'

# Set up database.yml
remove_file 'config/database.yml'
template 'overrides/database.yml.erb', 'config/database.yml'

# Set up package.json
copy_file 'package.json'

# Set up bower
copy_file '.bowerrc'
template 'bower.json.erb', 'bower.json'

# Set up guard
copy_file 'Guardfile'

# Set up ENVied
copy_file 'Envfile'
template '.env.erb', '.env'
remove_file 'config/secrets.yml'
copy_file 'secrets.yml', 'config/secrets.yml'

# Set up puma
copy_file 'config/puma.rb'

# Set up Procfile
template 'Procfile.erb'

# Set up config/application.rb
remove_file 'config/application.rb'
template 'overrides/application.rb.erb', 'config/application.rb'

# Set up Sprockets ES6
remove_file 'app/assets/javascripts/application.js'
copy_file 'overrides/application.js', 'app/assets/javascripts/application.js'

# Set up staging environment
copy_file 'config/environments/staging.rb'

# Set up test_helper.rb
remove_file 'test/test_helper.rb'
copy_file 'test/test_helper.rb'

# Set up Heroku
copy_file '.buildpacks'
copy_file 'lib/tasks/heroku.rake'
