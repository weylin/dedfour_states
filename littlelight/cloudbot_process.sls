{% set git_repo = "https://github.com/weylin/CloudBot.git" %}
{% set target_directory = "/home/littlelight/CloudBot" %}

littlelight|repo:
  git.latest:
    - name: {{ git_repo }}
    - target: {{ target_directory }}
    - user: littlelight

littlelight|config:
  file.managed:
    - name: /home/littlelight/CloudBot/config.json
    - user: littlelight
    - group: littlelight
    - contents_pillar: littlelight_config_json
    - gpg_decrypted: True
    - require:
      - git: littlelight|repo
