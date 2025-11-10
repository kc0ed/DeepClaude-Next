@echo off
setlocal

REM --- Check if uv is installed ---
echo Checking for uv installation...
uv --version >nul 2>&1
if %errorlevel% neq 0 (
    echo uv is not found. Please install it first by running: pip install uv
    pause
    exit /b 1
)
echo uv is installed.

REM --- Create virtual environment if it doesn't exist ---
if not exist .venv (
    echo Virtual environment not found. Creating one...
    uv venv
    if %errorlevel% neq 0 (
        echo Failed to create virtual environment.
        pause
        exit /b 1
    )
    echo Virtual environment created successfully.
) else (
    echo Virtual environment already exists.
)

REM --- Install dependencies ---
echo Installing dependencies...
call .\.venv\Scripts\activate.bat
uv pip install .
if %errorlevel% neq 0 (
    echo Failed to install dependencies.
    pause
    exit /b 1
)
echo Dependencies installed successfully.

REM --- Start the application ---
echo Starting the application...
start "DeepClaude" /B uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

REM --- Wait a moment for the server to start ---
echo Waiting for the server to start...
timeout /t 5 /nobreak >nul

REM --- Open the browser ---
echo Opening the configuration page in your browser...
start http://localhost:8000/config

echo.
echo The application is running in the background.
echo You can access it at http://localhost:8000/config
echo To stop the server, please close the terminal window that was opened by the script.

endlocal
pause