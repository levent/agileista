# Necessary to run on Site5
set :use_sudo, false
set :group_writable, false

# Less releases, less space wasted
set :keep_releases, 5

# The mandatory stuff
set :application, "agileista"
set :user, "levental"

set :repository,  "svn+ssh://levental@agileista.leventali.com/home/levental/repos/agileista/trunk"

# SCM information
set :scm_username, "levental"
set :scm_password, Proc.new { CLI.password_prompt "SVN Password: "}

# This is related to site5 too.
set :deploy_to, "/home/#{user}/apps/#{application}"

role :app, "agileista.leventali.com"
role :web, "agileista.leventali.com"
role :db,  "agileista.leventali.com", :primary => true


# In the deploy namespace we override some default tasks and we define
# the site5 namespace.
namespace :deploy do
  desc <<-DESC
    Deploys and starts a `cold’ application. This is useful if you have not \
    deployed your application before, or if your application is (for some \
    other reason) not currently running. It will deploy the code, run any \
    pending migrations, and then instead of invoking `deploy:restart’, it will \
    invoke `deploy:start’ to fire up the application servers.
  DESC
  # NOTE: we kill public_html so be sure to have a backup or be ok with this application
  # being the default app for the domain.
  task :cold do
    update
    site5::link_public_html
    site5::kill_dispatch_fcgi
  end
  
  desc <<-DESC
    Link in the production database.yml
  DESC
  task :after_update_code do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/index #{release_path}/index"
    run "cp #{shared_path}/public/.htaccess #{release_path}/public/.htaccess"
    run "cp #{shared_path}/public/dispatch.cgi #{release_path}/public/dispatch.cgi"
    run "cp #{shared_path}/public/dispatch.fcgi #{release_path}/public/dispatch.fcgi"
    run "cp #{shared_path}/config/environment.rb #{release_path}/config/environment.rb"
  end
  
  desc <<-DESC
    Site5 version of restart task.
  DESC
  task :restart do
    site5::kill_dispatch_fcgi
  end
    
  namespace :site5 do
    desc <<-DESC
      Links public_html to current_release/public
    DESC
    task :link_public_html do
      # run "cd /home/#{user}; rm -rf public_html; ln -s #{current_path}/public ./public_html"
      
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      run "ln -nfs #{shared_path}/index #{release_path}/index"
      run "cp #{shared_path}/public/.htaccess #{release_path}/public/.htaccess"
      run "cp #{shared_path}/public/dispatch.cgi #{release_path}/public/dispatch.cgi"
      run "cp #{shared_path}/public/dispatch.fcgi #{release_path}/public/dispatch.fcgi"
      run "cp #{shared_path}/config/environment.rb #{release_path}/config/environment.rb"

      # run "find #{release_path} -type f -print | xargs chmod 644"
      # run "find #{release_path} -type d -print | xargs chmod 755"
      run "chmod 755 #{current_path}/public/dispatch.fcgi" 
      run "touch #{current_path}/public/dispatch.fcgi"
    end
    
    desc <<-DESC
      Kills Ruby instances on Site5
    DESC
    task :kill_dispatch_fcgi do
      run "skill -u #{user} -c ruby"
    end
  end
end