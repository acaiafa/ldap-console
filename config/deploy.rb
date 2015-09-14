require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :application, "ldapconsole"
set :deploy_to, '/opt/apps/ldapconsole'
set :unicorn_path, '/etc/init.d/unicorn-ldapconsole'
set :user, "#{ENV['PROC_USER']}"
set :use_sudo, true
set :scm, :git
set :repository,  "git@github.com:acaiafa/ldap-console.git"

set :stages, %w{staging production}

default_run_options[:pty] = true

set :ssh_options, { :forward_agent => true }
set :default_shell, '/bin/bash -l'
set :default_rack_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

namespace :deploy do
  desc "Graceful restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    run "RACK_ENV=#{rack_env} #{unicorn_path} upgrade"
  end

  desc 'Reload unicorn'
  task :reload, :except => { :no_release => true } do
    run "RACK_ENV=#{rack_env} #{unicorn_path} reload"
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    run "RACK_ENV=#{rack_env} #{unicorn_path} start"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    run "RACK_ENV=#{rack_env} #{unicorn_path} stop"
  end
end
