{% set token = salt.pillar.get("munchlax_token", "") %}
{% set weather_api = salt.pillar.get("openWeatherApiKey", "") %}
{% set tmdb_api = salt.pillar.get("tmdbApiKey", "") %}

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
        Environment="openWeatherApiKey={{ weather_api }}"
        Environment="tmdbApiKey={{ tmdb_api }}"
        Restart=always

        [Install]
        WantedBy=multi-user.target
munchlax|bot|service_running:
  service.running:
    - name: munchlax
    - enable: True
    - require:
      - file: munchlax|bot|service

munchlax|bot|service_restarter:
  file.managed:
    - name: /etc/systemd/system/munchlax-restart.service
    - contents: |
        [Unit]
        Description=Munchlax auto-restart service.
        After=network.target
        [Service]
        Type=oneshot
        ExecStart=/usr/bin/systemctl restart munchlax.service
        [Install]
        WantedBy=multi-user.target

munchlax|bot|service_watcher:
  file.managed:
    - name: /etc/systemd/system/munchlax-restart.path
    - contents: |
        [Path]
        PathModified=/home/munchlax/bot/cogs/
        PathModified=/home/munchlax/bot/main.py

        [Install]
        WantedBy=multi-user.target
munchlax|bot|service_watcher_running:
  service.running:
    - name: munchlax-restart.path
    - enable: True
    - require:
      - file: munchlax|bot|service_watcher
