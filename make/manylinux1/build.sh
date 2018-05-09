#!/bin/bash
set -e -x

# preserve dist
if [ -d dist ]; then mv dist tmpdist; fi

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/python" setup.py bdist_wheel
    rm -rf .eggs
done

# Bundle external shared libraries into the wheels
for whl in dist/*.whl; do
    auditwheel repair "$whl" -w tmpdist/
done

# restore dist
rm -rf dist && mv tmpdist dist

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    "${PYBIN}/pip" install -r requirements/test.txt
    "${PYBIN}/pip" install wolfssl_with_ed25519 --no-index -f dist
    rm -rf tests/__pycache__
    "${PYBIN}/py.test" tests
done
