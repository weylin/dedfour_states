{% set token = salt.pillar.get("snorlax_token", "") %}

snorlax|setenv|api_key:
  cmd.run:
    - name: "export discordApiKey={{ token }}"
    - runas: snorlax
    - require:
      - user: snorlax
