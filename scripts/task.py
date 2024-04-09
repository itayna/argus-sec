import datetime
import platform
import os
import requests

artifact_filename = 'artifact.txt'

# Get the current date and time, and the operating system information
current_datetime = datetime.datetime.now()
os_info = platform.platform()

# Write the information to the artifact file
with open(artifact_filename, 'w') as f:
    f.write(f'Current date and time: {current_datetime}\n')
    f.write(f'Operating system: {os_info}\n')

# Print the information to the console
print(f'Current date and time: {current_datetime}')
print(f'Operating system: {os_info}')
print(f'Artifact created: {os.path.abspath(artifact_filename)}')