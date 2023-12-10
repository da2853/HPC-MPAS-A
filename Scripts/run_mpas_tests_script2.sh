#!/bin/bash

#SBATCH --job-name=mpas-atmosphere
#SBATCH --nodes=4
#SBATCH --tasks-per-node=32
#SBATCH --mem=180GB
#SBATCH --time=12:00:00
#SBATCH --output=mpas_run_%j.out

# Path to the namelist file
NAMELIST=namelist.atmosphere
chmod 755 /scratch/da2853/mpas-a-benchmark/MPAS-A_benchmark_60km_v7.0/atmosphere_model
source ~/mpas-env.sh
# Function to modify the namelist file
modify_namelist() {
    local parameter=$1
    local value=$2
    sed -i "s/^    $parameter = .*/    $parameter = $value/" $NAMELIST
}

# Test different config_time_integration_order values
time_integration_orders=(1 2 3)
for order in "${time_integration_orders[@]}"
do
    echo "Running simulation with config_time_integration_order = $order"
    modify_namelist "config_time_integration_order" $order
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.order$order.out
done
modify_namelist "config_time_integration_order" 2  # Reset to default

# Test different config_horiz_mixing values
horiz_mixings=('2d_smagorinsky' 'another_scheme')  # Replace with actual schemes
for mixing in "${horiz_mixings[@]}"
do
    echo "Running simulation with config_horiz_mixing = $mixing"
    modify_namelist "config_horiz_mixing" $mixing
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.mixing$mixing.out
done
modify_namelist "config_horiz_mixing" '2d_smagorinsky'  # Reset to default

# Test different config_w_adv_order values
w_adv_orders=(2 3 4)
for order in "${w_adv_orders[@]}"
do
    echo "Running simulation with config_w_adv_order = $order"
    modify_namelist "config_w_adv_order" $order
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.wadv$order.out
done
modify_namelist "config_w_adv_order" 3  # Reset to default
