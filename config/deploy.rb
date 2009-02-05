set :application, "agileista.com"
set :repository, "git@github.com:levent/agileista.git"
set :scm, :git
# set :deploy_via, :remote_cache
set :deploy_via, :copy
set :copy_cache, true
set :copy_exclude, [".git"]
set :branch, "0.1.1"
set :scm_verbose, true

# set :deploy_via, :export
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/levent/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
ssh_options[:port] = 30000
set :user, "levent"
default_run_options[:pty] = true

role :app, "app.agileista.com"
role :web, "app.agileista.com"
role :db,  "app.agileista.com", :primary => true

namespace :deploy do
  task :restart do
    restart_sphinx
    run "touch #{release_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  task :stop do
    run "touch #{release_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  task :start do
    run "touch #{release_path}/tmp/restart.txt"
  end
end

desc "Stop the sphinx server"
task :stop_sphinx , :roles => :app do
  run "cd #{current_path} && rake thinking_sphinx:stop RAILS_ENV=production"
end


desc "Start the sphinx server" 
task :start_sphinx, :roles => :app do
  run "cd #{current_path} && rake thinking_sphinx:configure RAILS_ENV=production && rake thinking_sphinx:start RAILS_ENV=production"
end

desc "Restart the sphinx server"
task :restart_sphinx, :roles => :app do
  stop_sphinx
  start_sphinx
end

task :setup_symlinks, :roles => :web do
  run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/sphinx #{release_path}/db/sphinx"
  # run "rm -rf #{release_path}/vendor/plugins/acts_as_xapian/xapiandbs"
  # run "ln -nfs #{shared_path}/xapiandbs #{release_path}/vendor/plugins/acts_as_xapian/xapiandbs"
end

after "deploy:update_code", :setup_symlinks