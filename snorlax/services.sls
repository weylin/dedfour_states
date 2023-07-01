snorlax|bot|service:
  file.managed:
    - name: /etc/systemd/system/snorlax.service
    - contents: |
        [Unit]
        Description=CloudBot (Snorlax) Python Script

        [Service]
        User=snorlax
        WorkingDirectory=/home/snorlax/git
        ExecStart=/usr/bin/python3 /home/snorlax/git/Snorlax/snorlax.py
        Restart=always

        [Install]
        WantedBy=multi-user.target
  service.running:
    - name: snorlax
    - enable: True
    - require:
      - file: snorlax|bot|service
