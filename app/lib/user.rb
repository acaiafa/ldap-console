module OpenLdap
  class User

    include ::LdapConnection

    def list
      users = ldap.search(:base => user_dn, :filter => "uid=*")
      users.map { |u| u[:cn] }.flatten
    end

    #find current group id number
    def find_groupid(group_name)
      number = ldap.search(:base => group_dn, :filter => "cn=#{group_name}")
      gid = []
      number.each do |result|
        gid = result[:gidnumber][0]
      end
      gid
    end

    #find next available user id
    def find_next_userid
      number = ldap.search(:base => user_dn, :filter => "cn=*")
      uids = []
      number.each do |result|
        uids.push(result[:uidnumber])
      end
      next_uid = uids.flatten.last.to_i + 1
      if uids.flatten.include?(next_uid)
        next_uid + 1
      elsif uids.empty?
        next_uid = 20000
      end
      next_uid
    end

    #add user
    def add(username, group, group_add, sshkey)
      user_name = ["uid=#{username}", user_dn].join(',')
      user_search = ldap_search("uid=#{username}")
      #set everyone not in these groups shell to /sbin/nologin
      if ["dev","sre","network"].include?(group)
        shell = "/bin/bash"
      else
        shell = "/sbin/nologin"
      end
      if user_search.empty?
        ldap.add(:dn => user_name, :attributes => {
          :cn => username.to_s,
          :objectclass => ["account","posixAccount","ldapPublicKey","extensibleObject"],
          :description => "#{username} - User Account",
          :uidnumber => find_next_userid.to_s,
          :loginshell => shell,
          :homedirectory => "/home/#{username}",
          :gidnumber => find_groupid(group).to_s,
          :userPassword => "changemeplease",
          :email => [username,"@", SETTING[ENV['RACK_ENV']]['domain']].join
        })
      end
      #set primary group
      ldap.modify(:dn => ["cn=#{group}", group_dn].join(','), :operations => [[:add, :memberuid, username]])
      #add email address for users
      if user_search.map { |u| u[:email] }.empty?
        ldap.modify(:dn => user_name, :operations => [[:add, :mail, [username,"@", SETTING[ENV['RACK_ENV']]['domain']].join]])
      end
      Array(group_add).each do |grps|
        ldap.modify(:dn => ["cn=#{grps}", group_dn].join(','), :operations => [[:add, :memberuid, username]])
      end
      Array(sshkey).each do |sshkeys|
        ldap.modify(:dn => user_name, :operations => [[:add, :sshPublicKey, sshkeys]])
      end
      user_search.each do |result|
        if result['gidnumber'] != find_groupid(group).to_s
          ldap.modify(:dn => user_name, :operations => [[:replace, :gidnumber, find_groupid(group).to_s]])
        end
      end
    end

    def mod(username, group_add, password, sshkey, suspend)
      user_name = ["uid=#{username}", user_dn].join(',')
      unless password.empty?
        ldap.modify(:dn => user_name, :operations => [[:replace, :userPassword, "#{password}"]])
      end
      unless sshkey.empty?
        Array(sshkey).each do |ssh|
          ldap.modify(:dn => user_name, :operations => [[:add, :sshPublicKey, ssh]])
        end
      end
      unless group_add.nil?
       Array(group_add).each do |grps|
          ldap.modify(:dn => ["cn=#{grps}", group_dn].join(','), :operations => [[:add, :memberuid, username]])
        end
      end
      if suspend == "true"
        ldap.modify(:dn => user_name, :operations => [[:replace, :userPasword, SecureRandom.hex]])
        ldap.modify(:dn => user_name, :operations => [[:replace, :loginShell, '/sbin/nologin']])
        ldap.delete_attribute user_name, :sshPublicKey
      end
    end
  end
end
