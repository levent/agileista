set :application, "agileista.com"
set :repository, "git@github.com:levent/agileista.git"
set :scm, :git
set :deploy_via, :remote_cache
set :branch, "damascus"
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

task :setup_symlinks, :roles => :web do
  run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  # run "rm -rf #{release_path}/vendor/plugins/acts_as_xapian/xapiandbs"
  # run "ln -nfs #{shared_path}/xapiandbs #{release_path}/vendor/plugins/acts_as_xapian/xapiandbs"
end

after "deploy:update_code", :setup_symlinks