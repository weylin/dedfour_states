minion|pkgs:
  pkg.installed:
    - pkgs:
      - salt-minion

minion|service:
  service.running:
    - name: salt-minion
    - enable: True
