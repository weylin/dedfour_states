{% set target_directory = "/home/littlelight/CloudBot" %}

littlelight|directory:
  file.directory:
    - name: {{ target_directory }}
    - user: littlelight
    - group: littlelight
    - mode: 755
    - makedirs: True

littlelight|config:
  file.managed:
    - name: {{ target_directory }}/config.json
    - user: littlelight
    - group: littlelight
    - contents_pillar: littlelight_config_json
    - gpg_decrypted: True
    - require:
      - file: littlelight|directory
