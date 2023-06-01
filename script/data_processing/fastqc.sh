#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 24:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J fastqc
#SBATCH -o /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/fastqc.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/fastqc.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/trimm


#  Name of file: fastqc.sh
#
#  Created by Huy on 2023-04-29.
#
#  Write bash script below

# Load module on UPPMAX
module load bioinfo-tools FastQC/0.11.9

# 1. Ls of folder and cd in each folder
# 2. Fastqc for every file, -o flag for output directory
ls | while read folder; do cd $folder; ls | while read file; do fastqc -t 2 -o ../../fastqc/$folder $file ; done;  cd ..; done
