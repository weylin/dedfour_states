{%from 'banner_macro.jinja' import banner %}

bridge|config|file:
  file.managed:
    - name: /home/bridge/bot/config.json
    - user: bridge
    - group: bridge
    - mode: 600
    - defaults:
        banner: {{ banner() }}
    - contents_pillar: discord-irc_bridge_config
    - gpg_decrypted: True

bridge|bot|service:
  file.managed:
    - name: /etc/systemd/system/bridge.service
    - contents: |
        [Unit]
        Description=bridge (discord <> irc bridge)

        [Service]
        User=bridge
        WorkingDirectory=/home/bridge/bot
        ExecStart=/usr/local/bin/discord-irc --config /home/bridge/bot/config.json
        Restart=always
        RuntimeMaxSec=86400

        [Install]
        WantedBy=multi-user.target
    - require:
      - file: bridge|config|file

bridge|bot|service_running:
  service.running:
    - name: bridge
    - enable: True
    - require:
      - file: bridge|bot|service
      - pkg: bridge|pkg|install

bridge|pkg|install:
  pkg.latest:
    - pkgs:
      - nodejs
      - npm

bridge|npm|install:
  cmd.run:
    - name: npm install -g discord-irc
    - unless: npm list -g discord-irc
    - runas: root
    - require:
      - pkg: bridge|pkg|install

