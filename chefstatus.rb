#!/usr/bin/ruby
# Pingdom_http_custom_check
# Chef Status Converter

require 'nokogiri'
require 'curb'
require 'json'
require 'benchmark'

chefserver = 'https://chef_server.front_end.url/'

response = Benchmark.realtime do
  @c = Curl::Easy.perform("#{chefserver}/_status")
end

getstatus = JSON.parse(@c.body_str)

##Overall Chef Status
filename = 'chef.xml'
builder = Nokogiri::XML::Builder.new do |xml|
  xml.pingdom_http_custom_check do
    xml.status "#{getstatus['status'] == 'pong' ? 'OK' : 'ERROR'}"
    xml.response_time (response * 1000).round(3)
  end
end
File.write(filename, builder.to_xml)

##Iterate over upstreams/individual services
getstatus['upstreams'].each do |key, value|
  filename = "#{key}.xml"
  builder = Nokogiri::XML::Builder.new do |xml|
    xml.pingdom_http_custom_check do
      xml.status "#{value == 'pong' ? 'OK' : 'ERROR'}"
      xml.response_timeu (response * 1000).round(3)
    end
  end
  File.write(filename, builder.to_xml)
end
