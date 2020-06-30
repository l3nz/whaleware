whaleware
=========

	

A standard startup template for Docker server images. Available as a base CentOS 7 image 
under the name 'lenz/whaleware' - https://registry.hub.docker.com/r/lenz/whaleware

Principles
----------

- Server instances should have a fine-grained life cycle. Starting up a web instance does not
  mean that the instance is immediately ready to serve requests. It might have to warm itself
  up, update a local database, load resources, etc. You do not want to add an instance to a 
  load balancing pool before it's ready to run.
- Server instances should be able to report their own health periodically.
- Server instances should contain a watchdog process that will restart them as needed.
- As the number of configuration variables tends to be quite large, instead of passing 
  a large set of parameters, we prefer using a JSON structure. This JSON structure is then 
  filled in with embedded default parameters, so that only non-default ones are to
  be passed externally.
- Though we have a preference for JSON over HTTP, notifications should be environment-agnostic.
  You could store the current lifecycle information and app health on a database, or on
  an external webapp, on `etcd` or in an Elasticsearch database. You should be able to choose.
- Running a server within Docker means receiving Docker signals - so you can start an orderly
  shutdown in case the instance needs to terminate.
- Data should be stored in a separate directory, ready to mount a data-only container (if you want to)
  or to run without persistent data at all.
- You should be able to customize easily all of the features above, and decide what to use and 
  what to ignore. You want notifications? edit one file. You don't want notifications? just leave it blank.


Benefits
--------

- Using a common filesystem layout. Just replace files as needed under `/ww/usr`
- All-JSON configuration. The configuration is passed as a JSON file that is merged with an existing defaults file. 
  So you do not have to track a large number of separate environment variables. 
- Centrally reports the state of an instance. 
- Periodically reports health statistics.
- Monitors the application and restarts it if needed
- Makes no assumption on the kind of services used for reporting - we use HTTP, but you may hot-swap the reporting
  scripts to implement your own checks and reporting format.
- Tries to terminate all services gracefully on stops.


How it works
------------

When an instance is started (via `/ww/run`) it gets the external configuration from the CFG 
parameter, applies any defaults found in `/www/etc/default_cfg.json` and saves it under
`/www/etc/cfg.json` . This configuration can be queried at any time though the `/ww/cfg` script.

On first start, it runs the **boot** script to edit the default image according to the 
configuration received externally. This happens each time an image is booted.

Then it checks to see if the data-only container is initialized. Of course this only makes sense
if you have a data-only container mounted under `/data`. If none is mounted, the webapp will
always perform a first boot.

If `/data` is not initialized, it launches the **firstboot** script so you can create databases, copy
configuration scripts, etc. 

After this, the **upgrade** script is run. This is used to detect if `/data` contains material from
a previous version that needs upgrading.

After this, the service(s) are started and **warmup** is called. This is needed to 
run any warmup queries that might be needed to provide acceptable production performance.

Only at this point the app is considered UP and is ready to serve instances.

Every 30 seconds, the **monitor** script is run. It is supposed to query the app and return a JSON
object with health information (number of queries processed, free memory, etc.). This information is
posted to a database through the **pushstats** script.

If the monitor scripts returns with an error code, then all services are stopped and restarted 
(through **svcdown** and **svcup**).

While the app is running, if you issue a `docker stop` the run process will shutdown services and 
terminate cleanly.

Most likely, you will NOT need all of these stages in your app. So you can simply create
the scripts you need and leave other scripts blank.

Permanent storage
-----------------

whaleware offers a common pattern to manage permanent storage. All storage should be stored under the "/data"
directory. If you want this to be permanent, you can either use a data-only container that exports
it or mount it as a local folder.

### Using a data-only container

The simplest way to run a permanent data-only container is to create a named container and bind it
to your whaleware image:

    docker run --name=MYWBT loway/data true
    docker run --volumes-from MYWBT -p 8080:8080 -d loway/wombatdialer

By using a named container, the likelihood of binding to the wrong container is reduced.

### Using a local directory

You can also bind your whaleware image to a local folder, just like in:

    mkdir -p /opt/data/WBT1DATA
    docker run -v /opt/data/WBT1DATA:/data -p 8080:8080 -d loway/wombatdialer

This makes it easy to access and inspect the contents of your data container at the price of
a somehow "messier" configuration on the host.


Configuration
-------------

whaleware stores all configuration as a JSON file. The default configuration is stored
in `/ww/etc/defaults.json`. When the app is run, a current configuration is computed by merging 
it with the contents of the CFG environment variable, that is to contain a JSON structure.
You then access the results of the merge though the `/ww/cfg` script.

This way you can override the default configuration on the command line, as in:

    docker run -e CFG='{"memory":400}' -p 8080:8080 -d loway/wombatdialer

And you can still have fairly complex configuration.


Directories used
----------------

- `/ww` - where all files for whaleware live
- `/ww/usr` - where scripts are to be put
- `/ww/files` - where your own configuration files can be put
- `/ww/etc` - where the default configuration and the current configuration are stored
- `/data` - where all data for an app is to be positioned
- `/backup` - a mount point for backup scripts to send data to the host


Scripts used
------------

Default scripts:

- `/ww/run` - the script that orchestrates all other scripts
- `/ww/cfg` - reads a configuration value from the current configuration

Under `/ww/usr` are the following scripts. Replace the one(s) you need.

- `boot` - the script that sets the sytem up on an image boot. Sets the system up but for the `/data` directory. 
   Runs as first script on each and every boot.
- `firstboot` - on the first boot, the `/data` directory is initialized. It happens just once if you have permanent storage.
- `upgrade` - upgrades the system (eg applies database schema changes). It is run on every boot.
- `warmup` - starts services and warms them up. It is run on every boot.
- `monitor` - return a JSON blob about the state of the service. If it returns with an error code different than zero,
  the webapp needs to be restarted.

Helper scripts:

- `svcdown` - shut down the server
- `svcup` - starts the server
- `lifecycle [STATE]` - notifies a central server about the life-cycle of the current app. The default implementation
  just logs it on stdout.
- `pushstats [JSON]` - pushes the JSON blob returned by `monitor` to a monitoring service. The default implementation
  does nothing. 


An app's life cycle
-------------------

An app progresses trough a life-cycle. The life-cycle can be pushed externally through the `lifecycle` script so
that an external system can be aware of the current state of the app.

- DOCKERUP - An optional state notified by a startup script before the app is started
- BOOT - System is running the `boot` script.
- FIRSTBOOT - System is running the `firstboot` script.
- UPGRADING - System is running the `upgrading` script.
- WARMUP - System is running the `warmup` script.
- UP - System is ready to serve requests.
- RESTARTING - System is being restarted, because either the `monitor` script encountered a problem or
  a SIGHUP was received by the Docker host. After the restart, the system is flagged as UP.
- STOPPED - System is being stopped because it received a SIGTERM from Docker (likely a "docker stop" was performed)
- ERROR - System is in an unrecoverable error state and is terminating (not currently used).
- DOCKERDOWN - An optional state notified by a stop script after the Docker app is shutdown

Examples
--------

* [wombatdialer](examples/wombatdialer/wombatdialer.md). - a next generation dialer application for the Asterisk PBX. 
  It is interesting because it is a Java web application with embedded MySQL
  and has a complex life cycle - so you can see the basic components in action.
* [asterisk-load-test](examples/asterisk-load-test/README.md). - a set of plain Asterisk images that you can hot-swap. 
  AMI and ARI ports are up and ready for developement and testing. Now available for Asterisk 1.8, Asterisk 11, Asterisk 12 and 
  Asterisk 13.

