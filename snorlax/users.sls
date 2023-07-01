{% set snorlax_git_ssh_priv_key = pillar['snorlax_git_ssh_priv_key'] %}

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

snorlax|ssh_key|directory:
  file.directory:
    - name: /home/snorlax/.ssh
    - user: snorlax
    - group: snorlax
    - mode: 700
    - require:
      - snorlax|user

snorlax|ssh|private_key:
  file.managed:
    - name: /home/snorlax/.ssh/id_rsa
    - user: snorlax
    - group: snorlax
    - mode: 600
    - contents_pillar: snorlax_ssh_private_key
    - require:
      - snorlax|ssh_key|directory
