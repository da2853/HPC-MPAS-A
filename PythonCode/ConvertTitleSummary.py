import os

def convert_file_titles_in_summary(directory_path, summary_file_name):
    # Read the existing summary file
    summary_file_path = os.path.join(directory_path, summary_file_name)
    with open(summary_file_path, 'r') as file:
        lines = file.readlines()

    # Process each line to modify the file title
    converted_lines = []
    for line in lines:
        # Splitting the line into filename and time
        filename, time = line.split(':')
        # Removing 'atmosphere.' and everything before it, and '.txt' from the end
        descriptive_part = filename.split('atmosphere.')[-1].replace('.txt', '')
        # Constructing the new line format
        new_line = f"{descriptive_part}: {time}"
        converted_lines.append(new_line)

    # Write the converted lines to a new file
    converted_file_path = os.path.join(directory_path, 'converted_' + summary_file_name)
    with open(converted_file_path, 'w') as file:
        file.writelines(converted_lines)

    return converted_file_path

directory_path = "C:\\Users\\Danyal\\Documents\\MPAS FIles\\Bench5"
summary_file_name = 'integration_times_summary.txt' 

# Convert the file titles in the summary file
converted_summary_file_path = convert_file_titles_in_summary(directory_path, 'integration_times_summary.txt')

converted_summary_file_path

