module OpenLdap
  class Group

    include ::LdapConnection

    def list
      groups = ldap.search(:base => group_dn, :filter => "cn=*")
      groups.map { |u| u[:cn] }.flatten
    end

    def nextid
      number = ldap.search(:base => group_dn, :filter => "cn=*")
      gids = []
      number.each do |result|
        gids.push(result[:gidnumber])
      end
      next_gid = gids.flatten.last.to_i + 1
      if gids.flatten.include?(next_gid)
        next_gid + 1
      elsif gids.empty?
        next_gid = 10000
      end
      next_gid
    end

    def add(group)
      group_full_dn = ["cn=#{group}", group_dn].join(',')
      ldap.add(:dn => group_full_dn, :attributes => {
        :cn => group,
        :objectclass => "posixGroup",
        :description => "#{group} Group",
        :gidnumber => nextid.to_s
      })
    end
  end
end
