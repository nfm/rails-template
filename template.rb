def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)), 'templates')]
end

copy_file 'Gemfile'

# Set up bower
copy_file '.bowerrc'
template 'bower.json.erb', 'bower.json'

# Set up guard
copy_file 'Guardfile'

# Set up puma
copy_file 'config/puma.rb'

# Set up Procfile
copy_file 'Procfile'

# Set up sidekiq
environment "config.active_job.queue_adapter = :sidekiq"

# Set up Sprockets ES6
copy_file 'app/assets/javascripts/application.js'
environment <<-CODE
# Use system-js for Sprockets ES6 modules
Rails.application.config.assets.configure do |env|
  env.register_transformer 'text/ecmascript-6', 'application/javascript', Sprockets::ES6.new('modules' => 'system', 'moduleIds' => true)
end
CODE
