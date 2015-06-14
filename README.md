![ngstools](pictures/Irys_icon.png) - BioNano-Tools
bionano-tools
==========

*All tools presented below have only been tested by me and may contain bugs, please le tme know if you find some. Each tool relies on dependencies normally listed at the top of the code (cpan for perl and cran for R will help you add them)*

## QC-tools

Tools to process and QC BioNanoGenomics data.

*Please do dry run to discover the available options in each command*

### **bnxstats.pl**

The perl script **[bnxstats_v1.pl](qc-tools/bnxstats_v1.pl)** computes basic stats from a BNX file with size filtering just like what IrysView does under windows (but without the W). This original script was renamed 'bnxstats_v1' and left for reference. A new version of the script **[bnxstats.pl](qc-tools/bnxstats.pl)** allows filtering by size but also by avgIntensity and SNR and returns counts for each filtering subset, it also supports gzipped BNX files which is a nice thing given the huge size these text files tend to develop.
```bash
> bnxstats.pl
You must provide a BNX file with -i
## Usage: bnxstats.pl <-i bnx-file>
# Additional optional parameters are:
# <-l minsize in kb (100)>
# <-s minimal SNR (3.50)>
# <-p percentile (99)>
# <-h to display this help>
```

### **bnxfilter.pl**

The perl script **[bnxfilter.pl](qc-tools/bnxfilter.pl)** filters BNX data based on min- and max-length, max-averageIntensity, min-SNR to generate nicer data for assembly. The avgIntensitty value can be read from a run with **bnxstats.pl**, a default absolute value of '0.6' will otherwise be applied. The most recent version of the code supports gzipped data and exports as gzip as option.
```bash
> bnxfilter.pl 
You must provide a BNX file with -i
## Usage: bnxfilter.pl <-i bnx-file>
# Additional optional parameters are:
# <-l min-length in kb (100)>
# <-x max-length in kb (5000)>
# <-m max-AvgIntensity (0.6)>
# <-s min-SNR (3.5)>
# <-n min-nicks (6)>
# <-z zip results (default OFF)>

### **bnxreheader.pl**

The perl script **[bnxreheader.pl](qc-tools/bnxreheader.pl)** replaces unsupported characters in the header of a BNX file by '_' to avoid issue in IrysView (eg MQR returning empty sample name when other chatacters are present). This script should become obsolete when BNG correct their code or validate user input. 
```bash
bnxreheader.pl
You must provide a BNX file with -i
## Usage: bnxfilter.pl <-i bnx-file>
# Additional optional parameters are:
# <-z zip results (default OFF)>
# <-h to display this help>
```

### **run_MQR.sh**

The bash script **[run_MQR.sh](qc-tools/run_MQR.sh)**

Perform molecule quality report (MQR) at CLI instead of running this under IrysView. One may prefer to perform the MQR directly on his/her Nix server. The main advantage is that one can launch this code in a bash loop and perform all MQR from a list of BNX files (single runs) without supervision.

The following loop will process all BNX files in the current folder and create a MQR (in its own folder) from each BNX and a common reference (more parameters are available)
```bash
for b in *.bnx; do
  run_MQR.sh -i $b -r myreference.cmap;
done
```

Type the script name followed by -h will list all available parameters

**run_MQR.sh -h**
```bash
# Usage: runMQR.sh -i <molecules.bnx> -r <reference.cmap>
#		[optional: -l <minlen|150> -p <pval|1e-9>]
#		[optional: -t <max-threads|32> -m <max-ram|64>]
#		[optional: -s <sample N molecules>]
```
## general-tools

### **findNregions.pl**

The perl tool **[findNregions.pl](general-tools/findNregions.pl)** find regions of N's from a reference multi-fasta file and the corresponding knicker key table. It stores the coordinate of all hits to BED for loading in IrysView as track with sequence titles renamed using the key file. Such track may prove useful to identify issues associated with sequence gaps of incorrect size introduced in assemblies.

```bash
## Usage: findNregions.pl <-i fasta-file> <-k key-file to rename contigs>
# Additional optional parameters are:
# <-l minsize in bps (100)>
# <-h to display this help>
```

<h4>Please send comments and feedback to <a href="mailto:nucleomics.bioinformatics@vib.be">nucleomics.bioinformatics@vib.be</a></h4>

------------

![Creative Commons License](http://i.creativecommons.org/l/by-sa/3.0/88x31.png?raw=true)

This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).
