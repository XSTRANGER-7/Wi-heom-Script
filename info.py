import os
import shutil
import subprocess
import string

def get_host_info():
    # Get basic host information
    host_info = {}
    host_info['Hostname'] = os.getenv('COMPUTERNAME')
    host_info['Username'] = os.getenv('USERNAME')
    host_info['OS'] = os.getenv('OS')

    return host_info

def get_network_info():
    # Get network information
    network_info = {}
    ipconfig_output = subprocess.check_output(['ipconfig', '/all']).decode('utf-8')
    network_info['IPConfig'] = ipconfig_output

    return network_info

def get_pendrive_path():
    # Get the path to the pendrive
    for letter in string.ascii_uppercase:
        drive_path = letter + ':\\'
        if os.path.exists(drive_path):
            # Check if the drive is a removable drive
            drive_type = subprocess.check_output(['fsutil', 'fsinfo', 'drivetype', drive_path]).decode('utf-8')
            if 'Removable Drive' in drive_type:
                return drive_path
    return None

def save_to_pendrive(data, pendrive_path):
    try:
        # Check if host_info.txt already exists
        filename = 'info.py'
        file_count = 1
        while os.path.exists(os.path.join(pendrive_path, filename)):
            filename = f'info_{file_count}.txt'
            file_count += 1

        # Save data to the new filename
        with open(os.path.join(pendrive_path, filename), 'w') as file:
            for key, value in data.items():
                file.write(f"{key}: {value}\n")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    # Get host and network information
    host_info = get_host_info()
    network_info = get_network_info()

    # Combine host and network information
    combined_info = {**host_info, **network_info}

    # Get pendrive path
    pendrive_path = get_pendrive_path()

    if pendrive_path:
        # Save information to pendrive
        save_to_pendrive(combined_info, pendrive_path)
        print("Information saved to pendrive.")
    else:
        print("Pendrive not found.")
