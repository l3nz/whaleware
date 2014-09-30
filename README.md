whaleware
=========

	

A standard startup template for Docker server images.

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
  what to ignore. You don't want notifications? leave them blank.


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
- `/ww/cfg` - reads a configuration variale from the current configuration

Under `/ww/usr` are the following scripts. Replace the one(s) you need.

- `boot` - the script that sets the sytem up on an image boot. Sets the system up but for the `/data` directory. Runs on every boot.
- `firstboot` - on the first boot, the `/data` directory is initialized. It happens just once if you have permanent storage.
- `upgrade` - upgrades the system (eg applies database schema changes)
- `warmup` - starts services and warms them up
- `lifecycle [STATE]` - notifies a central server about the life-cycle of the current app
- `pushstats [JSON]` - pushes a JSON blob
- `monitor` - return a JSON blob about  the state of the service. If it returns with an error code different than zero,
  the webapp needs to be restarted.
- `svcdown` - shut down the server
- `svcup` - starts the server




An app's life cycle
-------------------

To be done

- BOOT
- FIRSTBOOT
- UPGRADING
- WARMUP
- UP
- RESTARTING
- STOPPED
- ERROR


Example
-------

To be done...






