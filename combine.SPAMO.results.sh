function multijoin() {
    out=$1
    shift 1
    cat $1 | awk '{print $1}' > $out
    for f in $*; do join -a 1 -a 2 -e"1" -o auto $out $f > tmp; mv tmp $out; done
}

#creat clean version of spamo results, for later combination
for file in spamo_out_wgEncode*;do cut -f6,19 $file/spamo.tsv | egrep '^[^[:space:]]' | grep -v '_id' | grep -v '#' | sort -k1,1 -u > temp.$file & done

#generate a file with all possible MEME motifs
cat temp.spamo_out_wgEncode* | sort -k1,1 -u | awk '{print $1}' > MEME.motifs.txt

#remove files with <=1 line
for file in temp.spamo_out_wgEncode*;do if [[ $(wc -l < $file) -le 1 ]]; then rm $file; fi;done

#multiple join files, using above defined function
multijoin combined.SPAMO.results.txt MEME.motifs.txt temp.spamo_out_wgEncode*

#print file names for combination
for file in temp.spamo_out_wgEncode*;do echo $file; done >> names.txt

## then open the names using vi, replace \n with space, then catentate names and joined files
cat names.txt combined.SPAMO.results.txt > combined.SYDH_TFBS.SPAMO.txt

## open R, read the combined file, with delimiter as space
R
library(pheatmap)
d = read.delim("combined.SYDH_TFBS.SPAMO.txt",header=T,sep=" ")
## replace NA with 1, which means non-significant
d[is.na(d)] <- 1
rownames(d) = d[,c(1)]
d = d[,2:ncol(d)]
## no filtering
pheatmap(-log10(d+1e-320),fontsize_row=5)
## with filtering
sel = d[rowSums(d < 1e-100) >=10,colSums(d < 1e-100) >= 2]
pheatmap(-log10(sel+1e-320),fontsize_row=5)

