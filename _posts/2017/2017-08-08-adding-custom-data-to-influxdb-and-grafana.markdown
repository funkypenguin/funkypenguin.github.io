---
layout: "post"
title: "Getting started visualizing IOT data with Grafana"
date: "2017-08-07 16:21"
category: note
excerpt: Getting started with Grafana
---

A friend asked for help getting his "IOT" sensor data into Grafana for visualization, so I wrote up this minimal, bare-bones process, which is **applicable to CentOS6/7**...

{:toc}

## Install influxDB

Add the influxdb repository:

```
cat <<EOF | tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/centos/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF
```

Then install influxdb:

```
yum -y install influxdb
```

Set influxdb to start on boot, and start it now manually:

```
chkconfig influxdb on
/etc/init.d/influxdb start
```

Create your first database using the ```influx``` command. In the example below, I created database "powerstuff":

```
influx
Connected to http://localhost:8086 version 1.3.1
InfluxDB shell version: 1.3.1
> CREATE DATABASE powerstuff
> quit
```

That's it, you're done. You have a basic InfluxDB installed.

## Install Grafana

Install the Grafana repository:

```
curl -s \ https://packagecloud.io/install/repositories/grafana/stable/script.rpm.sh.rpm | \
 sudo bash
```

Then install grafana:

```
yum -y install grafana
```

Set grafana-server to start on boot, and start it now manually:

```
chkconfig grafana-server on
/etc/init.d/grafana-server start
```

By default, Grafana-server listens on localhost:3000. You can proxy this behind apache (with ProxyPass) or nginx as required. For a POC however, you could simple SSH-tunnel port 3000 as illustrated below:

```
ssh <server IP> -L 3000:127.0.0.1:3000
```

Access the local grafana interface on http://localhost:3000/, (user admin, password admin)

Create a datasource, with access type set to "Proxy"

![](../../images/grafana_example.png)

## Add some data

The simplest way to add data to the database is after retrieving it from the IOT sensors, using the "influx" CLI command:

```
[root@grafanademo ~]# influx -database powerstuff -execute 'INSERT sensors,sensor=Out1 value=4.38'
[root@grafanademo ~]#
```

Theoretically, you can also import old data (provided you have the timestamp entries) by formatting the data into a file (demo.txt) like this:

```
# DML
# CONTEXT-DATABASE:powerstuff
# CONTEXT-RETENTION-POLICY:autogen
sensors,sensor=Out1 value=801 1439856000
sensors,sensor=Out1 value=29 1439856000
sensors,sensor=Out1 value=38 1439856000
sensors,sensor=Out1 value=47 1439856000
sensors,sensor=Out1 value=109 1439858880
```

And then importing it like this:

```
influx  -import -path=demo.txt -precision=s
```

The import result should look something like this:

```
2017/08/08 09:41:33 Processed 0 commands
2017/08/08 09:41:33 Processed 5 inserts
2017/08/08 09:41:33 Failed 0 inserts
```

## Add a dashboard

Having added (a) the data source in Grafana, and (b) some actual data to influx, you can start creating dashboard(s) with the recorded data, as illustrated below (it'll look more interesting when you actually have real data to display!)

![](../../images/grafana.gif)
