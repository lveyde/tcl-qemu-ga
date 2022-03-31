#!/bin/bash

set -eao pipefail

if [ ! -f "dist/tinycore.qcow2" ]; then
  echo -e  "\033[0;31mPlease run packer build . first\033[0m" >&2
  exit 1
fi

if [ "$(which gocr | wc -l)" -ne 1 ]; then
  echo -e  "\033[0;31mPlease install gocr to run this test.\033[0m" >&2
  exit 1
fi

if [ "$(which qemu-system-x86_64 | wc -l)" -ne 1 ]; then
  echo -e "\033[0;31mPlease install qemu to run this test.\033[0m" >&2
  exit 1
fi

if [ "$(which nc | wc -l)" -ne 1 ]; then
  echo -e "\033[0;31mPlease install netcat to run this test.\033[0m" >&2
  exit 1
fi

if [ "$(which convert | wc -l)" -ne 1 ]; then
  echo -e "\033[0;31mPlease install imagemagick to run this test.\033[0m" >&2
  exit 1
fi


function group {
  if [ -n "${GITHUB_ACTIONS}" ]; then
    echo -n "::group::"
  fi
  echo -e $1
}

function endgroup {
  if [ -n "${GITHUB_ACTIONS}" ]; then
    echo "::endgroup::"
  fi
}

function log {
  echo -e "\033[0;33m$*\033[0m"
}

function error {
  echo -e "\033[0;31m$*\033[0m"
}

function success {
  MSG=$1
  echo -e "\033[0;32m${MSG}\033[0m"
}



log "⚙️ Starting VM with image..."

(
  qemu-system-x86_64 \
    -nographic \
    -serial mon:stdio \
    -drive file=$(pwd)/dist/tinycore.qcow2,format=qcow2 \
    -monitor telnet::2000,server,nowait >/tmp/qemu.log
) &

sleep 30
echo 'screendump /tmp/screendump.ppm
quit' | nc localhost 2000 >/dev/null
sleep 1
echo -e "\033[2m"
cat /tmp/qemu.log
echo -e "\033[0m"
convert /tmp/screendump.ppm tinycore.png

log "⚙️ Performing OCR and evaluating results..."
if [ $(gocr -m 4 /tmp/screendump.ppm 2>/dev/null | grep 'tinycorelinux.net' | wc -l) -ne 1 ]; then
  error "❌ Test failed: the virtual machine did not print \"tinycorelinux.net\" to the output when run."
  exit 1
fi

success "✅ Test successful."