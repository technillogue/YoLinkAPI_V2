#!/bin/bash
set -o xtrace -o errexit -o pipefail
mkdir -p /mount/data/{grafana,influxdb}
ln -s /mount/data/grafana /var/lib/grafana
ln -s /mount/data/influxdb /var/lib/influxdb
# Wait for InfluxDB to start
until influx -execute "SHOW DATABASES" &>/dev/null
do
    echo "Waiting for InfluxDB..."
    sleep 1
done

# Create the homeassistant database
influx -execute "CREATE DATABASE homeassistant"
echo $?
# Optionally, create users, retention policies, etc.
# ...

echo "InfluxDB initialization completed."
