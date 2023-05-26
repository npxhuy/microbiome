#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 00:10:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J alpha_shannon
#SBATCH -o /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/alpha_inverse_simpson.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/alpha_inverse_simpson.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/bracken_filtered


#  Name of file: alpha_inverse_simpson.sh
#
#  Created by Huy on 2023-05-08.
#
#  Write bash script below

ls | while read file; do name=$(echo $file | cut -d . -f 1); result=$(python ../tools/KrakenTools/DiversityTools/alpha_diversity.py -f $file -a ISi | cut -d : -f 2); echo $name $result; done > ../diversity_result/inverse_simpson_alpha.txt
