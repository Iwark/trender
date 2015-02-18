role :app, %w{trender}
role :web, %w{trender}
role :db,  %w{trender}

set :stage, :production
set :rails_env, :production

set :deploy_to, '/home/ec2-user/trender'

set :default_env, {
  rbenv_root: "/home/ec2-user/.rbenv",
  path: "/home/ec2-user/.rbenv/shims:/home/ec2-user/.rbenv/bin:$PATH",
}
