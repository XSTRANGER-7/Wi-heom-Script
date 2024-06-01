import subprocess
import sys
import os
import cv2
import time
from datetime import datetime

def install(package):
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", package])
    except Exception as e:
        print(f"Failed to install {package}: {e}")

def check_opencv():
    try:
        import cv2
    except ImportError:
        print("OpenCV is not installed. Installing OpenCV...")
        install("opencv-python")

def check_pip():
    try:
        import pip
    except ImportError:
        print("Pip is not installed. Installing pip...")
        try:
            subprocess.check_call([sys.executable, "-m", "ensurepip", "--default-pip"])
        except Exception as e:
            print(f"Failed to install pip: {e}")

def generate_folder_name(base_path):
    now = datetime.now()
    return os.path.join(base_path, now.strftime("photos_%Y%m%d_%H%M%S"))

def detect_usb_drive():
    command_output = subprocess.getoutput("wmic logicaldisk get deviceid, drivetype")
    for line in command_output.splitlines():
        parts = line.strip().split()
        if len(parts) == 2 and parts[1] == '2': 
            usb_drive = parts[0]
            return usb_drive
    return None

def main():
    check_pip()
    check_opencv()

    required_packages = ['opencv-python']
    for package in required_packages:
        print(f"Installing {package}...")
        install(package)

    usb_base_folder = detect_usb_drive()
    if usb_base_folder is None:
        print("No USB drive detected. Exiting...")
        sys.exit(1)

    usb_base_folder += "\\"  
    local_base_folder = "C:\\"
    output_folder = generate_folder_name(usb_base_folder)

    if not os.path.exists(output_folder):
        os.makedirs(output_folder, exist_ok=True)

    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        print("Failed to open the webcam. Exiting...")
        sys.exit(1)

    count = 0
    try:
        while True:
            if not os.path.exists(output_folder):
                print("USB drive removed. Switching to local storage...")
                output_folder = generate_folder_name(local_base_folder)
                os.makedirs(output_folder, exist_ok=True)

            ret, frame = cap.read()
            if ret:
                filename = os.path.join(output_folder, f"photo_{count}.jpg")
                cv2.imwrite(filename, frame)
                print(f"Image captured and saved: {filename}")
                count += 1
            else:
                print("Failed to capture image.")
            time.sleep(1)
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        cap.release()
        print("Exiting...")

if __name__ == "__main__":
    main()
