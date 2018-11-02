#!/bin/bash
#SBATCH -q regular
#SBATCH -A nstaff
#SBATCH -t 02:00:00
#SBATCH -C knl
#SBATCH -S 2

#load modules
#module load espresso
#execdir=../install/6.3/knl/bin

#some parameters
rankspernode=8
totalranks=$(( ${rankspernode} * ${SLURM_NNODES} ))

#openmp stuff
export OMP_NUM_THREADS=$(( 64 / ${rankspernode} ))
export OMP_PLACES=threads
export OMP_PROC_BIND=spread
export MKL_FAST_MEMORY_LIMIT=0

#executable
execdir=../buildscripts/install/6.3/knl/bin

#run
MPI_RUN="srun -N ${SLURM_NNODES} -n ${totalranks} -c $(( 256 / ${rankspernode} )) --cpu_bind=cores"
${MPI_RUN} ${execdir}/pw.x -nbgrp ${totalranks} -in small.in 
