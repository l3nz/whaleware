whaleware
=========

A standard startup template for Docker images.

Benefits
--------
- Common filesystem layout. Just replace files as needed.
- JSON configuration. The configuration is passed as a JSON file that is merged with an existing defaults file. 
  So you do not have to track a large number of separate environment variables. 
- Centrally reports the state of an instance. 
- Periodically reports health statistics.
- Monitors the application and restarts it if needed
- Makes no assumption on the kind of services used for reporting - we use HTTP, but you may hot-swap the reporting
  scripts to implement your own checks and reporting format.
- Tries to terminate all services gracefully on stops.



Directories used
----------------

- /whaleware - where all files for whaleware live
- /data - where all data for an app is to be positioned
- /backup - a mount point for backup scripts to send data to the host


Scripts used
------------

- run - the script that orchestrates all other scripts
- firstboot - the scripts that sets the system up for the first boot
- upgrade - upgrades the system (eg applies database schema changes)
- warmup - starts services and warms them up
- lifecycle [STATE]
- pushstats -
- monitor -
- stop - tries to terminate services gracefully



An app's life cycle
-------------------

- FIRSTBOOT
- UPGRADING
- WARMUP
- UP
- RESTARTING
- STOPPED



