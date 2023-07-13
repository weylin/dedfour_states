{% set token = salt.pillar.get("munchlax_token", "") %}

munchlax|setenv|api_key:
   environ.setenv:
     - name: discordApiKey
     - value: {{ token }}
     - update_minion: True
