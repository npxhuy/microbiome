#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 48:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J kraken_combine
#SBATCH -o //proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/kraken_combine.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/kraken_combine.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/kraken


#  Name of file: kraken_combined.sh
#
#  Created by Huy on 2023-05-04.
#
#  Write bash script below

ls| while read folder; do cd $folder; reports=$(ls *report | tr '\n' ' '); python ../../tools/KrakenTools/combine_kreports.py -r $reports --only-combined -o ../../kraken_combined/$folder.reports; cd .. ; done
