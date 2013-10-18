# == Class: role
#
# This class takes either a role name or a node_name. 
# if neither parameter is specified it defaults to node default
#
# When a role_name is passed then it simply includes the role class.
#
# Otherwise when the node_name is passed then the multiple roles are retrieved 
# from the hiera node/<node_name>.yaml file
#
# RESOVING CLASS PARAMETERS 
# if the role_name parameter is set in Facter 
#      export FACTER_role_name=`echo webserver`
# then the role class parameters can be resolved from the hier role/<role_name>.yaml file
# NOTE: This only works for servers with single roles
#
# Otherwise role class parameters need to be code in the role::<role_name> class and they cannot 
# participate in the hiera attribute hierarchy           
#
class role ($role_name  = '', $node_name  = 'default')  { 
  include stdlib
  info( "*** Role: Role name is ${role_name} Node name is ${node_name}") 
  if $role_name != '' {
     $roles = [ "role::$role_name" ] 
  } else { 	 
     $roles = hiera('roles', nil,  "nodes/${node_name}")
  }
  # Require base first in case it does required setup
  if member($roles, 'role::base') {
    require role::base
  }
  include $roles
}
