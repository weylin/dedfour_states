snorlax|pkg|install:
  pkg.installed:
    - git

snorlax|install|python310:
  pkg.installed:
    - name: python3.10
    - onlyif: 'which python3.10 > /dev/null 2>&1 || exit 1'

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

{% set snorlax_git_ssh_priv_key- =  pillar['snorlax_git_ssh_priv_key'] %}
{% set snorlax_repo_url = pillar['snorlax_repo_url'] %}

snorlax|ssh_key|directory:
  file.directory:
    - name: /home/cappy/.ssh
    - user: cappy
    - group: cappy
    - mode: 700

snorlax|ssh|private_key:
  file.managed:
    - name: /home/cappy/.ssh/id_rsa
    - user: cappy
    - group: cappy
    - mode: 600
    - contents_pillar: github_ssh_private_key

snorlax|git|config:
  git.config_set:
    - name: core.sshCommand
    - value: "ssh -i /home/snorlax/.ssh/id_rsa -o StrictHostKeyChecking=no"
    - global: True
    - user: snorlax

snorlax|git|repo:
  git.latest:
    - name: {{ snorlax_repo_url }}
    - target: /home/snorlax/git
    - user: snorlax
    - require:
      - file: snorlax|ssh|private_key
      - git: snorlax|git|config

snorlax|bot|service:
  file.managed:
    - name: /etc/systemd/system/snorlax.service
    - contents: |
        [Unit]
        Description=CloudBot (Snorlax) Python Script

        [Service]
        User=snorlax
        WorkingDirectory=/home/snorlax/git
        ExecStart=/usr/bin/python3 /home/snorlax/git/Snorlax/snorlax.py
        Restart=always

        [Install]
        WantedBy=multi-user.target
  service.running:
    - name: snorlax
    - enable: True
    - require:
      - file: snorlax|bot|service
      - git: snorlax|git|repo

