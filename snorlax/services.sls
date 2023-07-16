{% set token = salt.pillar.get("snorlax_token", "") %}

snorlax|bot|service:
  file.managed:
    - name: /etc/systemd/system/snorlax.service
    - contents: |
        [Unit]
        Description=CloudBot (Snorlax) Python Script

        [Service]
        User=snorlax
        WorkingDirectory=/home/snorlax/bot
        ExecStart=/usr/bin/python3 /home/snorlax/bot/main.py
        Environment="discordApiKey={{ token }}"
        Restart=always

        [Install]
        WantedBy=multi-user.target

snorlax|bot|service_running:
  service.running:
    - name: snorlax
    - enable: True
    - require:
      - file: snorlax|bot|service
