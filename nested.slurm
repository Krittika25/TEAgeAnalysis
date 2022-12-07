#! /usr/bin/env bash
#SBATCH --partition=Draco
#SBATCH --nodes=1
#SBATCH --time=168:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem=50gb
#SBATCH --mail-type=end
#SBATCH --mail-user=kkrishn8@uncc.edu

module load anaconda3
module load repeatmodeler

source activate greedyte

nested-nester -d /nobackup/cooper_research/krittikak/nester_output/grassl /projects/cooper_research1/NAM_PacBio/grassl_assembly_liz/grassl.flye.scaffold.fasta

conda deactivate
