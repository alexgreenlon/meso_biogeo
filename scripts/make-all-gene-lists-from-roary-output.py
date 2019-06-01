#!/share/apps/bio/bio/bin/python

import sys, getopt, csv

def main(argv):
    inputfile = ''
    outprefix = ''
    numgenes = 0
    
    try:
        opts, args = getopt.getopt(argv,"hi:o:n:",["infile=","outprefix=","num="])
    except getopt.GetoptError:
        print(sys.argv[0]+' -i <inputfile> -o <outputprefix>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print(sys.argv[0]+' -i <inputfile> -o <outputprefix>')
            sys.exit()
        elif opt in ("-i", "--infile"):
            inputfile = arg
        elif opt in ("-o", "--outprefix"):
            outprefix = arg
        elif opt in ("-n","--num"):
            numgenes = int(arg)
            
    with open(inputfile,"rU") as f:
        reader = csv.reader(f)
        
        for row in reader:
            if row[0] == "Gene":
                continue
        
            else:
                outfilename = outprefix + "." + row[0] + ".txt"
                with open(outfilename,"w") as outfile:
                    i = 14
                    while i < len(row):
                        outfile.write(row[i] + "\n")
                        i += 1
                    
            
if __name__ == "__main__":
    main(sys.argv[1:])
