littlelight|install_python34:
  pkg.installed:
    - name: python3.4
    - onlyif: 'which python3.4 > /dev/null 2>&1 || exit 1'

littlelight|cloudbot|group:
  group.present:
    - name: cloudbot

littlelight|cloudbot|user:
  user.present:
    - name: cloudbot
    - fullname: Cloud Bot (Little Light)
    - home: /home/cloudbot
    - shell: /bin/bash
    - groups:
      - cloudbot
    - createhome: True
    - password: "!"
    - require:
      - group: cloudbot_group
