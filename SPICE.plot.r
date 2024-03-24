pdf("SYDH_TFBS.SPICE.heatmap.pdf",height=10,width = 10)
library(pheatmap)
d = read.delim("combined.SYDH_TFBS.SPAMO.txt",header=T,sep=" ")
## replace NA with 1, which means non-significant
d[is.na(d)] <- 1
rownames(d) = d[,c(1)]
rownames(d['STA5A',]) = "STAT5A"
rownames(d['STA5B',]) = "STAT5B"

d = d[,2:ncol(d)]
## no filtering
pheatmap(-log10(as.matrix(d+1e-320)),fontsize_row=2,fontsize_col = 2,treeheight_row = 0, treeheight_col = 0)
## with filtering
sel = d[rowSums(d < 1e-100) >=5,colSums(d < 1e-100) >= 1]
pheatmap(-log10(as.matrix(sel+1e-320)),fontsize_row=3,fontsize_col = 5,treeheight_row = 0, treeheight_col = 0)

sel = d[rowSums(d < 1e-150) >=1 ,colSums(d < 1e-150) >= 1]
pheatmap(-log10(as.matrix(sel+1e-320)),fontsize_row=3,fontsize_col = 5,treeheight_row = 0, treeheight_col = 0)

STATs = d[grep("^STA",rownames(d)),grep("Sta",colnames(d))]
STATs = STATs[order(rownames(STATs)),]
sel = STATs[,colSums(STATs < 1e-10)>=1]
pheatmap(-log10(as.matrix(STATs)),cellwidth = 12,cellheight = 12, angle_col = "45")

AICE = d[grep("JUN|BATF|FOS|BACH",rownames(d)),grep("Irf",colnames(d))]
AICE = AICE[order(rownames(AICE)),]
pheatmap(-log10(as.matrix(AICE)),cellwidth = 12,cellheight = 12, angle_col = "45")

dev.off()

