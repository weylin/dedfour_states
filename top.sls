base:
  '*':
    - salt_minion
    - users

  'salt-master*':
    - salt_master

  'dedfour.dedfour.com':
    - znc
    - irc

  'bots.dedfour.com':
    - littlelight
    - snorlax
    - munchlax
