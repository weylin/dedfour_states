littlelight|systemd|service:
  file.managed:
    - name: /etc/systemd/system/littlelight.service
    - contents: |
        [Unit]
        Description=LittleLight IRC Bot
        After=network.target
        
        [Service]
        Type=simple
        User=littlelight
        Group=littlelight
        WorkingDirectory=/home/littlelight/CloudBot
        ExecStart=/usr/bin/python3 /home/littlelight/CloudBot/start.py
        Restart=always
        RestartSec=10
        
        [Install]
        WantedBy=multi-user.target
    - require:
      - user: littlelight|user

littlelight|service|enabled:
  service.running:
    - name: littlelight
    - enable: True
    - require:
      - file: littlelight|systemd|service
