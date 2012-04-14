set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :application, "agileista.com"
set :repository, "git@github.com:levent/agileista.git"
set :scm, :git
set :deploy_via, :remote_cache
# set :deploy_via, :copy
# set :copy_cache, true
# set :copy_exclude, [".git"]
set :branch, "rails32" 
set :scm_verbose, true
set :keep_releases,       5
# set :deploy_via, :export
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/u/apps/#{application}"
# set :ruby_enterprise, "/opt/ruby-enterprise-1.8.6-20090610/bin/rake"
# set :ruby_enterprise_gem, "/opt/ruby-enterprise-1.8.6-20090610/bin/gem"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :user, "rails"
set :use_sudo, false
set :default_environment, {
  'PATH' => "/home/rails/.rbenv/shims:/home/rails/.rbenv/bin:$PATH"
}
default_run_options[:pty] = true

set :rails_env, "production"
role :app, "fukushima"
role :web, "fukushima"
role :db,  "fukushima", :primary => true

namespace :deploy do
  task :restart do
    run "cd #{current_path} && bundle exec bundle exec rake assets:precompile RAILS_ENV=#{rails_env}"
  #  restart_sphinx
  #  run "touch #{release_path}/tmp/restart.txt"
  end

  # task :bundle do
  #   # run("cd #{release_path}; bundle install #{release_path}/gems/")
  #   run("cd #{release_path}; bundle install --without development cucumber test --path=.gem/")
  # end
  
  
  task :stop do
  #  run "touch #{release_path}/tmp/restart.txt"
  end

  task :start do
  #  run "touch #{release_path}/tmp/restart.txt"
  end
end

desc "Stop the sphinx server"
task :stop_sphinx , :roles => :app do
  run "cd #{current_path} && bundle exec rake ts:stop RAILS_ENV=#{rails_env}"
end


desc "Start the sphinx server" 
task :start_sphinx, :roles => :app do
  run "cd #{current_path} && bundle exec rake ts:config RAILS_ENV=#{rails_env} && bundle exec rake ts:start RAILS_ENV=#{rails_env}"
end

desc "Restart the sphinx server"
task :restart_sphinx, :roles => :app do
  stop_sphinx
  start_sphinx
end

desc "Reindex search index"
task :reindex_sphinx, :roles => :app do
  run "cd #{current_path} && bundle exec rake ts:index RAILS_ENV=#{rails_env}"
end

task :setup_symlinks, :roles => :web do
  run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/mailer.yml #{release_path}/config/mailer.yml"
  run "ln -nfs #{shared_path}/sphinx #{release_path}/db/sphinx"
end

namespace :sass do
  desc 'Updates the stylesheets generated by Sass'
  task :update, :roles => :app do
  end
end

after "deploy:update_code", :setup_symlinks, 'sass:update'
# after "deploy:update_code", "deploy:bundle"
after "deploy", "deploy:cleanup"
