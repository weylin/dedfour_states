base:
  '*':
    - salt_minion
    - users

  'salt-master*':
    - salt_master
