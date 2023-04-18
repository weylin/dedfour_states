master|pkg:
  pkg.installed:
    - pkgs:
      - salt-api
      - salt-common
      - salt-master
      - salt-minion
      - salt-ssh

{% set apiuser = pillar['saltapi']['username'] %}
{% set apipassword = pillar['saltapi']['password'] %}

master|api_user:
  user.present:
    - name: {{ apiuser }}
    - password: {{ apipassword}}
    - groups:
      - root
