#!/bin/bash
set -e

BASE_DIR="$(dirname "$0")"
$BASE_DIR/x509_pem_extractor.pl $@ | openssl x509 -noout -fingerprint -sha1
