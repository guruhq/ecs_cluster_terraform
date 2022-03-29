Content-Type: multipart/mixed; boundary="MIMEBOUNDARY"
MIME-Version: 1.0

--MIMEBOUNDARY
Content-Transfer-Encoding: 7bit
Content-Type: text/cloud-config
Mime-Version: 1.0

#cloud-config

bootcmd:
  - mkdir -p /etc/ecs
  - echo 'ECS_CLUSTER=${ecs_cluster_name}' >> /etc/ecs/ecs.config
  - echo 'ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","syslog","fluentd","awslogs","gelf"]' >> /etc/ecs/ecs.config

--MIMEBOUNDARY
Content-Transfer-Encoding: 7bit
Content-Type: text/cloud-config
Mime-Version: 1.0

${cloud_config}
--MIMEBOUNDARY--
