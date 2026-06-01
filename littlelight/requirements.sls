# Install Python and system dependencies for CloudBot
littlelight|python|deps:
  pkg.installed:
    - pkgs:
      - python3
      - python3-pip
      - python3-dev
      - python3-venv
      - python3-virtualenv
      - git
      - libenchant-2-2
      - libenchant-2-dev
      - libxml2-dev
      - libxslt1-dev
      - zlib1g-dev

littlelight|venv|create:
  virtualenv.managed:
    - name: /home/littlelight/CloudBot/.venv
    - user: littlelight
    - venv_module: venv
    - require:
      - pkg: littlelight|python|deps
      - file: littlelight|directory

littlelight|pip|requirements:
  pip.installed:
    - requirements: /home/littlelight/CloudBot/requirements.txt
    - bin_env: /home/littlelight/CloudBot/.venv
    - user: littlelight
    - require:
      - virtualenv: littlelight|venv|create
