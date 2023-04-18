salt-master-package:
  pkg.installed:
    - name: salt-master

salt-minion-package:
  pkg.installed:
    - name: salt-minion

salt-master-service:
  service.running:
    - name: salt-master
    - enable: True
    - require:
      - pkg: salt-master-package

salt-minion-service:
  service.running:
    - name: salt-minion
    - enable: True
    - require:
      - pkg: salt-minion-package
