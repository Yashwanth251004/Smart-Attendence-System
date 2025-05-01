@echo off
echo Smart Attendance System - Complete Setup and Execution
echo ====================================================

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges...
) else (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

REM Check if Python is installed
where python >nul 2>&1
if %errorLevel% neq 0 (
    echo Python is not installed or not in PATH.
    echo Please install Python from https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Create necessary directories
echo Creating required directories...
if not exist "face_data" mkdir face_data
if not exist "certificates" mkdir certificates
if not exist "screenshots" mkdir screenshots

REM Install required packages
echo Installing required packages...
pip install -r requirements.txt

REM Generate SSL certificates
echo Generating SSL certificates...
python generate_certificates.py

REM Check if port 8080 is available
echo Checking port availability...
netstat -ano | findstr :8080 >nul
if %errorLevel% == 0 (
    echo Port 8080 is already in use.
    echo Please close any applications using port 8080.
    pause
    exit /b 1
)

REM Configure firewall
echo Configuring firewall...
call configure_firewall.bat

REM Start the application
echo Starting Smart Attendance System...
echo.
echo The application will be available at:
echo - http://localhost:8080
echo - http://127.0.0.1:8080
echo.
echo Default login credentials:
echo Username: admin
echo Password: admin
echo.
echo Press Ctrl+C to stop the application
echo.

REM Run the application
python run_web_app.py

if %errorLevel% neq 0 (
    echo Failed to start the application.
    echo Please check the error messages above.
    pause
) 