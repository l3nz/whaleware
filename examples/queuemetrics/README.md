Running QueueMetrics under whaleware
====================================

QueueMetrics is a high-profile call-center monitoring & reporting tool for the Asterisk PBX, developed by Loway. https://www.queuemetrics.com

The application running under whaleware is available as image 'loway/queuemetrics' from https://registry.hub.docker.com/r/loway/queuemetrics/

The Dockerfile
--------------

The [Doockerfile under build/](build/Dockerfile) is as plain as it can be. It starts from an image of CentOS 6 that already
contains whaleware, exposes HTTP port 8080, installs QueueMetrics using the yum package manager as you would manually
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
- `monitor` - we call a specific URL to make sure QueueMetrics is running. QueueMetrics has an embedded health
  service that checks everything is okay and returns the code "QMUP" if all is in order.
- `svcdown` and `svcup` will respectively shutdown and start MySQL and Tomcat together.

Some scripts we don't need at this stage, so we just don't have them under ww/usr:

- `upgrade` - upgrades the system (eg applies database schema changes). QueueMetrics does this automatically
  if it detects an outdated database.
- `lifecycle [STATE]` - notifies a central server about the life-cycle of the current app
- `pushstats [JSON]` - pushes a JSON blob


Configuration
-------------

The default configuration is stored under ww/cfg/defaults.json.


    {
     "notify_url": "http://1.2.3.4",
     "webapp": "Loway QueueMetrics",
     "memory": 128,
     "timezone": "Europe/Rome"
    }


If you want to override it, you should specify your parameters (only the ones you want to override) as JSON text in:

    docker run -e CFG='{"memory":400,"timezone":"GMT"}' -p 8080:8080 -d loway/queuemetrics









