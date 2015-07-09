# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'onTap'
set :repo_url, 'https://github.com/Orasi/onTap.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/ontap'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
#set :pty, true

# Default value for :linked_files is []
set :linked_files, %w(config/aws.yml config/initializers/saml.rb)

# Default value for linked_dirs is []
set :linked_dirs, %w(public/photos tmp/pids log)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :rails_env, "production"
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :whenever do

  def setup_whenever_task(*args, &block)
    args = Array(fetch(:whenever_command)) + args

    on roles fetch(:whenever_roles) do |host|
      args_for_host = block_given? ?cd  args + Array(yield(host)) : args
      within release_path do
        with fetch(:whenever_command_environment_variables) do
          execute *args_for_host
        end
      end
    end
  end

  desc "Update application's crontab entries using Whenever"
  task :update_crontab do
    setup_whenever_task do |host|
      roles = host.roles_array.join(",")
      [fetch(:whenever_update_flags),  "--roles=#{roles}"]
    end
  end

  desc "Clear application's crontab entries using Whenever"
  task :clear_crontab do
    setup_whenever_task(fetch(:whenever_clear_flags))
  end

  after "deploy:updated",  "whenever:update_crontab"
  after "deploy:reverted", "whenever:update_crontab"
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Clear Cache'
  task :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'db:migrate'
      end
    end
  end


  task :restart_dj do
    invoke 'delayed_job:restart'
  end

  task :stop_dj do
    invoke 'delayed_job:stop'
  end

  before :publishing, :stop_dj
  after :publishing, :clear_cache
  after :clear_cache, :restart
  after :publishing, :restart_dj
end
