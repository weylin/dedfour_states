{% from 'banner_macro.jinja' import banner %}

bridge|group:
  group.present:
    - name: bridge

bridge|user:
  user.present:
    - name: bridge
    - fullname: bridge (discord <> irc)
    - home: /home/bridge
    - shell: /bin/bash
    - groups:
      - bridge
    - createhome: True
    - password: "!" # Disable password login.
    - require:
      - group: bridge|group

bridge|ssh_key|directory:
  file.directory:
    - name: /home/bridge/.ssh
    - user: bridge
    - group: bridge
    - mode: 700
    - require:
      - bridge|user

bridge|bot|directory:
  file.directory:
    - name: /home/bridge/bot/
    - user: bridge
    - group: bridge
    - mode: 700
    - require:
      - bridge|user

bridge|ssh|private_key:
  file.managed:
    - name: /home/bridge/.ssh/id_ed25519_bridge
    - user: bridge
    - group: bridge
    - mode: 600
    - defaults:
        banner: {{ banner() }}
    - contents_pillar: bridge_ssh_private_key
    - gpg_decrypted: True
    - require:
      - bridge|ssh_key|directory

bridge|ssh|public_key:
  file.managed:
    - name: /home/bridge/.ssh/authorized_keys
    - user: bridge
    - group: bridge
    - mode: 600
    - defaults:
        banner: {{ banner() }}
    - contents: |
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMX+soWaZpCkPoV1PJnsrlTYnt3vgz5dCAkbHA4e1Q/v bridge@bots.dedfour.com
    - require:
      - bridge|ssh_key|directory
