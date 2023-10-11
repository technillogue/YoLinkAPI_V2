# Use the official InfluxDB image as a base image

FROM influxdb:1.8

# Install necessary packages for Python, MQTT, Supervisor
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

ENV GF_INSTALL_PLUGINS="grafana-worldmap-panel,grafana-clock-panel"
ENV GF_AUTH_ANONYMOUS_ENABLED="true"
# Install Grafana
RUN wget https://dl.grafana.com/oss/release/grafana_8.2.3_amd64.deb && \
    dpkg -i grafana_8.2.3_amd64.deb && \
    rm grafana_8.2.3_amd64.deb

WORKDIR /app
COPY requirements.txt /app
# RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt


# Make the Grafana data directory
RUN mkdir -p /var/lib/grafana

# Expose the necessary ports for InfluxDB and Grafana
EXPOSE 8086 3000

# Start supervisord to manage the processes
#CMD ["/usr/bin/supervisord"]

COPY ./init-influxdb.sh /app/init-influxdb.sh
COPY ./src /app


# Copy a supervisord configuration file into the container
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Local MQTT Server (Used by HomeAssistant)
#EXPOSE 1883
# YoLink MQTT Server (Consume YoLink Messages)
#EXPOSE 8003
# Influx DB (Send data to InfluxDB)
#EXPOSE 8086
COPY ./src/yolink_config.json /app/yolink_config.json
CMD /usr/src/app/init-influxdb.sh & /usr/bin/supervisord
#CMD ["python3", "main.py", "--config", "yolink_config.json", "--debug"]
