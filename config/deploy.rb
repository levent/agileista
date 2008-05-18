set :application, "agileista.com"
# set :repository,  "svn+dented://dev.dentedrecords.com/home/levent/repository/agileista.com/trunk"
# git
set :repository, "git@github.com:levent/agileista.git"
set :scm, :git
set :deploy_via, :remote_cache



# set :deploy_via, :export
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/levent/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

ssh_options[:port] = 30000
# set :sudo, "sudo -p Password:" 
set :user, "levent"
default_run_options[:pty] = true
# default_run_options[:pty] = true

role :app, "app.agileista.com"
role :web, "app.agileista.com"
role :db,  "app.agileista.com", :primary => true

namespace :deploy do
  task :restart do
    # run "RAILS_ENV=production #{release_path}/script/runner \"load '#{release_path}/script/ferret_stop'\""
    # sleep 2
    run "/usr/bin/mongrel_cluster_ctl stop"
    sleep 2
    run "/usr/bin/mongrel_cluster_ctl start"    
    sleep 2
    run "/usr/bin/mongrel_cluster_ctl status"
    # sleep 2
    # run "RAILS_ENV=production #{release_path}/script/runner \"load '#{release_path}/script/ferret_start'\""
  end
end

namespace :deploy do
  task :stop do
    # run "sudo /etc/init.d/apache2 stop"
    # sleep 3
    run "/usr/bin/mongrel_cluster_ctl stop"
    sleep 3
    run "/usr/bin/mongrel_cluster_ctl status"
  end
end

namespace :deploy do
  task :start do
    run "/usr/bin/mongrel_cluster_ctl start"
    sleep 3
    run "/usr/bin/mongrel_cluster_ctl status"
    # sleep 3
    # run "sudo /etc/init.d/apache2 start"
  end
end

task :setup_symlinks, :roles => :web do
  run "rm -rf #{release_path}/index"
  run "ln -nfs #{shared_path}/index #{release_path}/index"
end

after "deploy:update_code", :setup_symlinks
