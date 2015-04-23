namespace :heroku do
  desc "Bootstrap a Heroku app with required addons and config"
  task :bootstrap do
    app_name = ENV['APP_NAME']
    env = ENV['ENV']

    run "heroku apps:create #{app_name}"
    run "heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git"
    run "heroku config:set REDIS_PROVIDER=REDISCLOUD_URL"
    run "heroku config:set RAILS_ENV=#{env}"
    run "heroku config:set RACK_ENV=#{env}"
    run "heroku addons:add papertrail"
    run "heroku addons:add newrelic"
    run "heroku addons:add rediscloud"
    run "git remote rename heroku #{env}"
    run "git push #{env} master"
    run "heroku run bin/rake db:migrate"
    run "heroku pg:backups schedule DATABASE_URL"
    run "heroku ps:scale web=1"
    run "heroku ps:scale worker=1"
  end

  def run(command)
    puts "\n$ #{command}"
    `#{command}`
  end
end
