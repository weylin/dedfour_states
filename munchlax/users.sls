{% from 'banner_macro.jinja' import banner %}

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
    - defaults:
        banner: {{ banner() }}
    - contents_pillar: munchlax_ssh_private_key
    - gpg_decrypted: True
    - require:
      - munchlax|ssh_key|directory

munchlax|ssh|public_key:
  file.managed:
    - name: /home/munchlax/.ssh/authorized_keys
    - user: munchlax
    - group: munchlax
    - mode: 600
    - defaults:
        banner: {{ banner() }}
    - contents: |
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB25ClVHfAeaDeUZ0pBh7sbN0hul1LtLrU5UOsqjZq3+ munchlax@bots.dedfour.com
    - require:
      - munchlax|ssh_key|directory
