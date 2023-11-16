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
