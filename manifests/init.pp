# == Class: role
#
#  Call Modules and Classes based on up to 4 roles 
#
#
class role($prefix  = undef, $separator = '_' )
 { 
  include stdlib
  if $role_name1 != '' and $prefix == undef {
     $role1 = "${role_name1}"
   } elsif $role_name1 != '' {
      $role1 = "${prefix}${separator}${role_name1}"
   } else { 
  	 $role1 = 'base' 
  }
  if $role_manifest1 != '' { 
     $role1 = "$(role1}::${role_manifest1}"
  }  
  if $role_name2 != '' and $prefix == undef {
      $role2 = "${role_name2}"
   } elsif $role_name2 != '' { 
     $role2 = "${prefix}${separator}${role_name2}"  
   } else { 
 	 $role2 = '' 
  } 
  if $role_manifest2 != '' { 
     $role2 = "$(role2}::${role_manifest2}"
  }  
  if $role_name3 != '' and $prefix == undef  {
      $role3 = "${role_name3}"
   } elsif $role_name3 != '' { 
     $role3 = "${prefix}${separator}${role_name3}"	  
   } else { 
 	 $role3 = '' 
  }
  if $role_manifest3 != '' { 
     $role3 = "$(role3}::${role_manifest3}"
  }  
  if $role_name4 != '' and $prefix == undef  {
     $role4 = "${role_name4}"
   } elsif $role_name4 != '' { 
     $role4 = "${prefix}${separator}${role_name4}" 
   } else { 
 	 $role4 = '' 
  }
  if $role_manifest4 != '' { 
     $role4 = "$(role4}::${role_manifest4}"
  }
  $roles = [ $role1, $role2, $role3, $role4]
  if $prefix  != undef {  
     notify {"*** Direct Module Prefix ${prefix} ***": }
  } 	 
  notify {"*** Roles ${role_name1} ${role_name2} ${role_name3} ${role_name4} ***": }
  #if $prefix  != undef {
     notify {"*** Modules ${role1} ${role2} ${role3} ${role4} ***": }
  #} else { 
  #   notify {"*** Classes ${role1} ${role2} ${role3} ${role4} ***": }
  #}
  # Require base first in case it does required setup
  if member($roles, 'base') {
    require base
  }
  if $prefix != undef and member($roles, "${prefix}${separator}base") {
    $base_module = "${prefix}${separator}base"
    require $base_module
  }
  include $roles
}
