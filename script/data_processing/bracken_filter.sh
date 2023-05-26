#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 1:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J bracken_filtered
#SBATCH -o //proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/bracken_filtered.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/bracken_filtered.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/bracken


#  Name of file: bracken_filtered.sh
#
#  Created by Huy on 2023-05-06.
#
#  Write bash script below

ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../bracken_filtered/$name.bracken_filtered --exclude 9606 ; done
