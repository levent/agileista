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
set :keep_releases, 2
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
role :app, "akra"
role :web, "akra"
role :db,  "akra", :primary => true

namespace :deploy do

  task :unicorns, :roles => :app do
    run "/etc/init.d/unicorn restart; true"
  end

  task :restart do
    run_locally "rm -rf public/assets"
    run_locally "bundle exec rake assets:precompile RAILS_ENV=#{rails_env} AWS_ACCESS_KEY_ID=\"#{ENV['AWS_ACCESS_KEY_ID']}\" AWS_SECRET_ACCESS_KEY=\"#{ENV['AWS_SECRET_ACCESS_KEY']}\" FOG_DIRECTORY=\"agileista-#{rails_env}\""

    # Ensure assets folder exists on app servers
    run "mkdir -p #{release_path}/public/assets"

    # Put new manifest onto all the app servers
    manifest_file = `ls public/assets/manifest*json`
    top.upload(manifest_file.chomp, "#{release_path}/public/assets/", :via => :scp)
    run_locally "rm -rf public/assets"
  end

  desc "Start the sidekiq worker"
  task :start_sidekiq, :roles => :app do
    sudo "monit start -g sidekiq_workers"
  end

  desc "Stop the sidekiq worker"
  task :stop_sidekiq, :roles => :app do
    sudo "monit stop -g sidekiq_workers"
  end
end

task :setup_symlinks, :roles => :web do
  run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/mailer.yml #{release_path}/config/mailer.yml"
end

namespace :sass do
  desc 'Updates the stylesheets generated by Sass'
  task :update, :roles => :app do
  end
end

task :bundle_clean, :roles => :app do
  run "cd #{release_path} && bundle clean"
end

task :downcase_emails, :roles => :app do
  run "cd #{release_path} && bundle exec rake account:downcase_emails RAILS_ENV=#{rails_env}"
end

before "deploy:update_code",
  "deploy:stop_sidekiq"
after "deploy:update_code",
  :setup_symlinks,
  'deploy:migrate',
  'sass:update'
after "deploy", "deploy:cleanup", "deploy:unicorns", "deploy:start_sidekiq", "bundle_clean"
