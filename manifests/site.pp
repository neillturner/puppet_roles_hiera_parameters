#
#  Can set a single role by setting the a custom Facter variable role_name  
#  e.g. before running puppet 
#         export FACTER_role_name='echo webserver'
#  or use the node_name to read multple roles from the hiera node/xxxx  file      
#
node default {
 info( "*** Role: Role name is ${::role_name}  node is default") 
 # define a single role_name directly 
  class { 'role' : role_name => $::role_name } 
 # or get role(s) from node definition in hiera  
 # class { 'role' : node_name => "default"  } 
} 


 

 
