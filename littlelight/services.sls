littlelight|install_python34:
  pkg.installed:
    - name: python3.4
    - onlyif: 'which python3.4 > /dev/null 2>&1 || exit 1'
