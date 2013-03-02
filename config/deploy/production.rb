set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :application, "agileista.com"
set :repository, "git@github.com:levent/agileista.git"
set :scm, :git
set :deploy_via, :remote_cache
# set :deploy_via, :copy
# set :copy_cache, true
# set :copy_exclude, [".git"]
set :branch, "master"
set :scm_verbose, true
set :keep_releases, 4
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
role :app, "bigapple"
role :web, "bigapple"
role :db,  "bigapple", :primary => true

# TODO: Precompile assets locally
# namespace :assets do
#   desc 'Updates the stylesheets generated by Sprockets'
#   task :precompile, :roles => :app do
#     # Precompile assets locally
#     run_locally "RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
# 
#     # Ensure assets folder exists on app servers
#     run "mkdir -p #{release_path}/public/assets"
# 
#     # Put new manifest onto all the app servers
#     upload "public/assets/manifest.yml", "#{release_path}/public/assets/manifest.yml", :via => :scp
#   end 
# end

def remote_file_exists?(full_path)
  'true' == capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :deploy do


  task :unicorns, :roles => :app do
    pid_file = "/u/apps/agileista.com/shared/pids/unicorn.pid"

    if remote_file_exists?(pid_file)
      puts "pid found"
      pid = capture("cat #{pid_file}")

      puts "USR2 to #{pid}"
      run "kill -s USR2 #{pid}"
      sleep 20
      puts "WINCH to #{pid}"
      run "kill -s WINCH #{pid}"
      sleep 10
      puts "QUIT to #{pid}"
      run "kill -s QUIT #{pid}"
    end
  end

  task :restart do
    run_locally "bundle exec rake assets:precompile RAILS_ENV=#{rails_env} AWS_ACCESS_KEY_ID=\"#{ENV['AWS_ACCESS_KEY_ID']}\" AWS_SECRET_ACCESS_KEY=\"#{ENV['AWS_SECRET_ACCESS_KEY']}\" FOG_DIRECTORY=\"agileista-#{rails_env}\""

    # Ensure assets folder exists on app servers
    run "mkdir -p #{release_path}/public/assets"

    # Put new manifest onto all the app servers
    top.upload("public/assets/manifest.yml", "#{release_path}/public/assets/manifest.yml", :via => :scp)
  end

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

task :sphinx_stop, :roles => :app do
  thinking_sphinx.stop
end

task :sphinx_configure, :roles => :app do
  thinking_sphinx.configure
  thinking_sphinx.start
end

task :bundle_clean, :roles => :app do
  run "echo 'Do this!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'"
end

task :downcase_emails, :roles => :app do
  run "cd #{release_path} && bundle exec rake account:downcase_emails RAILS_ENV=#{rails_env}"
end

before "deploy:update_code", "sphinx_stop"
after "deploy:update_code",
  :setup_symlinks,
  'deploy:migrate',
  'sass:update',
  "sphinx_configure"
#  'downcase_emails'
after "deploy", "deploy:cleanup", "deploy:unicorns", "bundle_clean"
