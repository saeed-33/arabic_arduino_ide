$ErrorActionPreference = "Stop"

python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt

Write-Host "ArduinoArabicCompiler Python environment is ready."
