role :app, %w{hct-toolbox}
role :web, %w{hct-toolbox}
role :db,  %w{hct-toolbox}

set :stage, :production
set :rails_env, :production

set :deploy_to, '/home/ec2-user/trender'

set :default_env, {
  rbenv_root: "/home/ec2-user/.rbenv",
  path: "/home/ec2-user/.rbenv/shims:/home/ec2-user/.rbenv/bin:$PATH",
}
