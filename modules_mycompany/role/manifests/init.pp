# == Class: role
#
# The roles can be either set on the individual server or on the puppetmaster master in the hieradata for the node. 
# If set in the puppetmaster hierdata this takes precedence. 
#
# SETTING THE ROLES
# On the individual server set the Facter variable role_name1 to role_name4
#   export FACTER_role_name1=base
#   export FACTER_role_name2=webserver 
# On the puppetmaster set the roles in the nodes\<hostname>.yaml file using values role::role_name1 to role::role_name4 
#
# MODULE CALLING 
# This will result in either calls the role::role_nameX class
# or
#  if the prefix parameter is set then it will call directly the module for the role called prefix_role. 
# NOTE: separator has been changed from dash to underscore. 
#       If you want to maintain compatiability with previous version set the separator variable to dash.   
#
# MODULE NAMING
# There should be a separation of Library Modules from custom modules or classes.  
# This allow a design pattern for modules where custom modules have a prefix (typically companyname) 
# This separates them from standard library modules that can be specified using puppet librarian or downloaded 
# from puppetforge or github which should then NOT be customized.
#
# ROLE ORDERING
# We will always run the base role first but by default the other roles are run by puppet IN ANY ORDER.
# If you want the other roles run add to the puppet command the option   --ordering=manifest 
#  
# RESOVLING CLASS PARAMETERS 
# parameters for role can be set in the hier hierarchy.
# They can be resolved from the hier <environment>/role/<role_name>.yaml and the role/<role_name>.yaml
# This allows values to be set for the particular environment.
# Also common parameters can be set in the common.yaml file which can also be specifed by environment.
#
class role($prefix  = undef, $separator = '_' )
 { 
  include stdlib
  if $role_name1 != '' and $prefix == undef {
     $role1 = "role::${role_name1}"
   } elsif $role_name1 != '' {
      $role1 = "${prefix}${separator}${role_name1}"
   } else { 
  	 $role1 = 'role::base' 
  }
  if $role_name2 != '' and $prefix == undef {
      $role2 = "role::${role_name2}"
   } elsif $role_name2 != '' { 
     $role2 = "${prefix}${separator}${role_name2}"  
   } else { 
 	 $role2 = '' 
  }   
  if $role_name3 != '' and $prefix == undef  {
      $role3 = "role::${role_name3}"
   } elsif $role_name3 != '' { 
     $role3 = "${prefix}${separator}${role_name3}"	  
   } else { 
 	 $role3 = '' 
  }  
  if $role_name4 != '' and $prefix == undef  {
     $role4 = "role::${role_name4}"
   } elsif $role_name4 != '' { 
     $role4 = "${prefix}${separator}${role_name4}" 
   } else { 
 	 $role4 = '' 
  }
  $roles = [ $role1, $role2, $role3, $role4]
  if $prefix  != undef {  
     notify {"*** Direct Module Prefix ${prefix} ***": }
  } 	 
  notify {"*** Roles ${role_name1} ${role_name2} ${role_name3} ${role_name4} ***": }
  if $prefix  != undef {
     notify {"*** Modules ${role1} ${role2} ${role3} ${role4} ***": }
  } else { 
     notify {"*** Classes ${role1} ${role2} ${role3} ${role4} ***": }
  }
  # Require base first in case it does required setup
  if member($roles, 'role::base') {
    require role::base
  }
  if $prefix != undef and member($roles, "${prefix}${separator}base") {
    $base_module = "${prefix}${separator}base"
    require $base_module
  }
  include $roles
}
