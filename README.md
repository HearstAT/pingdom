# Pingdom Custom HTTP Check - Chef Status

Pingdom requires a specific type of output for their [custom checks](http://royal.pingdom.com/2008/07/14/new-pingdom-feature-custom-monitoring-type/), so I wrote a script to do that for private chef.

This is a script written in ruby that can be ran from anywhere as long as it can hit `https://chef_server.front_end.url/_status`

The script will produce the following files based of the [chef status](https://docs.chef.io/server_high_availability.html#check-ha-status) returns:

* chef.xml - Overal Status of the server
* chef_solr.xml - Status of Chef SOLR service
* chef_sql.xml - Status of Chef SQL Server
* oc_chef_authz.xml - Status of Chef OC Auth service

Each xml will be created with similar data listed below

```
<pingdom_http_custom_check>
    <status>OK</status>
    <response_time>96.777</response_time>
</pingdom_http_custom_check>
```

Status is going to be either OK or ERROR
Response time generated via ruby benchmark timing the response of the curl against the service check
