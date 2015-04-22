guard :bower do
  watch('bower.json')
end

guard 'ctags-bundler', src_path: ["app", "lib"], arguments: '-R --fields=+l' do
  watch(/^(app|lib|vendor)\/.*$/)
  watch('Gemfile.lock')
end
