{% set munchlax_git_ssh_priv_key = pillar['munchlax_git_ssh_priv_key'] %}

munchlax|group:
  group.present:
    - name: munchlax

munchlax|user:
  user.present:
    - name: munchlax
    - fullname: Munchlax (discord.py bot)
    - home: /home/munchlax
    - shell: /bin/bash
    - groups:
      - munchlax
    - createhome: True
    - password: "!" # Disable password login.
    - require:
      - group: munchlax|group

munchlax|ssh_key|directory:
  file.directory:
    - name: /home/munchlax/.ssh
    - user: munchlax
    - group: munchlax
    - mode: 700
    - require:
      - munchlax|user

munchlax|ssh|private_key:
  file.managed:
    - name: /home/munchlax/.ssh/id_ed25519_munchlax
    - user: munchlax
    - group: munchlax
    - mode: 600
    - contents_pillar: munchlax_ssh_private_key
    - require:
      - munchlax|ssh_key|directory

munchlax|ssh|public_key:
  file.managed:
    - name: /home/munchlax/.ssh/authorized_keys
    - user: munchlax
    - group: munchlax
    - mode: 600
    - contents: |
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIuOvLam8EFhQFzWq37GTPQ/96X3Ud4QJtklhPiAC7h/ munchlax@bots.dedfour.com
    - require:
      - munchlax|ssh_key|directory
