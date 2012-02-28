default_run_options[:pty] = true
set :repository, "git@github.com:spacecow/karoon.git"
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false

set :application, "karoon"
set :deploy_to, "/home/ghazal/apps/#{application}"
set :user, "ghazal"
set :admin_runner, "ghazal"
  
role :app, "106.187.50.182"
role :web, "106.187.50.182"
role :db,  "106.187.50.182", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"    
    run "ln -nfs #{shared_path}/config/application.js #{release_path}/app/assets/javascripts/application.js"    
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'
