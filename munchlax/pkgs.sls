munchlax|install|pkgs:
  pkg.installed:
    - name:
      - git
      - python3-pip

munchlax|install|python310:
  pkg.installed:
    - name:
      - python3.10
    - onlyif: 'which python3.10 > /dev/null 2>&1 || exit 1'
