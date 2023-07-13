munchlax|bot|service:
  file.managed:
    - name: /etc/systemd/system/munchlax.service
    - contents: |
        [Unit]
        Description=CloudBot (Snorlax) Python Script

        [Service]
        User=munchlax
        WorkingDirectory=/home/munchlax/bot
        ExecStart=/usr/bin/python3 /home/munchlax/bot/main.py
        Restart=always

        [Install]
        WantedBy=multi-user.target
  service.running:
    - name: munchlax
    - enable: True
    - require:
      - file: munchlax|bot|service
