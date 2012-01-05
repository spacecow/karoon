default_run_options[:pty] = true
set :repository, "git@github.com:spacecow/karoon.git"
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false

set :application, "karoon"
set :deploy_to, "/home/aurora/apps/#{application}"
set :user, "aurora"
set :admin_runner, "aurora"
  
role :app, "sao.fir-vpc.riec.tohoku.ac.jp"
role :web, "sao.fir-vpc.riec.tohoku.ac.jp"
role :db,  "sao.fir-vpc.riec.tohoku.ac.jp", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'
