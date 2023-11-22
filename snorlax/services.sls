{% set token = salt.pillar.get("snorlax_token", "") %}
{% set weather_api = salt.pillar.get("openWeatherApiKey", "") %}
{% set tmdb_api = salt.pillar.get("tmdbApiKey", "") %}

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
        Environment="openWeatherApiKey={{ weather_api }}"
        Environment="tmdbApiKey={{ tmdb_api }}"
        Restart=always

        [Install]
        WantedBy=multi-user.target

snorlax|bot|service_running:
  service.running:
    - name: snorlax
    - enable: True
    - require:
      - file: snorlax|bot|service

snorlax|bot|service_restarter:
  file.managed:
    - name: /etc/systemd/system/snorlax-restart.service
    - contents: |
        [Unit]
        Description=Munchlax auto-restart service.
        After=network.target
        [Service]
        Type=oneshot
        ExecStart=/usr/bin/systemctl restart snorlax.service
        [Install]
        WantedBy=multi-user.target

snorlax|bot|service_watcher:
  file.managed:
    - name: /etc/systemd/system/snorlax-restart.path
    - contents: |
        [Path]
        PathModified=/home/snorlax/bot/cogs/
        PathModified=/home/snorlax/bot/main.py

        [Install]
        WantedBy=multi-user.target
snorlax|bot|service_watcher_running:
  service.running:
    - name: snorlax-restart.path
    - enable: True
    - require:
      - file: snorlax|bot|service_watcher
