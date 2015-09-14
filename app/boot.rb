require 'bundler/setup'

#openldap = File.expand_path('../../', __FILE__)
#$LOAD_PATH.unshift(openldap) unless $LOAD_PATH.include?(openldap)

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require './app/lib/ldap_helper'
require './app/lib/group'
require './app/lib/user'
require './app/app'
