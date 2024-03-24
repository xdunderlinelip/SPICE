file=$1
grep '#' -v $file | sort -k 7,7 -g -r | head -n 500 | awk '{print $1":"($2+$5-100)"-"($2+$5+100)}' > top500.$file.bed

twoBitToFa /data/UCSC/Data/mm10/mm10.2bit top500.$file.fa -noMask -seqList=top500.$file.bed

meme -dna -oc meme_top500.$file -minw 4 -maxw 21 -nmotifs 5 -revcomp top500.$file.fa -nostatus -maxsize 10000000000000000 &

