# == Class: role
#
#  Call Modules and Classes based on up to 4 roles
#
#
class role($prefix  = undef, $separator = '_' )
{
  include stdlib
  if $role_name1 != undef and $role_name1 != '' and $prefix == undef {
    if $role_manifest1 == undef or $role_manifest1 == '' {
      $role1 = $role_name1
    } else {
      $role1 = "${role_name1}::${role_manifest1}"
    }
  } elsif $role_name1 != undef and $role_name1 != '' {
    if $role_manifest1 == undef or $role_manifest1 == '' {
      $role1 = "${prefix}${separator}${role_name1}"
    } else {
      $role1 = "${prefix}${separator}${role_name1}::${role_manifest1}"
    }
  } else {
    $role1 = 'base'
  }
  if $role_name2 != undef and $role_name2 != '' and $prefix == undef {
    if $role_manifest2 == undef or $role_manifest2 == '' {
      $role2 = $role_name2
    } else {
      $role2 = "${role_name2}::${role_manifest2}"
    }
  } elsif $role_name2 != undef and $role_name2 != '' {
    if $role_manifest2 == undef or $role_manifest2 == '' {
      $role2 = "${prefix}${separator}${role_name2}"
    } else {
      $role2 = "${prefix}${separator}${role_name2}::${role_manifest2}"
    }
  } else {
    $role2 = ''
  }
  if $role_name3 != undef and $role_name3 != '' and $prefix == undef  {
    if $role_manifest3 == undef or $role_manifest3 == '' {
      $role3 = $role_name3
    } else {
      $role3 = "${role_name3}::${role_manifest3}"
    }
  } elsif $role_name3 != undef and $role_name3 != '' {
    if $role_manifest3 == undef or $role_manifest3 == '' {
      $role3 = "${prefix}${separator}${role_name3}"
    } else {
      $role3 = "${prefix}${separator}${role_name3}::${role_manifest3}"
    }
  } else {
    $role3 = ''
  }
  if $role_name4 != undef and $role_name4 != '' and $prefix == undef  {
    if $role_manifest4 == undef or $role_manifest4 == '' {
      $role4 = $role_name4
    } else {
      $role4 = "${role_name4}::${role_manifest4}"
    }
  } elsif $role_name4 != undef and $role_name4 != ''  {
    if $role_manifest4 == undef or $role_manifest4 == '' {
      $role4 = "${prefix}${separator}${role_name4}"
    } else {
      $role4 = "${prefix}${separator}${role_name4}::${role_manifest4}"
    }
  } else {
    $role4 = ''
  }
  $roles = [ $role1, $role2, $role3, $role4]
  if $prefix  != undef {
    notify {"*** Direct Module Prefix ${prefix} ***": }
  }
  notify {"*** Roles ${role_name1} ${role_name2} ${role_name3} ${role_name4} ***": }
  notify {"*** Modules ${role1} ${role2} ${role3} ${role4} ***": }
  # Require base first in case it does required setup
  if member($roles, 'base') {
    require base
  }
  if $prefix != undef and member($roles, "${prefix}${separator}base") {
    $base_module = "${prefix}${separator}base"
    require $base_module
  }
  if $role_name1 != undef and $role_name1 != '' {
    include $role1
  }
  if $role_name2 != undef and $role_name2 != '' {
    include $role2
  }
  if $role_name3 != undef and $role_name3 != '' {
    include $role3
  }
  if $role_name4 != undef and $role_name4 != '' {
    include $role4
  }
