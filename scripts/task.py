import datetime
import platform
import os
import shutil

artifact_filename = 'artifact-latest.txt'

# Get the current date and time, and the operating system information
current_datetime = datetime.datetime.now()
os_info = platform.platform()

# Check if a previous artifact file exists
if os.path.exists(artifact_filename):
    # Read the content of the previous artifact file
    with open(artifact_filename, 'r') as f:
        content = f.read()
    
    # Extract the date from the content
    date_str = content.split('Current date and time: ')[1].split('\n')[0]
    date_obj = datetime.datetime.strptime(date_str, '%Y-%m-%d %H:%M:%S.%f')
    
    # Rename the previous artifact file with the date
    new_filename = f'artifact-{date_obj.strftime("%Y-%m-%d-%H-%M-%S")}.txt'
    shutil.move(artifact_filename, new_filename)
    
    print(f'Previous artifact file renamed to: {new_filename}')

# Write the information to the artifact file
with open(artifact_filename, 'w') as f:
    f.write(f'Current date and time: {current_datetime}\n')
    f.write(f'Operating system: {os_info}\n')

# Print the information to the console
print(f'Current date and time: {current_datetime}')
print(f'Operating system: {os_info}')
print(f'Artifact created: {os.path.abspath(artifact_filename)}')