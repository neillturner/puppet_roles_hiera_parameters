#  If the prefix parameter is set then it will go directly to the module for the role.
#  This allow a design pattern for modules where custom modules have a prefix (typically companyname) 
#  This separates them from standard library modules downloaded from puppetforge which should not be customized.
#  
#  Otherwise it will call the class in the role module first. i.e. role::<role_name>
#  
#  For example:
#   If prefix is set to mycompany 
#        it will go directly to the mycompany-base  module and runthe init class
#   Otherwise it will call the class role::base      
#
node default {
 Exec {
     path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
  }
     class { 'role' }
	# Or to do Direct Module Prefix 
	#class { 'role' : prefix => 'mycompany' } 
 } 



 

 
