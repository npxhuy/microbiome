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

module load conda
source conda_init.sh
conda activate /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/env/microbiome

ls | while read report; do name=$(echo $report | sed 's/\.reports$//'); bracken -d /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ -i $report -l S -r 100 -t 10 -o ../bracken/$name.bracken ; done
