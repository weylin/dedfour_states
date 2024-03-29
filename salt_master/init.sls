{% from 'banner_macro.jinja' import banner %}

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

master|dotd|config:
  file.directory:
    - name: /etc/salt/master.d/
    - user: root
    - group: users
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

{% set files_dir = 'salt_master/files' %}
{% set destination_dir = '/etc/salt/master.d/' %}

{% for file in salt['cp.list_master'](prefix=files_dir) %}
  {% set filename = file.split('/')[-1] %}
  {% if not filename.startswith('.') %}
master|manage_{{ filename }}:
  file.managed:
    - name: {{ destination_dir }}{{ filename }}
    - source: salt://{{ file }}
    - template: jinja
    - defaults:
        banner: {{ banner() }}
    - user: root
    - group: users
    - mode: 744
  {% endif %}
{% endfor %}
