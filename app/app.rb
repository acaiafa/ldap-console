#openldap-console
require 'sinatra'
require 'sinatra/bootstrap'
require 'sinatra/flash'

module OpenLdap
  class App < Sinatra::Base 
    include ::LdapConnection

    register Sinatra::Bootstrap::Assets
    register Sinatra::Flash

    set :bind, '0.0.0.0'


    get '/' do
      erb :updateuser
    end

    get '/user' do
      erb :user
    end

    post '/adduserldap' do
      username = params[:username]
      group = params[:group]
      group_add = params[:group_add]
      sshkey = params[:sshkey]
      OpenLdap::User.new.add(username, group, group_add, sshkey)
      flash[:alert] = "#{username} has been succesfully added!"
      redirect to('/user')
    end

    get '/updateuser' do
      erb :updateuser
    end

    post '/updateuserldap' do
      username = params[:username]
      group_add = params[:group_add]
      password = params[:password]
      if params[:sshkey].nil?
        sshkey = ""
      else
        sshkey = params[:sshkey].split("\r\n")
      end
      suspend = params[:suspend]
      OpenLdap::User.new.mod(username, group_add, password, sshkey, suspend)
      flash[:alert] = "You Have Successfully updated #{username}"
      redirect to('/updateuser')
    end

    get '/addgroup' do
      erb :addgroup
    end

    post '/addgroupldap' do
      group = nil
      unless OpenLdap::User.new.find_groupid(params[:group]).empty?
        flash[:error] = "#{params[:group]} Already exists. Please try again"
      else
        group = params[:group]
        OpenLdap::Group.new.add(group)
        flash[:alert] = "#{params[:group]} Was successfully created!"
      end
      redirect to('/addgroup')
    end
  end
end
