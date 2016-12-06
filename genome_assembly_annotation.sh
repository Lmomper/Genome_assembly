#!/bin/bash 

#SBATCH -N 1# N nodes 

#SBATCH -n 16           # n number of cores

#SBATCH --mem=30000 

#SBATCH -p sched_mit_g4nier 

#SBATCH --time=48:00:00   # 3 hours

#SBATCH -o trim_assemble_annotate_error.out 

#SBATCH --mail-type=begin 

#SBATCH --mail-type=end 


#SBATCH --mail-user=momper@mit.edu 

cd /nobackup1/lmmomper/Cyano_genomes_USC/007_ULC #path to directory


module add engaging/Trimmomatic/0.36  #quality control and trimming

module add engaging/idba/1.1.2+long  # to convert from .fq to .fa

module add engaging/SPAdes/3.6.2  # assembler

module add engaging/python/3.5.1  #assembler relies on python

module add engaging/prokka/1.11  # annotation pipeline

java -jar \
  /cm/shared/engaging/Trimmomatic/Trimmomatic-0.36/trimmomatic-0.36.jar PE ULC_18_CAGATC_L002_R1_001.fastq ULC_18_CAGATC_L002_R2_001.fastq forward_unpaired_trimmed.fq paired_trimmed.fq reverse_unpaired_trimmed.fq ILLUMINACLIP:TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 #dictates input and output files, and indicates paired end mode. Automatic phred quality detected post verion .32

fq2fa forward_unpaired_trimmed.fq forward_unpaired_trimmed.fa  #converting from a quality file to a .fasta file for assembler

fq2fa reverse_unpaired_trimmed.fq reverse_unpaired_trimmed.fa #converting from a quality file to a .fasta file for assembler



spades.py -k 21,33,55,77 --careful --only-assembler -1 forward_unpaired_trimmed.fa -2 reverse_unpaired_trimmed.fa -o assembly.fa #dictates name of output directory

prokka assembly.fa/contigs.fasta -o prokka_output #output directory with annotation files