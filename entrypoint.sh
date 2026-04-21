#!/bin/sh
set -e
node frontend-server.js &
node backend-server.js
