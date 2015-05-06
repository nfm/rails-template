def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)), 'templates')]
end

@sidekiq = yes?('Use sidekiq?')
@stripe = yes?('Use stripe?')

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
template 'Envfile.erb', 'Envfile'
template '.env.erb', '.env'
remove_file 'config/secrets.yml'
copy_file 'overrides/secrets.yml', 'config/secrets.yml'

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

after_bundle do
  # Set up Stripe and Payola
  if @stripe
    generate 'payola:install'
    generate 'model SubscriptionPlan amount:integer interval:string stripe_id:string name:string'
    inject_into_file "app/models/subscription_plan.rb", after: "class SubscriptionPlan < ActiveRecord::Base\n" do
      "  include Payola::Plan\n"
    end
    rake 'db:create'
    rake 'db:migrate'
    puts "You will need to add your Stripe account credentials to .env"
  end
end
