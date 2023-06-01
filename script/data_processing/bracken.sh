#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 24:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J bracken
#SBATCH -o //proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/bracken.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/bracken.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/kraken_combined


#  Name of file: bracken.sh
#
#  Created by Huy on 2023-05-06.
#
#  Write bash script below

# Load conda and activate environment that bracken was installed
module load conda
source conda_init.sh
conda activate /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/env/microbiome

# 1. Loop through the combined report files
# 2. Sed the name of the file for naming the output
# 3. Run Bracken on the report file

# Parameter's explanation: 
# -d is database, same database when using to run Kraken
# -l is level, F stands for Family, S stands for Species
# -r is reading frame, since the multiqc report give the average length is from 100 to 150, we take 100
# -t is threshold, need at least 10 similar results to classify it as a family

# Family level
ls | while read report; do name=$(echo $report | sed 's/\.reports$//'); bracken -d /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ -i $report -l F -r 100 -t 10 -o ../bracken/$name.bracken ; done

# Species level
ls | while read report; do name=$(echo $report | sed 's/\.reports$//'); bracken -d /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ -i $report -l S -r 100 -t 10 -o ../bracken/$name.bracken ; done