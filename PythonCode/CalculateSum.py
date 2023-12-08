import os

def sum_integration_times(directory_path):
    # Create a file to store the results
    results_file_path = os.path.join(directory_path, 'integration_times_summary.txt')
    with open(results_file_path, 'w') as results_file:
        # Iterate over each file in the directory
        for filename in os.listdir(directory_path):
            if filename.endswith('.txt') and filename != 'integration_times_summary.txt':
                full_file_path = os.path.join(directory_path, filename)
                total_time = 0.0

                # Read and process each file
                with open(full_file_path, 'r') as file:
                    for line in file:
                        if "Timing for integration step:" in line:
                            # Extract the time value and add it to the total
                            time_str = line.split(':')[1].strip().split(' ')[0]
                            total_time += float(time_str)

                # Write the results to the summary file
                results_file.write(f"{filename}: {total_time} s\n")

    return results_file_path

# I have multiple directories so I am iterating below.

# Define the base directory path
base_directory_path = 'C:\\Users\\Danyal\\Documents\\MPAS FIles\\Bench'

# Iterate through benches 1 to 4
for bench_number in range(5, 6):
    # Create the directory path for the current bench
    directory_path = f'{base_directory_path}{bench_number}'
    
    # Run the function and get the path to the results file
    results_file_path = sum_integration_times(directory_path)
    
    # Return the path for confirmation
    print(f'Results for Bench {bench_number}: {results_file_path}')



