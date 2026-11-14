+++
title = "Parse Ansible Log With `sed` And `jaq`"
slug = "parsing-ansible-log-with-sed-and-jaq"
description = "a handy trick to parse ansible json logs"
+++



```shell
sed -z -n -E 's/(.*?\s+[=][>]\s+([{][\n]\s{4,}"([^\n]+[\n])+[}][\n]).*?)+/\2/gp' $(LOGS_PATH)/ansible.log | jaq -s
```
