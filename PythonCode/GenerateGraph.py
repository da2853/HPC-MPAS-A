import matplotlib.pyplot as plt
import numpy as np

# Data for the Positive Definite Advection graph
pos_def_advection_configs = ['False', 'True']
integration_times_pos_def = [1094.6534270249997, 1094.8197322829988]

# Creating the graph for Positive Definite Advection
plt.figure(figsize=(10, 6))
# Specify the width of the bars (adjust the value as needed)
bar_width = 0.4

# Calculate the x-coordinates for the bars
x = np.arange(len(pos_def_advection_configs))

plt.bar(x, integration_times_pos_def, color=['orange', 'cyan'], width=bar_width, align='edge')

# Set the x-axis tick positions and labels
plt.xticks(x, pos_def_advection_configs)

# Adding labels and title
plt.title('Effect of Positive Definite Advection on Simulation Results')
plt.xlabel('Positive Definite Advection Configurations')
plt.ylabel('Total Integration Time (s)')

# Show the graph
plt.grid(axis='y')
plt.show()
