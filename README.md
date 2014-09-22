Puppet Roles and Hiera Parameter Hierarchy
==========================================

This is a design pattern to implement roles like Chef and to separate class parameters into 
a parameter hierachy also like chef.

The roles can be either set on the individual server  using custom facts or on the puppetmaster in the hieradata for the node. 
If set in the puppetmaster hierdata this takes precedence. 

This will work with both masterless puppet (ie puppet apply command) or with a puppet master (ie puppet agent command)

Setting the Roles
=================

On the individual server set the Facter variable role_name1 to role_name4. For example:

      export FACTER_role_name1=base
      export FACTER_role_name2=webserver 
      
On the puppetmaster set the roles in the nodes\<hostname>.yaml file using values role::role_name1 to role::role_name4 
For example file hieradata/nodes/ubuntu-server.yaml contains

      ---
      role::role_name1:  base
      role::role_name2:  webserver

Custom Module Name Prefix
=========================

A common design pattern is to prefix your custom puppet module names with a company name prefix.
This allows for separation of library modules from custom modules or classes.  
This separates them from standard library modules that can be specified using puppet librarian or downloaded 
from puppetforge or github which should then NOT be customized. 

To achieve this set the Direct Module Prefix in the site manifest

     class { 'role' : prefix => 'mycompany' }
     
This will result in calls to modules mycompany_base and mycompany_webserver. 
NOTE: For compatibility with previous versions of role you can set the separator char to underscore in the site manifest 

     class { 'role' : prefix => 'mycompany', separator => '-'  }

Module Calling
==============

Settingthe roles to base and webserver will result in calls to the modules called base and webserver and running the init.pp manifest. It is possible to specify a class to called different to the init.pp by setting the role to 

    module::manifest 
    
for example   

    export FACTER_role_name1=base
    export FACTER_role_name2=webserver::test
    
This will case the webserver::test to be called 
NOTE: To resolve parameter values from hier the yaml files needs to be called webserver::test.yaml which is not supported 
on windows. (a workaround could be to store the parameters for webserver::test in the base.yaml).    
  
Role Ordering
=============

the base role will always be run first but by default the other roles are run by puppet IN ANY ORDER!!!
If you want the other roles run add to the puppet command the option   --ordering=manifest 
  
Resolving Class Parameters 
==========================

Parameters for role can be set in the hiera hierarchy.
They can be resolved from the hier <environment>/role/<role_name>.yaml and the role/<role_name>.yaml
This allows values to be set for the particular environment.
Also common parameters can be set in the common.yaml file which can also be specifed by environment.

Sample Puppet Repository
========================

There is a sample puppet repository at https://github.com/neillturner/puppet_repo that implements this role functionality and includes the following additional files: 


hiera.yaml
==========

    ---
    :backends:
      - yaml
    :yaml:
      :datadir: /mypuppet_repo_dir/hieradata
    :hierarchy:
      - "nodes/%{::hostname}"
      - "%{::environment}/roles/%{role_name1}"
      - "%{::environment}/roles/%{role_name2}"
      - "%{::environment}/roles/%{role_name3}"
      - "%{::environment}/roles/%{role_name4}" 
      - "%{::environment}/common"  
      - "roles/%{role_name1}"
      - "roles/%{role_name2}"
      - "roles/%{role_name3}"
      - "roles/%{role_name4}"	
      - common 
  
site.pp (or whatever the initial manifest file is called)
=========================================================

    #
    #  Call Modules and Classes based on up to 4 roles 
    #
    #
    node default {
     Exec {
         path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
     }
     # check if roles defined in node hostname hiera file.
     $hiera_role1 = hiera('role::role_name1','')
     if $hiera_role1 != '' {
        notify {"*** Found heira role::role_name1 value ${hiera_role1} ignoring all facter role values ***": }
	$role_name1 = hiera('role::role_name1','')
        $role_name2 = hiera('role::role_name2','')
        $role_name3 = hiera('role::role_name3','')
  	$role_name4 = hiera('role::role_name4','')
     }	
     class { 'role': }
     # Or to do Direct Module Prefix 
     #class { 'role' : prefix => 'mycompany' }
     # Or to maintain compatibility with previous version that used a dash
     #class { 'role' : prefix => 'mycompany', separator => '-'  } 
 }    
  
Testing
=======

This can be tested by running in masterless puppet

    export FACTER_role_name1=base
    export FACTER_role_name2=webserver
    puppet apply --modulepath ./modules manifests/site.pp

also an environment can be specified on the puppet apply command so that parameters values for different environments
can be resolved from the hiera data.  
	
This will also be able to run in puppet master:
if the hostname is ubuntu-server set the roles in the hiera file hieradata/nodes/ubuntu-server.yaml on the puppetmaster

    ---
    role::role_name1:  'base'  
    role::role_name2:  'webserver' 
   then run
    puppet agent -t --servername=puppetmaster.mycompany.com -v -d  


  
