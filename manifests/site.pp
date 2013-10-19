#
#  Can set up to 4 roles by setting the a custom Facter variable role_name1 to role_name4  
#  e.g. before running puppet 
#         export FACTER_role_name1='echo base'
#         export FACTER_role_name2='echo webserver'
#
node default {
  class { 'role' : } 
} 


 

 
