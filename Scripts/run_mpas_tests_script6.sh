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

# Test different config_positive_definite values
for positive_definite in true false; do
    echo "Running simulation with config_positive_definite = $positive_definite"
    modify_namelist "config_positive_definite" $positive_definite
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.posdef$positive_definite.out
done
modify_namelist "config_positive_definite" false  # Reset to default

# Test different config_theta_vadv_order values
advection_orders=(1 2 3 4 5 6 7 8 9 10)
for order in "${advection_orders[@]}"
do
    echo "Running simulation with config_theta_vadv_order = $order"
    modify_namelist "config_theta_vadv_order" $order
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.thetaadv$order.out
done
modify_namelist "config_theta_vadv_order" 3  # Reset to default

# Test different config_w_vadv_order values
for order in "${advection_orders[@]}"
do
    echo "Running simulation with config_w_vadv_order = $order"
    modify_namelist "config_w_vadv_order" $order
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.wadv$order.out
done
modify_namelist "config_w_vadv_order" 3  # Reset to default

# Test different config_u_vadv_order values
for order in "${advection_orders[@]}"
do
    echo "Running simulation with config_u_vadv_order = $order"
    modify_namelist "config_u_vadv_order" $order
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.uadv$order.out
done
modify_namelist "config_u_vadv_order" 3  # Reset to default
