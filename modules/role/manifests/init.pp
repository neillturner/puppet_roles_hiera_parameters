# == Class: role
#
# The roles can be either set on the individual server or on the puppetmaster master in the hieradata. 
# If set in the puppetmaster hierdata this takes precedence. 
#
# On the individual server set the Facter variable role_name1 to role_name4
# On the puppetmaster set the roles in the nodes\<hostname>.yaml file using values role::role_name1 to role::role_name4 
#
# This will result in either calls the role::role_nameX class
# or
#  if the prefix parameter is set then it will call directly the module for the role.
# This allow a design pattern for modules where custom modules have a prefix (typically companyname) 
# This separates them from standard library modules downloaded from puppetforge which should not be customized.
#
# We will always run the base role first but by default the other roles are run by puppet IN ANY ORDER.
# If you want the other roles run add to the puppet command the option   --ordering=manifest 
#  
#
# RESOVLING CLASS PARAMETERS 
# the role class parameters can be resolved from the hier role/<role_name>.yaml file if the individual server set the Facter variable role_name1 to role_name4 
#
class role( $prefix  = undef )
 { 
  include stdlib
  $hiera_role1 = hiera('role::role_name1',nil)
  if $hiera_role1 != nil {
     notify {"*** Found heira value role::role_name1 ignoring client role values ***": }
     $hiera_role2 = hiera('role::role_name2',nil)
	 $hiera_role3 = hiera('role::role_name3',nil)
	 $hiera_role4 = hiera('role::role_name4',nil)
     if $prefix == undef {   
        $role1 = "role::${hiera_role1}" 
		if $hiera_role2 != nil { 
		   $role2 = "role::$hiera_role2}"
		} else {
		   $role2 = ''
		}
		if $hiera_role3 != nil { 
		   $role3 = "role::${hiera_role3}"
		} else {
		   $role3 = ''
		}
		if $hiera_role4 != nil { 
		   $role4 = "role::${hiera_role4}"
		} else {
		   $role4 = ''
		}		
	 } else { 
        $role1 = "${prefix}-${hiera_role1}"
		if $hiera_role2 != nil { 
		   $role2 = "${prefix}-${hiera_role2}"
		} else {
		   $role2 = ''
		}
		if $hiera_role3 != nil { 
		   $role3 = "${prefix}-${hiera_role3}"
		} else {
		   $role3 = ''
		}
		if $hiera_role4 != nil { 
		   $role4 = "${prefix}-${hiera_role4}"
		} else {
		   $role4 = ''
		}				
	 }
  } else {  	 
  if $role_name1 != '' and $prefix == undef {
     $role1 = "role::${role_name1}"
   } elsif $role_name1 != '' {
      $role1 = "${prefix}-${role_name1}"
   } else { 
  	 $role1 = 'role::base' 
  }
  if $role_name2 != '' and $prefix == undef {
      $role2 = "role::${role_name2}"
   } elsif $role_name2 != '' { 
     $role2 = "${prefix}-${role_name2}"  
   } else { 
 	 $role2 = '' 
  }   
  if $role_name3 != '' and $prefix == undef  {
      $role3 = "role::${role_name3}"
   } elsif $role_name3 != '' { 
     $role3 = "${prefix}-${role_name3}"	  
   } else { 
 	 $role3 = '' 
  }  
  if $role_name4 != '' and $prefix == undef  {
     $role4 = "role::${role_name4}"
   } elsif $role_name4 != '' { 
     $role4 = "${prefix}-${role_name4}" 
   } else { 
 	 $role4 = '' 
  }
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
  if $prefix != undef and member($roles, "${prefix}-base") {
    $base_module = "${prefix}-base"
    require $base_module
  }
  include $roles
}
