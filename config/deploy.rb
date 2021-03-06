set :application, :trender
set :repo_url, 'git@github.com:Iwark/trender.git'

set :scm, :git

set :rbenv_ruby, '2.3.0'

# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml db/production.sqlite3}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets public/uploads}

set :default_stage, "production"

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :bundle_env_variables, { 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 1 }

# set :linked_dirs, (fetch(:linked_dirs) + ['tmp/pids'])

set :unicorn_rack_env, "production"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          # execute :rake, 'cache:clear'
        end
      end
    end
  end

end
