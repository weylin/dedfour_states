{% set token = salt.pillar.get("snorlax_token", "") %}

snorlax|setenv|api_key:
   environ.setenv:
     - name: discordApiKey
     - value: {{ token }}
     - update_minion: True
