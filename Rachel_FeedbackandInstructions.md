# 19 - 26 April 2023

Everything is looking pretty good. I would like you to start transitioning to applying what you've learned to our data following the Kraken2 -> Bracken -> Pavian pipeline (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9725748/)

## Bioinfo next steps

1. Find the WGS data we will be using. Each of these will be the "host" DNA in which you will search for microbial sequences. 
  - Find a list of samples here: `/proj/snic2022-6-377/Projects/Tconura/working/Rachel/popgen_Tconura/allpops.Tcon.txt`
     - this will be a combination of P12002 and P14052 sample IDs
  - Locate our WGS files here: `/proj/snic2022-6-377/Projects/Tconura/data/WGS/`
    - They are nested inside many weird folders, so it will be easier and safer if you have paths within your own working directory. 
  - Write a script to create soft-links (`ln -s`) to all of the WGS sequence data for each sample. Think about how you can use your directory structure to keep track of where all of your links to your raw reads are. (maybe `raw_fastq/P12001_101`, etc.)

2. Create a set of **test** data by subsampling the fastq files from one sample (your choice).
  - I recommend doing this in its own directory so you have all of your test reads separate. 
  - Many of the samples have three read pairs (six total fastq files). For the sample you choose, you should subsampe all of the read pairs. We want to be able to test how the results combine at the end of the pipeline. 
  - This is a good tool for subsampling: https://github.com/lh3/seqtk, `subsample`

3. For your **test** data, write a script (or several scripts) to run fastqc and and trim the reads. 

4. Set up a script to run Kraken2 on your trimmed **test** fastq files. 
  - This time, rather than using your own wolbachia database, use the PlusPF prebuilt database: `$KRAKEN2_DB_PREBUILT/k2_pluspf_20221209` or `/sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/`
    - Learn more from `module spider Kraken2` and let me know if you have questions! this has been frustrating to get working in the past!

### Background: Prebuilt databases available on Uppmax
UPPMAX provides prebuilt Kraken 2 / Bracken refseq indices from https://benlangmead.github.io/aws-indexes/k2. This module defines the environment variable $KRAKEN2_DB_PREBUILT enables access to these databases; see the 'Local name' column for what to provide to the --db option.

We are interested in the PlusPF database (bacteria, viral, plasmid, human1, UniVec_Core, protozoa & fungi) 
`$KRAKEN2_DB_PREBUILT/k2_pluspf_20221209`    

## Writing/theory next steps

Thank you for reading and commenting in Anne's tutorial! I really appreciate it (and I am sure she will, too!)

To fill in some background on your project, this week I would like you to read several papers thoroughly and answer some questions. Some of them you've already looked through, but take some time to go through them more in detail. 

1. Lu et al. 2022. Nature Protocols https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9725748/
2. Lu et al. 2017. PeerJ https://peerj.com/articles/cs-104/
3. Brietwiezer & Salzberg. 2020. Bioinformatics https://doi.org/10.1093/bioinformatics/btz715
4. Ye et al. 2019. Cell. https://www.cell.com/cell/pdf/S0092-8674(19)30775-5.pdf

write 1-3 sentence answers to the following questions: 
1. What does Kraken2 do? 
2. Are there other tools that do what Kraken2 does? How does Kraken2 compare? 
3. What is the difference between Bracken and Kraken2? 
4. Why do we combine these two tools in the pipeline we are following (Lu et al. 2022). 
5. In the pipeline (Lu et al. 2022), the first step is mapping to the reference genome. Why do they recommend this? 
6. We will not be mapping to the reference first because the reference has a load of microbial sequences. Do you think skipping this mapping step could cause any problems?

Don't stress about getting these right. This is my way of helping your produce written material in preparation for your final report. We can put what you write in response to these questions in the introduction or the results. 




