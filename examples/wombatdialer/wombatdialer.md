Running WombatDialer under whaleware
====================================

WombatDialer - http://wombatdialer.com - is an advanced outbound dialer for the Asterisk PBX. It is used to implement many different 
kinds of scenarios related to outbound dialing, for example telecasting, message deliveries, order fulfillments, and offers manual,
automated and power dialing modes based on a feedback control model. 

As it was designed to work "out of the box" on any existing Asterisk-based PBX, it is a good candidate for 
being run under Docker - you run it, log on via a web browser and do your things. 
Plus, it only exposes the HTTP port, even if it is making direct AMI connetions to the Asterisk PBX.

The application running under whaleware is available as image 'loway/wombatdialer' from https://registry.hub.docker.com/u/loway/wombatdialer/

The Dockerfile
--------------

The [Doockerfile under build/](build/Dockerfile) is as plain as it can be. It starts from an image of CentOS 6 that already
contains whaleware, exposes HTTP port 8080, installs WombatDialer using the yum package manager as you would manually
and copies the conents of local folder "ww" to "/ww".

As you can see, this Dockerfile does not contain a complex set-up process. All copying, customizing and renaming of files
happens when the image runs.  

It does not contain a startup script, either - that is defined by whaleware and inherited.

Creating a whaleware system is then a matter of creating the right scripts to override the default ones. As you
place your scripts under ww/usr and copy them on top of an existing whaleware image, you just have to define 
whichever scripts you need.


The scripts
-----------

- `boot` - This script sets things up. It is typically used to configure links and merge the current configuration
   (as supplied externally via JSON) into cvonfiguration files. Notice how we use the $WCFG command to read the 
   current configuration (as a merge of the default and current one).
- `firstboot` - This script is run only on the first boot and is meant to configure the data directories. In our case,
    not only it creates data directories, but it starts MySQL in order to pre-load the default database.
- `warmup` - just waits a few seconds so we can be sure that Tomcat is up and running
- `monitor` - we call a specific URL to make sure WombatDialer is running. WombatDialer has an embedded health
  service that checks everything is okay and returns the code "WBTUP" if all is in order.
- `svcdown` and `svcup` will respectively shutdown and start MySQL and Tomcat together.

Some scripts we don't need at this stage, so we just don't have them under ww/usr:

- `upgrade` - upgrades the system (eg applies database schema changes). WombatDialer does this automatically
  if it detects an outdated database.
- `lifecycle [STATE]` - notifies a central server about the life-cycle of the current app
- `pushstats [JSON]` - pushes a JSON blob


Configuration
-------------

The default configuration is stored under ww/cfg/defaults.json.

----
{
 "notify_url": "http://1.2.3.4",
 "webapp": "Loway WombatDialer",
 "memory": 128,
 "timezone": "Europe/Rome"
}
----

If you want to override it, you should specify your parameters (only the ones you want to override) as JSON text in:

----
docker run -e CFG='{"memory":400,"timezone":"GMT"}' -p 8080:8080 -d loway/wombatdialer
----




