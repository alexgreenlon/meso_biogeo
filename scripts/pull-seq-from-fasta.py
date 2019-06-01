#!/share/apps/bio/bio/bin/python

import sys
from Bio import SeqIO

def main():
        for record in SeqIO.parse(open(sys.argv[2],"rU"),"fasta"):
                if record.id == sys.argv[1]:
                        print ">" + record.id
                        print record.seq


if __name__ == "__main__":
        main()
