require 'net-ldap'
require 'yaml'

module LdapConnection
  SETTING = YAML.load_file("config/config.yml")

  #ldap connection with simple auth
  def ldap
    Net::LDAP.new :host => SETTING[ENV['RACK_ENV']]['ldapserver'],
      :port => 389,
      :auth => {
      :method => :simple,
      :username => [SETTING[ENV['RACK_ENV']]['admin_cn'], SETTING[ENV['RACK_ENV']]['ldap_dn']].join(','),
      :password => SETTING[ENV['RACK_ENV']]['passwd']
    }
  end

  #general base_dn
  def base_dn
    "#{SETTING[ENV['RACK_ENV']]['ldap_dn']}"
  end

  #build generic search for ldap
  def ldap_search(name)
    ldap.search(:base => base_dn, :filter => name)
  end

  #group_dn
  def group_dn
    ['ou=Groups', base_dn].join(',')
  end

  #user_dn
  def user_dn
    ['ou=People', base_dn].join(',')
  end
end
