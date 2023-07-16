{% set token = salt.pillar.get("munchlax_token", "") %}

munchlax|bot|service:
  file.managed:
    - name: /etc/systemd/system/munchlax.service
    - contents: |
        [Unit]
        Description=Munchlax Discord.py Bot.

        [Service]
        User=munchlax
        WorkingDirectory=/home/munchlax/bot
        ExecStart=/usr/bin/python3 /home/munchlax/bot/main.py
        Environment="discordApiKey={{ token }}"
        Restart=always

        [Install]
        WantedBy=multi-user.target
munchlax|bot|service_running:
  service.running:
    - name: munchlax
    - enable: True
    - require:
      - file: munchlax|bot|service
