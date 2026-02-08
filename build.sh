#!/bin/bash
# Build static dashboard with embedded tasks data
cd "$(dirname "$0")"
mkdir -p dist

# Copy the source HTML
cp dist/index.html dist/index.html.base 2>/dev/null

# Read tasks JSON
TASKS_JSON=$(python3 -c "import json; print(json.dumps(json.load(open('tasks.json'))))")

# Inject tasks data into the HTML right after <body>
python3 -c "
import sys
html = open('dist/index.html.base' if __import__('os').path.exists('dist/index.html.base') else 'dist/index.html').read()
tasks = '''$TASKS_JSON'''
inject = '<script>window.TASKS_DATA = ' + tasks + ';</script>'
html = html.replace('<body>', '<body>\n' + inject, 1)
open('dist/index.html', 'w').write(html)
print('Built with tasks data embedded')
"
