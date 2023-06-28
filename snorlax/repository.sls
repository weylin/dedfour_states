{% set snorlax_git_ssh_priv_key = pillar['snorlax_git_ssh_priv_key'] %}
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
