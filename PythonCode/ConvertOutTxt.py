import os

def rename_files_in_directory(directory_path):
    for filename in os.listdir(directory_path):
        # Construct the full file path
        full_file_path = os.path.join(directory_path, filename)

        # Check if the file is a regular file and not a directory
        if os.path.isfile(full_file_path):
            # Rename the file
            if filename.endswith('out'):
                new_filename = filename[:-3] + 'txt'
            else:
                new_filename = filename + '.txt'
            
            # Construct the full new file path
            new_full_file_path = os.path.join(directory_path, new_filename)

            # Rename the file
            os.rename(full_file_path, new_full_file_path)
            print(f"Renamed '{filename}' to '{new_filename}'")


# directory_path = 'C:\\Users\\Danyal\\Documents\\MPAS FIles\\Bench4'
# rename_files_in_directory(directory_path)

# I have multiple directories so I am iterating below.

# Define the base directory path
base_directory_path = 'C:\\Users\\Danyal\\Documents\\MPAS FIles\\Bench'

# Specify the bench number for which you want to rename files (e.g., Bench 4)

for i in range(5, 6):
    # Create the directory path for the specified bench
    directory_path = f'{base_directory_path}{i}'

    # Run the function to rename files in the directory
    rename_files_in_directory(directory_path)