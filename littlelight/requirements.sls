# Install Python dependencies for CloudBot
littlelight|python|deps:
  pkg.installed:
    - pkgs:
      - python3
      - python3-pip
      - python3-dev
      - git

# Install CloudBot requirements individually with version pinning
littlelight|pip|sqlalchemy:
  pip.installed:
    - name: sqlalchemy<2.0.0
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|nltk:
  pip.installed:
    - name: nltk
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|geoip2:
  pip.installed:
    - name: geoip2
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|mcstatus:
  pip.installed:
    - name: git+https://github.com/CloudBotIRC/mcstatus.git@master
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|cleverwrap:
  pip.installed:
    - name: cleverwrap
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|future:
  pip.installed:
    - name: future
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|microdata:
  pip.installed:
    - name: microdata
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|watchdog:
  pip.installed:
    - name: watchdog
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|lxml:
  pip.installed:
    - name: lxml
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|beautifulsoup4:
  pip.installed:
    - name: beautifulsoup4
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|feedparser:
  pip.installed:
    - name: feedparser
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|requests:
  pip.installed:
    - name: requests
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|psutil:
  pip.installed:
    - name: psutil
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|requests_oauthlib:
  pip.installed:
    - name: requests-oauthlib
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|tweepy:
  pip.installed:
    - name: tweepy
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|pyenchant:
  pip.installed:
    - name: pyenchant
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|pythonwhois:
  pip.installed:
    - name: pythonwhois
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|imgurpython:
  pip.installed:
    - name: imgurpython
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|isodate:
  pip.installed:
    - name: isodate
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps

littlelight|pip|yarl:
  pip.installed:
    - name: yarl
    - user: littlelight
    - require:
      - pkg: littlelight|python|deps
