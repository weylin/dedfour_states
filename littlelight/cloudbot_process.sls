{% set git_repo = "git@github.com:weylin/CloudBot.git" %}
{% set target_directory = "/home/littlelight/CloudBot" %}

littlelight|repo:
  git.latest:
    - name: {{ git_repo }}
    - target: {{ target_directory }}
    - user: littlelight
    - require:
      - user: littlelight|user

littlelight|config:
  file.managed:
    - name: /home/littlelight/CloudBot/config.json
    - user: littlelight
    - group: littlelight
    - contents: {{ pillar['littlelight_config_json'] | json }}
    - require:
      - git: littlelight|repo
