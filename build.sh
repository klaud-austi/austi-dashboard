#!/bin/bash
# Build static dashboard with embedded tasks data
cd "$(dirname "$0")"
mkdir -p dist

# Read tasks JSON and inject into HTML from source
python3 -c "
import json, os
html = open('static/index.html').read()
tasks = json.dumps(json.load(open('tasks.json')))
inject = '<script>window.TASKS_DATA = ' + tasks + ';</script>'
html = html.replace('<body>', '<body>\n' + inject, 1)
open('dist/index.html', 'w').write(html)
print('Built with', len(json.loads(tasks)['tasks']), 'tasks embedded')
"
