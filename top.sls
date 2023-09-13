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
    - snorlax
    - munchlax
    - bridge
