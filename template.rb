def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)), 'templates')]
end

copy_file 'Gemfile'
