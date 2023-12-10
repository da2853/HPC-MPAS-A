#!/bin/bash

#SBATCH --job-name=mpas-atmosphere
#SBATCH --nodes=4
#SBATCH --tasks-per-node=32
#SBATCH --mem=180GB
#SBATCH --time=12:00:00
#SBATCH --output=mpas_run_%j.out

# Path to the namelist file
NAMELIST=namelist.atmosphere
chmod 755 /scratch/da2853/mpas-a-benchmark/MPAS-Bench3/atmosphere_model
source ~/mpas-env.sh
# Function to modify the namelist file
modify_namelist() {
    local parameter=$1
    local value=$2
    sed -i "s/^    $parameter = .*/    $parameter = $value/" $NAMELIST
}

# (Existing test loops for previously tested parameters)

# Test different config_pio_num_iotasks values
pio_num_iotasks_values=(0 1 2 4)  # Example values
for value in "${pio_num_iotasks_values[@]}"
do
    echo "Running simulation with config_pio_num_iotasks = $value"
    modify_namelist "config_pio_num_iotasks" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.pionumiotasks$value.out
done
modify_namelist "config_pio_num_iotasks" 0  # Reset to default

# Test different config_pio_stride values
pio_stride_values=(1 2 4 8)  # Example values
for value in "${pio_stride_values[@]}"
do
    echo "Running simulation with config_pio_stride = $value"
    modify_namelist "config_pio_stride" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.piostride$value.out
done
modify_namelist "config_pio_stride" 1  # Reset to default

# Test different config_block_decomp_file_prefix values
# Assuming specific file prefixes are available, replace with actual file prefixes
block_decomp_file_prefix_values=('prefix1' 'prefix2')  
for value in "${block_decomp_file_prefix_values[@]}"
do
    echo "Running simulation with config_block_decomp_file_prefix = $value"
    modify_namelist "config_block_decomp_file_prefix" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.blockdecomp$value.out
done
modify_namelist "config_block_decomp_file_prefix" 'x1.163842.graph.info.part.'  # Reset to default

# Test different config_apply_lbcs values
apply_lbcs_values=(false true)
for value in "${apply_lbcs_values[@]}"
do
    echo "Running simulation with config_apply_lbcs = $value"
    modify_namelist "config_apply_lbcs" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.applylbcs$value.out
done
modify_namelist "config_apply_lbcs" false  # Reset to default