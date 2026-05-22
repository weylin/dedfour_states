littlelight|bot|service:
  file.managed:
    - name: /etc/systemd/system/littlelight.service
    - contents: |
        [Unit]
        Description=LittleLight IRC Bot (CloudBot)
        After=network.target

        [Service]
        Type=simple
        User=littlelight
        Group=littlelight
        WorkingDirectory=/home/littlelight/CloudBot
        # Use the python interpreter from the virtual environment
        ExecStart=/home/littlelight/CloudBot/.venv/bin/python3 -m cloudbot
        Restart=always
        RestartSec=10

        [Install]
        WantedBy=multi-user.target
    - require:
      - user: littlelight|user

littlelight|bot|service_running:
  service.running:
    - name: littlelight
    - enable: True
    - watch:
      - file: littlelight|bot|service
    - require:
      - file: littlelight|bot|service
      - pip: littlelight|pip|requirements

littlelight|bot|service_restarter:
  file.managed:
    - name: /etc/systemd/system/littlelight-restart.service
    - contents: |
        [Unit]
        Description=LittleLight auto-restart service.
        After=network.target
        [Service]
        Type=oneshot
        ExecStart=/usr/bin/systemctl restart littlelight.service
        [Install]
        WantedBy=multi-user.target

littlelight|bot|service_watcher:
  file.managed:
    - name: /etc/systemd/system/littlelight-restart.path
    - contents: |
        [Path]
        PathModified=/home/littlelight/CloudBot/plugins/
        PathModified=/home/littlelight/CloudBot/cloudbot/

        [Install]
        WantedBy=multi-user.target

littlelight|bot|service_watcher_running:
  service.running:
    - name: littlelight-restart.path
    - enable: True
    - require:
      - file: littlelight|bot|service_watcher
