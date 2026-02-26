base:
  '*':
    - salt_minion
    - users

  'salt-master*':
    - salt_master

  'dedfour*':
    - znc
    - irc

  'bots*':
    - littlelight
    - munchlax
    - bridge

  'grain@roles:vagrant':
    - match: grain
    - vagrant
