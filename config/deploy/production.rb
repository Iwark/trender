role :app, %w{toolbox.candypot.jp}
role :web, %w{toolbox.candypot.jp}
role :db,  %w{toolbox.candypot.jp}

set :stage, :production
set :rails_env, :production

set :deploy_to, '/home/ec2-user/trender'

set :unicorn_bin, 'unicorn_rails'
set :unicorn_options, "--path /trender"

set :default_env, {
  rbenv_root: "/home/ec2-user/.rbenv",
  path: "/home/ec2-user/.rbenv/shims:/home/ec2-user/.rbenv/bin:$PATH",
}
