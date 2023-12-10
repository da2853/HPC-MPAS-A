#!/bin/bash

#SBATCH --job-name=mpas-atmosphere
#SBATCH --nodes=4
#SBATCH --tasks-per-node=32
#SBATCH --mem=180GB
#SBATCH --time=12:00:00
#SBATCH --output=mpas_run_%j.out

# Path to the namelist file
NAMELIST=namelist.atmosphere
chmod 755 /scratch/da2853/mpas-a-benchmark/MPAS-Bench4/atmosphere_model
source ~/mpas-env.sh

# Function to modify the namelist file
modify_namelist() {
    local parameter=$1
    local value=$2
    sed -i "s/^    $parameter = .*/    $parameter = $value/" $NAMELIST
}

# Test different config_shapiro_filter_timescale values
shapiro_filter_timescales=(10800 21600 43200)  # 3, 6, and 12 hours
for timescale in "${shapiro_filter_timescales[@]}"
do
    echo "Running simulation with config_shapiro_filter_timescale = $timescale"
    modify_namelist "config_shapiro_filter_timescale" $timescale
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.shapiro$timescale.out
done

modify_namelist "config_shapiro_filter_timescale" 21600

# Test different config_num_halos values
num_halos_values=(1 2 3 4 5)
for num_halos in "${num_halos_values[@]}"
do
    echo "Running simulation with config_num_halos = $num_halos"
    modify_namelist "config_num_halos" $num_halos
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.numhalos$num_halos.out
done

modify_namelist "config_num_halos" 2

# Test config_use_adaptive_time_stepping enabled/disabled
for adaptive_stepping in true false; do
    echo "Running simulation with config_use_adaptive_time_stepping = $adaptive_stepping"
    modify_namelist "config_use_adaptive_time_stepping" $adaptive_stepping
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.adaptivestepping$adaptive_stepping.out
done

modify_namelist "config_use_adaptive_time_stepping" false

# Test different config_rain_evaporation values
rain_evaporation_values=(0.5 1.0 1.5 2.0 2.5 3.0)  # Example values
for evaporation in "${rain_evaporation_values[@]}"
do
    echo "Running simulation with config_rain_evaporation = $evaporation"
    modify_namelist "config_rain_evaporation" $evaporation
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.rainevap$evaporation.out
done

modify_namelist "config_rain_evaporation" 1.0

# Test different config_cloud_water_autoconversion values
cloud_water_autoconversion_values=(0.001 0.002 0.003 0.004 0.005)  # Example values
for autoconversion in "${cloud_water_autoconversion_values[@]}"
do
    echo "Running simulation with config_cloud_water_autoconversion = $autoconversion"
    modify_namelist "config_cloud_water_autoconversion" $autoconversion
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.cloudwaterauto$autoconversion.out
done

modify_namelist "config_cloud_water_autoconversion" 0.002

# Test different config_cloud_ice_autoconversion values
cloud_ice_autoconversion_values=(0.001 0.002 0.003 0.004 0.005)  # Example values
for ice_autoconversion in "${cloud_ice_autoconversion_values[@]}"
do
    echo "Running simulation with config_cloud_ice_autoconversion = $ice_autoconversion"
    modify_namelist "config_cloud_ice_autoconversion" $ice_autoconversion
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.cloudiceauto$ice_autoconversion.out
done

# Reset to default values
modify_namelist "config_shapiro_filter_timescale" 21600
modify_namelist "config_num_halos" 2
modify_namelist "config_use_adaptive_time_stepping" false
modify_namelist "config_rain_evaporation" 1.0
modify_namelist "config_cloud_water_autoconversion" 0.002
modify_namelist "config_cloud_ice_autoconversion" 0.002

# Add additional configuration and reset steps as needed.
