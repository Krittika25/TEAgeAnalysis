#!/usr/bin/env python3

'''
This script is to get only the left and right LTR segments of the TEs annotated by TE-greedy nester
'''

f2=open('/nobackup/cooper_research/krittikak/nester_output/leoti/trialrun_jun24/data/leoti_filtered_ltr.gff','w+')

with open('/nobackup/cooper_research/krittikak/nester_output/leoti/trialrun_jun24/data/leoti_all_ltr.gff') as f:
    for line in f:
        line.rstrip()
        if line.startswith('##'):
            f2.write(line)
        else:
            temp=line.split("\t")
            anno=temp[8].split(";")
            if 'LTR LEFT' in anno[0] or 'LTR RIGHT' in anno[0]:
               # print(temp[0]+";"+(anno[0].split(" ")[2])+"\t"+temp[3]+"\t"+temp[4])
               f2.write(line)                                                                                        
