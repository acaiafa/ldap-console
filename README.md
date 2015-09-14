# OpenLDAP Console

Sinatra app that will drive the user creation and modification of all users inside of LDAP

Current Features:
 * User/Group Creation
 * User Modification

Currently there is no auth built in. I plan on adding Auth against the LDAP database to make sure users actually exist. If this is a feature thats requested please let me know and I will add it in. 

## Setup

```
git clone git@github.com/acaiafa/ldap-console.git
```


## Deployment

`cap [production] deploy`

## Testing

Currently minimal rspec. Will need more.

