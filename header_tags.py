#!/usr/bin/env python3

'''
This script is to attach the TE LTR information to the TE's fasta sequence. 
Input files are the filtered gff (contains only the left/right segments) and the ltr fasta file generated with bedtools getfasta.
'''

fh=open('/nobackup/cooper_research/krittikak/nester_output/grassl/data/grassl_ltr_tagged.fa','w')
with open('/nobackup/cooper_research/krittikak/nester_output/grassl/data/grassl_ltr_filtered.gff','r') as f,open('/nobackup/cooper_research/krittikak/nester_output/grassl/data/grassl_all.fa','r') as f2:
    f.readline()
    f.readline()
    for line2 in f2:
        line2=line2.rstrip()
        if line2.startswith('>'):
            for line in f:
                line=line.rstrip()
                temp=line.split("\t")
                info=temp[8].split(";")[0].split("=")[1] #extracting info after 'ID='
                fh.write(line2+"_"+info+"\n")
                break
        else:
            fh.write(line2+"\n")
