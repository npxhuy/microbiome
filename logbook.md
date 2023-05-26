# Project log book
Working directory in **uppmax**
>  /proj/snic2022-6-377/Projects/Tconura/working/Huy/test
## **3rd Apr 2023**
Requesting for being a member of project on SURP\
Creating UPPMAX account

## **5th Apr 2023**
Meeting with Rachel for Uppmax tutorial and giving initial tasks for project:
1. Find and download Wolbacchia and Stammerula reference genomes on NCBI to your working directory
2. Write up a list of the different bacterial reference genomes you found and plan to use and send it to me
3. Start working through the initial parts of the workflow from Anne Duplouy

## **10th Apr 2023**
Following Anna Doplouy tutorial for *Screening host genomic project for Wolbachia infections*\
The tutorial can be find [here](https://zenodo.org/record/7799140#.ZC1hrBVByUt)\
Working directory in **uppmax**
>  /proj/snic2022-6-377/Projects/Tconura/working/Huy

There is no result for Stammerula when I searched in this [NCBI genome data hub](https://www.ncbi.nlm.nih.gov/data-hub/genome), thus I went [here](https://www.ncbi.nlm.nih.gov/nuccore) and search for *Stammerula*.\
There are 20 complete sequences from the search. Select the sequence by checking the check box -> go to the bottom of the page -> *Send to* -> Use the following settings: Complete Record, Destination: File, Format: FASTA -> CLick *Creat File*
We will obtain this file called *sequence.fasta* contains the accession ID of the complete sequence


```bash
## Wolbachia
# Copy the genome file to working directory 
scp ncbi_dataset.zip npxhuy@rackham.uppmax.uu.se:/proj/snic2022-6-377/Projects/Tconura/working/Huy

# Extracting zip file
mkdir wolbachia_gene
unzip ncbi_dataset.zip -d wolbachia_gene/

# Copy reference genome to a folder
mkdir ref_gene
for ref in ncbi_dataset/data/*/*.fna; do cp "$ref" ref_gene/; done

## Stammerula
# Copy to the working directory
scp sequence.fasta npxhuy@rackham.uppmax.uu.se:/proj/snic2022-6-377/Projects/Tconura/working/Huy

mkdir stammerula_gene
mv sequence.fasta stammerula_gene/sequence.fasta

# Seperate multi fasta to single fasta file
# Source: https://gist.github.com/astatham/621901
cat sequence.fasta | awk '{
        if (substr($0, 1, 1)==">") {filename=(substr($1,2) ".fasta")}
        print $0 >> filename
        close(filename)
}'
mkdir ref_gene
cp *.fasta ref_gene

#
conda install -c "bioconda/label/cf201901" sra-tools #This version is 2.9.1
mkdir sra_download
prefetch -O sra_download/ SRR4341246 # Currently having error running this but maybe is the different in version of sra-tools
#Trying version 3.0.0 as the paper mentioned but still encouter error
```

## **11th Apr 2023**
Trying to fix the error with sra-tools. Should not use the packages install through conda. Do not know why it did not have the latest version (3.0.2) but only 2.9.0.\
Run it by downloading directly from [github](https://github.com/ncbi/sra-tools/wiki/02.-Installing-SRA-Toolkit), it worked!
```bash
mkdir sra_download
mkdir sra_fastq
mkdir tmp
# Run prefetch
# Try to find Tephritis conura on NCBI Sequence Read Archive but there is no result so I used the sample organism in the paper Delias oraia 
# Download SRA-formatted sequencefiles along with the necessary data
prefetch -O sra_download/ SRR4341246

# fasterq-dump can be used to convert the SRA-formated sequence file to FASTQ format
# A temporary directory with the -t flag, this directory is used to storeany temporary files, which are deleted upon download completion
#  --split-3 option is used to separate paired-end reads into two FASTQ files, and the --skip-technical option filters out reads with no biological significanc
fasterq-dump --split-3 --skip-technical -O sra_fastq -t tmp sra_download/SRR4341246


# Data quality assessment
# Install fastqc
conda install -c bioconda fastqc  #Ver 0.12.1

# Run FastQC
mkdir fastqc_out

fastqc -o fastqc_out sra_fastq/SRR4341246_1.fastq # fastqc.sh in scripts directory
fastqc -o fastqc_out sra_fastq/SRR4341246_2.fastq # fastqc2.sh in scripts directory

# Run Trimmomatic
mkdir trimm_out

java -jar packages/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 10 sra_fastq/SRR4341246_1.fastq sra_fastq/SRR4341246_2.fastq \
trimm_out/SRR4341246_paired_R1.fastq trimm_out/SRR4341246_unpaired_R1.fastq trimm_out/SRR4341246_paired_R2.fastq trimm_out/SRR4341246_unpaired_R2.fastq ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3 MINLEN:36 # trim.sh in scripts directory
```
## **12th Apr 2023**
Ask Rachel about installing Kraken 2.
Trying to run kraken2 today, installing kraken2 and some info for later use.\
To make things easier for you, you may want to copy/symlink the following
files into a directory in your PATH:
  /crex/proj/snic2020-6-222/Projects/Tconura/working/Huy/packages/kraken_2/kraken2
  /crex/proj/snic2020-6-222/Projects/Tconura/working/Huy/packages/kraken_2/kraken2-build
  /crex/proj/snic2020-6-222/Projects/Tconura/working/Huy/packages/kraken_2/kraken2-inspect

Actually do not need this anymore because now I can use the module on Uppmax directly.\
Busy the whole day so did not do anything productive today but have a meeting with Rachel at 1pm for discussion, and I would call it a day.

## **13th Apr 2023**
```bash
# Run kraken2, with script kraken1.sh

# For wollbachia genome
# Load module
module load bioinfo-tools Kraken2/2.1.2-20211210-4f648f5

# Run build data base by kraken
kraken2-build --download-taxonomy --db wolbachia_ref

for ref in wolbachia_gene/ref_gene/*.fna; do 
kraken2-build --add-to-library $ref --db wolbachia_ref
done

kraken2-build --build --db wolbachia_ref

# For stammerula genome (in kraken2.sh)
kraken2-build --download-taxonomy --db stammerula_ref

for ref in stammerula_gene/ref_gene/*.fasta; do 
kraken2-build --add-to-library $ref --db stammerula_ref
done

kraken2-build --build --db stammerula_ref

# Run Kraken for wolbachia
kraken2 –db wolbachia_ref --threads 4 --report-zero-counts --use-names --confidence 0.05 --paired trimm_out/SRR4341246_paired_R1.fastq trimm_out/SRR4341246_paired_R2.fastq --output kraken_out/SRR4341246_kraken2_results.out --report kraken_out/SRR4341246_kraken2_report

# Run Kraken for stammurela
kraken2 –db stammerula_ref --threads 4 --report-zero-counts --use-names --confidence 0.05 --paired trimm_out/SRR4341246_paired_R1.fastq trimm_out/SRR4341246_paired_R2.fastq --output kraken_out2/SRR4341246_kraken2_results.out --report kraken_out2/SRR4341246_kraken2_report
```
Raise question: cant we just separate that long line of code into new lines with \\ because when I did that to make the code look nicer it have error. For example:        
```bash
kraken2 –db wolbachia_ref --threads 4 --report-zero-counts --use-names --confidence 0.05 --paired \
trimm_out/SRR4341246_paired_R1.fastq trimm_out/SRR4341246_paired_R2.fastq \
--output kraken_out/SRR4341246_kraken2_results.out \
--report kraken_out/SRR4341246_kraken2_report
```
This will resulted in error, saying find the classified and unclassified % but cant find the directory for the output
## **17th Apr 2023**
Because MetaPhlAN on Uppmax is 3.0 and in the pipeline by Anna she used ver 4.0 so I manually install the [4.0 version](https://github.com/biobakery/MetaPhlAn/wiki/MetaPhlAn-4).
```bash
# Clone the directory
git clone https://github.com/biobakery/MetaPhlAn.git

# cd to the folder, and install
pip install .

# Download the clade markers and database
metaphlan --install

# Run metaphlan, install data base, run on cleaned reads
metaphlan --install --bowtie2db metaphlan4/db #in metaphlan.sh 

# Original code
metaphlan trimm_out/SRR4341246_paired_R1.fastq,trimm_out/SRR4341246_paired_R2.fastq --bowtie2db metaphlan4/db --bowtie2out metaphlan4/SRR4341246.bowtie2.bz2 -t rel_ab_w_read_stats --nproc 10 --input_type fastq –o metaphlan4/profiled_SRR4341246.txt #in metaphlan2.sh
# The second command always resulted in error saying "metaphlan: error: unrecognized arguments: –o" although 

# Therefore I will use the module install on UPPMAX instead and see how it will go

# Still resulted in same error, removing the flag -o then the program run normally, but potentially wont have the output file.

# Modified code 1 (same error) metaphlan3.sh
metaphlan trimm_out/SRR4341246_paired_R1.fastq,trimm_out/SRR4341246_paired_R2.fastq metaphlan/profiled_SRR4341246.txt --bowtie2db metaphlan/db --bowtie2out metaphlan/SRR4341246.bowtie2.bz2 -t rel_ab_w_read_stats --nproc 10 --input_type fastq –o metaphlan/profiled_SRR4341246.txt

# Modified code 2 metaphlan4.sh 
# New error
# No MetaPhlAn BowTie2 database found (--index option)!
# Expecting location metaphlan/db/mpa_v31_CHOCOPhlAn_201901
metaphlan trimm_out/SRR4341246_paired_R1.fastq,trimm_out/SRR4341246_paired_R2.fastq metaphlan/profiled_SRR4341246.txt --bowtie2db metaphlan/db --bowtie2out metaphlan/SRR4341246.bowtie2.bz2 -t rel_ab_w_read_stats --nproc 10 --input_type fastq

# Modified code 3 metaphlan5.sh 
metaphlan trimm_out/SRR4341246_paired_R1.fastq,trimm_out/SRR4341246_paired_R2.fastq --bowtie2db metaphlan/db --bowtie2out metaphlan/SRR4341246.bowtie2.bz2 -t rel_ab_w_read_stats --nproc 10 --input_type fastq

# Keep failing i'm about to give up, Rachel if you are reading this i'm so dead

# Trying to install metaphlan4 from conda from Uppmax, but it take so long to install so I'll go to sleep and let it run
```
## **18th Apr 2023**
Try to install metaphlan 4.0.2 through conda on uppmax, do bowtie2 and other stuffs in the pipeline
```bash
module load conda
conda install metaphlan=4.0.2
# Created database - metaphlan.sh
metaphlan --install --bowtie2db metaphlan4/db
# Run metaphlan - metaphlan3.sh
# Note: still encounter same problem when using the -o flag for the output, so the -o was remove
# Modification in the flag --bowtie2db
metaphlan trimm_out/SRR4341246_paired_R1.fastq,trimm_out/SRR4341246_paired_R2.fastq --bowtie2db metaphlan4/db/mpa_v31_CHOCOPhlAn_201901 --bowtie2out metaphlan4/SRR4341246.bowtie2.bz2 -t rel_ab_w_read_stats --nproc 10 --input_type fastq
# Finally the code run normally
# The output was written in the output file that we state in SBATCH flag
# the --bowtie2db flag kinda rerun or re-download the whole database like the previous code

# Run bowtie2
module load bioinfo-tools bowtie2/2.3.5.1

# Merged fna file
cat wolbachia_gene/ref_gene/*.fna > wolref_merged.fna

# Run bowtie2 build to build index - bowtie.sh
bowtie2-build wolbachia_gene/ref_gene/wolref_merged.fna wolref_genomes_db

# Run bowtie - bowtie2.sh
bowtie2 --very-sensitive-local -p 10 --no-unal -x wolref_genomes_db -1 trimm_out/SRR4341246_paired_R1.fastq -2 trimm_out/SRR4341246_paired_R2.fastq -S SRR4341246.sam

# Run using bam and sam tools - sam.sh
samtools view -h -F 4 -b -S SRR4341246.sam > SRR4341246_mapped.bam
samtools sort -n SRR4341246_mapped.bam -o SRR4341246_mapped_sorted.bam 
bamToFastq -i SRR4341246_mapped_sorted.bam -fq SRR4341246_mapped_1.fastq -fq2 SRR4341246_mapped_2.fastq
```

## **20-26th Apr 2023**
Tasks:
```bash
# These directory are made
mkdir sub_samp
mkdir raw_wgs
mkdir fastqc
mkdir trimm
```
1. Create soft link - DONE
```bash
# These codes are run in raw_wgs directory
# Create an id.txt file that contains all the folder name
cut -f 1 /proj/snic2022-6-377/Projects/Tconura/working/Rachel/popgen_Tconura/allpops.Tcon.txt > id.txt

# 1. Make diretory as the in the txt file, cd to folder
# 2. Loop through the *.lst file, that contains the directory the fastq.gz
# 3. Create soft link of fastq.gz inside that folder
# 4. Cd out, repeat the loop
# Note: could write an if to not read the md5 so we dont have to remove later but it's easier to remove than thinking about writing a extra condition code so what's the point
# Note2: if this code did not work for you, try to mkdir first, and then run the code again without the mkdir $folder
cat id.txt | while read folder; do main=$(echo $folder | cut -d \_ -f 1) ; mkdir $folder; cd $folder ; cat /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/$main/$folder.lst | while read dir; do ln -s /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/$main/$dir ; done ; cd .. ; done

# The .lst file contains the md5 that is not useful in this situation so remove it
rm */*.md5
```
2. Subsampling (a test sample) - DONE
```bash
# This code was run in the wgs_sample directory - sub_samp.sh scripts
# 1. Load module
# 2. ls to have the list of every folder, while loop to cd to folder
# 3. In folder, ls and loop through every file and seqtk that file
# 4. Put the sub sampling file in the desire directory and cd out the folder
module load bioinfo-tools seqtk/1.2-r101; ls | while read folder; do cd $folder; ls | while read file; do seqtk sample -s100 $file 10000 > ../../sub_samp/$folder/sub_$file ; done ; cd .. ; done
```
3. fastqc + trimm - DONE
```bash
# FASTQC
# After sub sampling, fastqc did not recognise the gz file, so have to remove the .gz in the file
ls | while read folder; do cd $folder; ls | while read file; do name=$(echo "$file" | sed 's/\.gz$//') ; cp $file $name ; done ; cd .. ; done
rm */*.gz
# This code was run in the sub_samp directory - fastqc.sh scripts
module load bioinfo-tools FastQC/0.11.9
# 1. Ls of folder and cd in each folder
# 2. Fastqc for every file, -o flag for output directory
# Note: in fastqc directory, all the folders were mkdir before
ls | while read folder; do cd $folder; fastqc -o ../../fastqc/$folder *.fastq.gz ; cd ..; done

# TRIMMOMATIC
# Load module
module load bioinfo-tools trimmomatic/0.39

# 1. Loop through each folder
# 2. In every folder, ls to have all the file, paste - - to have pair of files in one line
# 3. Loop through each pair, cut and set and other stuff to have the name of the output for trimmomatic
# 4. Do trimmomatic for each pair and put the output in trimm folder
# 5. cd out when finish with one folder
ls | while read folder; do cd $folder; ls | paste - - | while read pair; do pair1=$(echo $pair | cut -d ' ' -f 1 | sed 's/.fastq/_paired.fastq/'); unpair1=$(echo $pair | cut -d ' ' -f 1 | sed 's/.fastq/_unpaired.fastq/'); pair2=$(echo $pair | cut -d ' ' -f 2 | sed 's/.fastq/_paired.fastq/'); unpair2=$(echo $pair | cut -d ' ' -f 2 | sed 's/.fastq/_unpaired.fastq/'); java -jar $TRIMMOMATIC_ROOT/trimmomatic-0.39.jar PE -threads 10 $pair ../../trimm/$folder/$pair1 ../../trimm/$folder/$unpair1 ../../trimm/$folder/$pair2 ../../trimm/$folder/$unpair2 ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3 MINLEN:36; done; cd ..; done
```
4. 1. kraken2 on test data - on going
```bash
# Data base
# /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/

# Rachel code
for i in `ls *.ccsreads.fastq.gz`;
do kraken2 $i -db /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ --threads 20 --gzip-compressed --report pt_042_longReads/${i%.ccsreads.fastq.gz}.report --unclassified-out pt_042_longReads/${i%.ccsreads.fastq.gz}.unclassified --classified-out pt_042_longReads/${i%.ccsreads.fastq.gz}.classified > pt_042_longReads/${i%.ccsreads.fastq.gz}.out;
done

# This scripts was run in trimm directory - kraken.sh
# 1. Loop through folder and cd to folder
# 2. Each folder now have 4 files for each pair (2 unpaired and 2 paired), paste to make 4 files in one line
# 3. Extract the pair with pair1 and pair2, prefix using regex for naming in kraken
# 4. Run kraken
ls | while read folder; do cd $folder; ls | paste - - - - | while read pair; do pair1=$(echo $pair | cut -d ' ' -f 1); pair2=$(echo $pair | cut -d ' ' -f 3); prefix=$(echo $pair | cut -d ' ' -f 1 | sed -E 's/sub_(P[0-9]+_[0-9]+_[A-Z0-9]+)_L([0-9]+)_R[0-9]+_001_paired.fastq/\1_L\2_001/');  kraken2 –db /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ --threads 20 --report-zero-counts --use-names --confidence 0.05 --paired $pair1 $pair2 --unclassified-out ../../kraken/$folder/$prefix.unclassified --classified-out ../../kraken/$folder/$prefix.classified --report ../../kraken/$folder/$prefix.report ; done ; cd .. ; done

```
4. 2. Install bracken
```bash
module load conda # Load conda on uppmax
export CONDA_ENVS_PATH=/proj/naiss2023-22-412/projects/microbiome/working/Hy/env # Change env directory 
conda create -n microbiome # Create new env
conda activate /proj/naiss2023-22-412/projects/microbiome/working/Hy/env/microbiome # Activate this env
conda install bracken=2.8
```

## **27-3rd May 2023**.
Re-do the tasks in the previous week but on the main data without sub-sampling
```bash
# These directory are made
mkdir raw_wgs
mkdir fastqc
mkdir trimm
mkdir kraken
```
Soft-link has already been created.

**MAY 2nd update**\
The new working directory does not have enough storage so I have to come back to the old working directory.\
The trimming process took so much time but it's done.\
The fastqc is not done yet, still running.\
The kraken step queue for a day, run for 6 hours but did not give any output so it must be something with the code, still try to run a small batch and see what will happen.\
Started writing readme.md file.

**MAY 3rd update**\
fastqc encounter problem for P14052, with this error:
>Exception in thread "Thread-1" java.lang.OutOfMemoryError: GC overhead limit exceeded\
Exception: java.lang.OutOfMemoryError thrown from the UncaughtExceptionHandler in thread "Thread-1" 

-> Try to add -t 2 flag in the code and see how it goes, it's done

RAISE QUESTION: run multiqc on both paired and unpaired? - Done

**MAY 4th update**\
Write Kraken combine scripts - DONE
RAISE QUESTION: seperated folders for kraken combine? is it necessary? personally i do not think so - DONE \
see kraken.err file - DONE (optional to extract the unclassified and classified data and put them in table)\
Run Bracken and KrakenTools
## **4-10th May 2023**.
Run alpha diversity on the bracken results + beta diversity.\
The flag -cols in beta scripts does not make any differences, I tried diff between the result generated without and with that flag but see no difference. \
Update readme file.\
*PCA step*\
First pca: convert NA to 0, add 1 to all cells, then  log2() transforms all cells\







sample1=$(echo "$line" | sed -n 's/.* #0 \([^[:space:]]*\)\..*/\1/p')
  sample2=$(echo "$line" | sed -n 's/.* #1 \([^[:space:]]*\)\..*/\1/p')
  value=$(echo "$line" | awk '{print $12}')

  # Print the extracted information
  echo "$sample1 $sample2 $value"
done < your_file.txt


shannon_alpha_F.txt


shannon_alpha_species_F.txt
Old wd
> /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/bracken_wolbachia_filtered  .

New wd
> /proj/naiss2023-22-412/projects/microbiome/working/Hy/test
