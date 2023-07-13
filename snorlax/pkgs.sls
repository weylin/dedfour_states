snorlax|install|pkgs:
  pkg.latest:
    - name:
      - git
      - python3-pip

snorlax|install|python310:
  pkg.latest:
    - name:
      - python3.10
    - onlyif: 'which python3.10 > /dev/null 2>&1 || exit 1'
