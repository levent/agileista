set :application, "agileista.com"
set :repository,  "svn+dented://dev.purebreeze.com/home/levent/repository/agileista.com/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/levent/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

ssh_options[:port] = 30000
set :sudo, "sudo -p Password:" 

role :app, "dev.purebreeze.com"
role :web, "dev.purebreeze.com"
role :db,  "dev.purebreeze.com", :primary => true

namespace :deploy do
  task :restart do
    run "/usr/bin/mongrel_cluster_ctl stop"
    sleep 3
    run "/usr/bin/mongrel_cluster_ctl start"    
    sleep 3
    run "/usr/bin/mongrel_cluster_ctl status"
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