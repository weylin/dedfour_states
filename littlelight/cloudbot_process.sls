{% set git_repo = "git@github.com:weylin/CloudBot.git" %}
{% set target_directory = "/home/cloudbot/CloudBot" %}

cloudbot|repo:
  git.latest:
    - name: {{ git_repo }}
    - target: {{ target_directory }}
    - user: cloudbot
    - require:
      - user: cloudbot_user

cloudbot|config:
  file.managed:
    - name: /home/cloudbot/CloudBot/config.json
    - user: cloudbot
    - group: cloudbot
    - source:
    - require:
      - git: cloudbot|repo
