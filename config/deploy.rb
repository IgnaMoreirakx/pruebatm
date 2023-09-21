# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :stage, 'production'

set :application, "TeamMaker2"
set :repo_url, "https://github.com/Dany-Ocampo/TeamMaker2.0.git"
set :user, 'imoreira'
set :puma_threads, [4, 16]
set :puma_workers, 0
#ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp


set :pty, true
set :use_sudo, false
set :deploy_via, :remote_cache
set :deploy_to, "/home/DIINF/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
#set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to true if using ActiveRecord

#set :linked_files, fetch(:linked_files, []).push("config/master.key")

namespace :puma do
    desc 'Create Directories for Puma Pids and Socket'
    task :make_dirs do
        on roles(:app) do
            execute "mkdir #{shared_path}/tmp/sockets -p"
            execute "mkdir #{shared_path}/tmp/pids -p"
        end
    end
  
    before :start, :make_dirs
end
  
namespace :deploy do
    desc "Make sure local git is in sync with remote."
    task :check_revision do
        on roles(:app) do
            unless `git rev-parse HEAD` == `git rev-parse origin/master`
                puts "WARNING: HEAD is not the same as origin/master"
                puts "Run `git push` to sync changes."
                exit
            end
        end
    end
  
    desc 'Initial Deploy'
    task :initial do
        on roles(:app) do
            before 'deploy:restart', 'puma:start'
            invoke 'deploy'
        end
    end
  
    desc 'Restart application'
    task :restart do
        on roles(:app), in: :sequence, wait: 5 do
            invoke 'puma:restart'
        end
    end
  
    before :starting,     :check_revision
    after  :finishing,    :compile_assets
    after  :finishing,    :cleanup
    #after  :finishing,    :restart
end
  
  # ps aux | grep puma    # Get puma pid
  # kill -s SIGUSR2 pid   # Restart puma
  # kill -s SIGTERM pid   # Stop puma

#set :format, :pretty


=begin
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle", "public/uploads"

set :keep_releases, 3

set :linked_files, fetch(:linked_files, []).push("config/master.key")
set :rvm_type, :user
set :rvm_ruby_version, '3.1.1'
set :rvm_binary, '~/.rvm/bin/rvm'
set :rvm_bin_path, "$HOME/bin"
set :default_env, { rvm_bin_path: '~/.rvm/bin' }



set :rails_env, fetch(:stage)

set :passenger_environment_variables, { :path => '/usr/lib/ruby/vendor_ruby/phusion_passenger/bin:$PATH' }
set :passenger_restart_command, '/usr/lib/ruby/vendor_ruby/phusion_passenger/bin/passenger-config restart-app'

namespace :deploy do
    desc "Make sure local git is in sync with remote"
    task :check_revision do
        on roles(:app) do
            unless `git rev-parse HEAD` == `git rev-parse origin/master`
                puts "Warning: HEAD is not the same as origin/master"
                puts "Run 'git push' to sync changes."
                exit
            end
        end
    end

    desc 'Restart app'
    task :restart do
        on roles(:app), in: :sequence, wait: 5 do
            within release_path do
                execute :bundle, 'install'
                execute :chmod, '777 ' + release_path.join('tmp/cache/').to_s
                execute :chmod, '777 ' + release_path.join('log/').to_s
                execute :rake, 'db:create RAILS_ENV=production'
                execute :rake, 'db:migrate RAILS_ENV=production'
                execute :rake, 'assets:precompile RAILS_ENV=production'
                execute 'sudo service apache2 restart'
            end
        end
    end

    before :starting, :check_revision
    before :finishing, :restart
end
=end
