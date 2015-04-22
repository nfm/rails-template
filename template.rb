def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)), 'templates')]
end

copy_file 'Gemfile'

# Set up bower
copy_file '.bowerrc'
template 'bower.json.erb', 'bower.json'

# Set up guard
copy_file 'Guardfile'
