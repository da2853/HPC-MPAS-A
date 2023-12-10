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

# Test different config_theta_adv_order values
theta_adv_orders=(2 3 4)
for order in "${theta_adv_orders[@]}"
do
    echo "Running simulation with config_theta_adv_order = $order"
    modify_namelist "config_theta_adv_order" $order
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.thetaadv$order.out
done
modify_namelist "config_theta_adv_order" 3 

# Test different config_radtsw_interval values
radtsw_intervals=('00:30:00' '01:00:00' '01:30:00')  # Example values
for interval in "${radtsw_intervals[@]}"
do
    echo "Running simulation with config_radtsw_interval = $interval"
    modify_namelist "config_radtsw_interval" $interval
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.radtsw$interval.out
done
modify_namelist "config_radtsw_interval" '01:00:00'  # Reset to default

# Test different config_h_mom_eddy_visc2 values
h_mom_eddy_visc2_values=(0.0 0.1 0.2)  # Example values
for value in "${h_mom_eddy_visc2_values[@]}"
do
    echo "Running simulation with config_h_mom_eddy_visc2 = $value"
    modify_namelist "config_h_mom_eddy_visc2" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.hmomvisc2$value.out
done
modify_namelist "config_h_mom_eddy_visc2" 0.0  # Reset to default

# Test different config_h_mom_eddy_visc4 values
h_mom_eddy_visc4_values=(0.0 0.1 0.2)  # Example values
for value in "${h_mom_eddy_visc4_values[@]}"
do
    echo "Running simulation with config_h_mom_eddy_visc4 = $value"
    modify_namelist "config_h_mom_eddy_visc4" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.hmomvisc4$value.out
done
modify_namelist "config_h_mom_eddy_visc4" 0.0  # Reset to default
