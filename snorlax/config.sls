{% set token = salt.pillar.get("snorlax_token", "") %}

snorlax|manage|api_key:
  file.line:
    - name: /home/snorlax/git/Snorlax/snorlax.py
    - match: "token = ''"
    - mode: replace
    - content: "token = '{{ token }}'"
