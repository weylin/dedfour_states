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
    - name: /home/snorlax/.ssh/id_ed25519_snorlax
    - user: snorlax
    - group: snorlax
    - mode: 600
    - contents_pillar: snorlax_ssh_private_key
    - gpg_decrypted: True
    - require:
      - snorlax|ssh_key|directory

snorlax|ssh|public_key:
  file.managed:
    - name: /home/snorlax/.ssh/authorized_keys
    - user: snorlax
    - group: snorlax
    - mode: 600
    - contents: |
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIuOvLam8EFhQFzWq37GTPQ/96X3Ud4QJtklhPiAC7h/ snorlax@bots.dedfour.com
    - require:
      - snorlax|ssh_key|directory
