# Puppet Roles and Hiera Parameter Hierachy

This is a design pattern to implement roles like Chef and separate class parameters into 
a parameter hierachy also like chef.

This supports two ways of setting roles.

Set a single role_name in Facter for the server.

 -set the role_name in Facter 
 -the role class gets called from the site.pp and passes the role_name. 
 -the role::<role_name> class is called and the classes executed
 -the class parameters are resolved in the hiera hierachy:
 
       nodes/%{hostname}
       classes/%{calling_class}	   
       modules/%{module_name}	   
       roles/%{role_name}	   
       common 
	   
 -role parameters can be stored in the roles/%{role_name} and can be overriden for parameter 
values for the node,class or module. parameters that are common to all roles can be stored in the common file  

Set multiple roles in the  nodes/%{hostname} file

 -set multiple roles in the  nodes/%{hostname} file
 
 -the role class gets called from the site.pp and passes the node_name.
 
 -the role class gets the role_names from the nodes/<node_name> file
 
 -the role::<role_name> classes is called and the classes executed
 
 -the class parameters are resolved in the hiera hierachy if not coded in the role::<role_name> class : 
 
       nodes/%{hostname}	   
       classes/%{calling_class}	   
       modules/%{module_name}	   
       common 
	   
 -role class parameters can be stored in the role::<role_name> class but cannot be overriden with parameters 
  from the hiera parameter hierachy  

This can be tested by running in masterless puppet
  
    export FACTER_role_name=`echo webserver`  
    puppet apply --modulepath ./modules manifests/site.pp
	
This will also be able to run in puppet master, just need to decide how to set the  FACTER_role_name
or the hostname.  

NOTE: This still need so additional error checking and more testing.  	

