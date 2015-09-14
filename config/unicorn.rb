if ENV['RACK_ENV'].downcase == 'production'
    worker_processes 8
else
    worker_processes 4
end

timeout 120
listen  '/tmp/unicorn-ldapconsole.sock'

root = '/opt/apps/ldapconsole'

working_directory "#{root}/current"
pid               "#{root}/shared/pids/unicorn.pid"
stderr_path       "#{root}/shared/log/unicorn.log"
stdout_path       "#{root}/shared/log/unicorn.log"
