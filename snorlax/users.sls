snorlax|group:
  group.present:
    - name: snorlax

snorlax|user:
  user.present:
    - name: snorlax
    - fullname: Snorlax (discord.py bot)
    - home: /home/snorlax
    - shell: /bin/bash
    - groups:
      - snorlax
    - createhome: True
    - password: "!" # Disable password login.
    - require:
      - group: snorlax|group
