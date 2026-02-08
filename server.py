from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS
import json, os, uuid
from datetime import datetime

app = Flask(__name__, static_folder='static')
CORS(app)

TASKS_FILE = os.path.join(os.path.dirname(__file__), 'tasks.json')

def load_tasks():
    with open(TASKS_FILE) as f:
        return json.load(f)

def save_tasks(data):
    with open(TASKS_FILE, 'w') as f:
        json.dump(data, f, indent=2)

@app.route('/')
def index():
    return send_from_directory('static', 'index.html')

@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    return jsonify(load_tasks())

@app.route('/api/tasks/active', methods=['GET'])
def get_active():
    data = load_tasks()
    active = [t for t in data['tasks'] if t['status'] == 'in_progress']
    return jsonify({'tasks': active})

@app.route('/api/tasks', methods=['POST'])
def create_task():
    data = load_tasks()
    task = request.json
    task['id'] = str(uuid.uuid4())[:8]
    now = datetime.now().isoformat(timespec='seconds')
    task.setdefault('created_at', now)
    task.setdefault('updated_at', now)
    task.setdefault('details', '')
    task.setdefault('sub_agent_id', None)
    data['tasks'].append(task)
    save_tasks(data)
    return jsonify(task), 201

@app.route('/api/tasks/<task_id>', methods=['PATCH'])
def update_task(task_id):
    data = load_tasks()
    for t in data['tasks']:
        if t['id'] == task_id:
            t.update(request.json)
            t['updated_at'] = datetime.now().isoformat(timespec='seconds')
            save_tasks(data)
            return jsonify(t)
    return jsonify({'error': 'not found'}), 404

@app.route('/api/tasks/<task_id>', methods=['DELETE'])
def delete_task(task_id):
    data = load_tasks()
    data['tasks'] = [t for t in data['tasks'] if t['id'] != task_id]
    save_tasks(data)
    return jsonify({'ok': True})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=False)
