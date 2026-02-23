# Vagrant development environment state
# Basic setup for development containers

# Install development tools
dev_packages:
  pkg.installed:
    - pkgs:
      - vim
      - curl
      - wget
      - git
      - htop
      - net-tools
      - telnet

# Create development directories
dev_directories:
  file.directory:
    - names:
      - /opt/dev
      - /var/log/dev
    - mode: 755
    - makedirs: true

# Development user configuration
{% if grains['roles'] and 'vagrant' in grains['roles'] %}
vagrant_user_config:
  user.present:
    - name: vagrant
    - shell: /bin/bash
    - groups:
      - sudo
      - docker
    - require:
      - pkg: dev_packages
{% endif %}

# Debug logging setup
debug_logging:
  file.managed:
    - name: /etc/rsyslog.d/99-debug.conf
    - content: |
        # Debug logging for development
        *.debug /var/log/dev/debug.log
    - require:
      - file: dev_directories

# Restart rsyslog to apply debug config
restart_rsyslog:
  service.running:
    - name: rsyslog
    - watch:
      - file: debug_logging
