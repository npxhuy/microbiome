head /proj/snic2022-6-377/Projects/Tconura/working/Rachel/popgen_Tconura/allpops.Tcon.txt
# P12002_144      CHES
# P12002_145      CHES
# P12002_146      CHES
# P12002_147      CHES
# P12002_148      CHES
# P12002_149      CHES

cut -f 1 /proj/snic2022-6-377/Projects/Tconura/working/Rachel/popgen_Tconura/allpops.Tcon.txt > id
# P12002_144
# P12002_145
# P12002_146
# P12002_147
# P12002_148
# P12002_149

# Link to folder for soft link
# /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata

# Final code
cat id.txt | while read folder; do main=$(echo $folder | cut -d \_ -f 1) ; mkdir $folder; cd $folder ; cat /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/$main/$folder.lst | while read dir; do ln -s /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/$main/$dir ; done ; cd ..; done
rm */*.md5

# Sub sampling
module load bioinfo-tools seqtk/1.2-r101; cat id.txt | while read folder; do cd $folder ; ls | while read $file; do seqtk sample -s100 $file 10000 > sub_$file
cat id.txt | while read folder; do cd $folder; ls | while read $file; do seqtk sample -s100 $file > ../subsampling/$folder/sub_$file ; done; cd .. ; done 

module load bioinfo-tools seqtk/1.2-r101; ls | while read folder; do cd $folder; ls | while read file; do seqtk sample -s100 $file 10000 > ../../subsampling/$folder/sub_$file ; done ; cd .. ; done





