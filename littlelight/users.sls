{% from 'banner_macro.jinja' import banner %}

littlelight|group:
  group.present:
    - name: littlelight

littlelight|user:
  user.present:
    - name: littlelight
    - fullname: LittleLight (CloudBotIRC Fork)
    - home: /home/littlelight
    - shell: /bin/bash
    - groups:
      - littlelight
    - createhome: True
    - password: "!" # Disable password login.
    - require:
      - group: littlelight|group

littlelight|ssh_key|directory:
  file.directory:
    - name: /home/littlelight/.ssh
    - user: littlelight
    - group: littlelight
    - mode: 700
    - require:
      - littlelight|user

littlelight|ssh|private_key:
  file.managed:
    - name: /home/littlelight/.ssh/id_ed25519_littlelight
    - user: littlelight
    - group: littlelight
    - mode: 600
    - defaults:
        banner: {{ banner() }}
    - contents_pillar: littlelight_ssh_private_key
    - gpg_decrypted: True
    - require:
      - littlelight|ssh_key|directory

littlelight|ssh|public_key:
  file.managed:
    - name: /home/littlelight/.ssh/authorized_keys
    - user: littlelight
    - group: littlelight
    - mode: 600
    - defaults:
        banner: {{ banner() }}
    - contents: |
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhNP1Xa7gLmECiMslc9UCF4Xc0OBDNY+IEgorPF1eUd littlelight@bots.dedfour.com
    - require:
      - littlelight|ssh_key|directory
