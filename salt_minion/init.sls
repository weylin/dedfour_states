minion|pkgs:
  pkg.installed:
    - pkgs:
      - salt-minion
      - supervisor

minion|service:
  service.running:
    - name: salt-minion
    - enable: True
    - require:
      - pkg: minion|pkgs

minion|supervisord|service:
  service.running:
    - name: supervisor
    - enable: True
    - require:
      - pkg: minion|pkgs

{% set files_dir = 'salt_minion/files' %}
{% set destination_dir = '/etc/salt/minion.d/' %}

{% for file in salt['cp.list_master'](prefix=files_dir) %}
{% set filename = file.split('/')[-1] %}
  {% if not filename.startswith('.') %}
minion|manage_{{ filename }}:
  file.managed:
    - name: {{ destination_dir }}{{ filename }}
    - source: salt://{{ file }}
    - template: jinja
    - user: root
    - group: users
    - mode: 744
  {% endif %}
{% endfor %}
