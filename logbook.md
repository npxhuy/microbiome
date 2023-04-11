# Project log book

**3rd Apr 2023**\
Requesting for being a member of project on SURP\
Creating UPPMAX account

**5th Apr 2023**\
Meeting with Rachel for Uppmax tutorial and giving initial tasks for project:
1. Find and download Wolbacchia and Stammerula reference genomes on NCBI to your working directory
2. Write up a list of the different bacterial reference genomes you found and plan to use and send it to me
3. Start working through the initial parts of the workflow from Anne Duplouy

**10th Apr 2023**\
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
```

