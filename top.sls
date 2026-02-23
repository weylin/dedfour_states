base:
  '*':
    - salt_minion
    - users
{% if grains['roles'] %}
    - match: grain
    - vagrant:
      - vagrant
{% endif %}

  'salt-master*':
    - salt_master

  'dedfour*':
    - znc
    - irc

  'bots*':
    - littlelight
    - munchlax
    - bridge
