ps-app-plugin
=============

A Rundeck script plugin for remotely administering a PeopleSoft application server.

_NOTE: this currently only works for for UNIX/LINUX_

Installation
------------

Copy the [ps-app-plugin.zip file][latest_release] to your `$RDECK_BASE/libext` directory and restart the Rundeck service.

    mv ps-app-plugin.zip $RDECK_BASE/libext

You should now have an additional "ps appserver" option when configuring jobs.


Configuration
-------------

The following node variables must be set in order for the plugin to work.

* PS\_HOME 
* PS\_CFG\_HOME 
* PS\_APP\_HOME 
* PS\_PIA\_HOME 
* PS\_CUST\_HOME 
* TUXDIR

Depending on your configuration, you may also need to set the following as well.

* JAVA_HOME
* COBDIR
* PS_FILEDIR
* PS_SERVDIR
* ORACLE_HOME
* ORACLE_BASE
* TNS_ADMIN
* AGENT_HOME

For example, here's how a [yaml resource file][yaml_resource_model_source] might be setup.

```yaml
hrlinuxappserver01:
  tags: 'app,web,prcs'
  osName: Linux
  osFamily: unix
  username: psoft
  osArch: amd64
  description: HRDEMO Appserver Environment
  nodename: hrlinuxappserver01
  hostname: hrlinuxappserver01
  osName: Linux
  ps_home: '/opt/psoft/pt854'
  ps_cfg_home: '/opt/psoft/pt854cfg'
  ps_app_home: '/opt/psoft/hcm92'
  ps_pia_home: '/opt/psoft/pt854cfg'
  ps_cust_home: '/opt/psoft/hcm92custom'
  tuxdir: '/opt/oracle/middleware/tuxedo12c'
  java_home: '/usr/lib/jvm/java-1.7.0'
  oracle_home: '/opt/oracle/product/12.1.0/client'
  oracle_base: '/opt/oracle'
  cobdir: '/opt/microfocus/netexpress'
  appserver_domain: hrdemo
  prcs_domain: hrdemo 
  pia_domain: hrdemo
```

Also, it should be noted that this is a Rundeck [script plugin][script_plugin_instructions] and works by passing the node variables as environment variables over SSH.  In order for the plugin to have access to the configured node variables, you'll need to make sure that the ssh server process on the target system is [configured for this][ssh_environment_variable_configuration].


Usage
-----

To use the plugin, simply select the "PS Appserver" node step type when adding a step to a workflow.  Then enter in the appserver domain that you would like to administer, and select the action you would like to perform from the drop-down list.  The actions are pretty straightforward, but here's a quick run down of what each does:

* status: Returns the status of the domain
* start: Starts the specified domain
* stop: Shuts down the specified domain
* kill: Shuts down the specified domain using a forced shutdown method
* configure: Reloads the domain configuration
* purge: Purges the domain cache
* flush: Cleans the IPC resources
* restart: Stops the domain and then starts it
* bounce: Performs the following - stop, flush, purge, configure, start

[yaml_resource_model_source]: http://rundeck.org/docs/administration/managing-node-sources.html#resource-model-source
[ssh_environment_variable_configuration]: http://rundeck.org/docs/plugins-user-guide/ssh-plugins.html#passing-environment-variables-through-remote-command
[script_plugin_instructions]: http://rundeck.org/docs/developer/plugin-development.html#script-plugin-development
[environment_variable_setup]: http://rundeck.org/docs/plugins-user-guide/ssh-plugins.html#passing-environment-variables-through-remote-command
[latest_release]: https://github.com/jrbing/pushover-notification-plugin/releases/latest


License
-------

Copyright © 2016 JR Bing

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

