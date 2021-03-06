# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'airware_api'
set :repo_url, 'git@github.com:mreigen/airware_api_on_rails.git'
set :deploy_to, '/home/titou/airware_api'
set :ssh_options, forward_agent: true

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :finishing, 'deploy:cleanup'
end

set :linked_files, %w{config/mongoid.yml}

def ask_secretly(key, default=nil)
  require "highline"
  set key, proc{
    hint = default ? " [#{default}]" : ""
    answer = HighLine.new.ask("Enter #{key}#{hint}: ") do |q|
      q.echo = false
    end.to_s
  }
end

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

