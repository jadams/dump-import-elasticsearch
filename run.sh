#!/bin/sh
docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "ES_JAVA_OPTS=-Xms2g -Xmx2g" -e "discovery.type=single-node" -v /tank/esdata:/usr/share/elasticsearch/data:Z  docker.elastic.co/elasticsearch/elasticsearch:7.3.0
docker run -d --name kibana --link elasticsearch:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:7.3.0
docker run -d --name logstash --link elasticsearch:elasticsearch -v /root/pipeline:/usr/share/logstash/pipeline:ro docker.elastic.co/logstash/logstash:7.3.0
docker run -d --name filebeat --link logstash:logstash -v /root/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro -v /tank/dumps:/dumps:ro docker.elastic.co/beats/filebeat:7.3.0
