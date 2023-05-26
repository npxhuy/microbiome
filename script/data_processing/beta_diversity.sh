#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 07:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J beta_diversity
#SBATCH -o /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/beta_diversity.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/beta_diversity.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/bracken_filtered


#  Name of file: beta_diversity.sh
#
#  Created by Huy on 2023-05-08.
#
#  Write bash script below

cat ../combination.txt | while read pair; do result=$(python ../tools/KrakenTools/DiversityTools/beta_diversity.py -i $pair --type bracken); echo $result; done >> ../diversity_result/beta.txt
