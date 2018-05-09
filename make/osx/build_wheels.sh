set -e
set +x

for PYVERSION in 2.7 3.4 3.5 3.6; do
    virtualenv -p /Library/Frameworks/Python.framework/Versions/${PYVERSION}/bin/python${PYVERSION} venv_${PYVERSION}
    . ./venv_${PYVERSION}/bin/activate
    pip install -r requirements/setup.txt
    python setup.py bdist_wheel
    pip install -r requirements/test.txt
    set +e
    pip uninstall -y wolfssl
    set -e
    pip install wolfssl_with_ed25519 --no-index -f dist
    rm -rf tests/__pycache__
    py.test tests
    deactivate
done
