# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'tsubuyaki'
set :repo_url, 'git@github.com:saiwaki/tsubuyaki_22_nov.git'
set :deploy_to, '/home/saiwaki/tsubuyaki_22_nov'
set :scm, :git
set :keep_releases, 5

set :rbenv_type, :user # :system or :user
set :rbenv_ruby, '2.2.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :linked_dirs, %w{bin log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle}
# set :unicorn_pid, "#{shared_path}/tmp/unicorn.pid"

set :unicorn_bin, ->{"unicorn_rails"}
set :unicorn_pid, -> { File.join(shared_path, "tmp", "pids", "unicorn.pid") }
set :unicorn_config_path, "config/unicorn.rb"
set :unicorn_rack_env, :production


set :bundle_jobs, 4

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :publishing, :restart
  task :restart do
    invoke 'unicorn:restart'
  end

  # after :finishing, 'deploy:sitemap:refresh'
  after :finishing, 'deploy:cleanup'
end
