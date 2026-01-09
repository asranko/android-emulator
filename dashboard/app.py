from flask import Flask, render_template, request, jsonify
import subprocess
import os

app = Flask(__name__)
UPLOAD_FOLDER = '/tmp/uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def run_command(command):
      try:
                result = subprocess.run(command, shell=True, capture_output=True, text=True)
                return {'success': result.returncode == 0, 'output': result.stdout + result.stderr}
except Exception as e:
        return {'success': False, 'output': str(e)}

@app.route('/')
def index():
      return render_template('index.html')

@app.route('/api/install-essentials', methods=['POST'])
def install_essentials():
      return jsonify(run_command('bash scripts/install-essentials.sh'))

@app.route('/api/set-resolution', methods=['POST'])
def set_resolution():
      mode = request.json.get('mode', 'phone')
      return jsonify(run_command(f'bash scripts/set-resolution.sh {mode}'))

@app.route('/api/upload', methods=['POST'])
def upload_file():
      if 'file' not in request.files:
                return jsonify({'success': False, 'output': 'No file part'})
            file = request.files['file']
    if file.filename == '':
              return jsonify({'success': False, 'output': 'No selected file'})

    filepath = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(filepath)

    # Install APK
    result = run_command(f'adb install "{filepath}"')
    os.remove(filepath) # Clean up
    return jsonify(result)

if __name__ == '__main__':
      app.run(host='0.0.0.0', port=5000)
