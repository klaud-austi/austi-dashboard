#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p dist

# Build: embed tasks.json into HTML as window.TASKS_DATA
python3 -c "
import json
with open('tasks.json') as f:
    data = f.read().strip()
with open('static/index.html') as f:
    html = f.read()
tag = '<script>window.TASKS_DATA = ' + data + ';</script>\n'
html = html.replace('<script>', tag + '<script>', 1)
with open('dist/index.html', 'w') as f:
    f.write(html)
"

echo "Built dist/index.html"
