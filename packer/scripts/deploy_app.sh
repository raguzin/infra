#!/bin/bash
set -e

# deploy reddit
cd /home/appuser
git clone -b monolith https://github.com/express42/reddit.git
cd /home/appuser/reddit && bundle install
