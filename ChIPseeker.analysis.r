## loading packages
library(ChIPseeker)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene
library(clusterProfiler)
library(ReactomePA)
library(Vennerable)
library(ggplot2)

vennplot <- function(Sets, by="Vennerable") {
    overlapDF <- overlap(Sets)
    pkg <- "Vennerable"
    require(pkg, character.only=TRUE)
    Venn <- eval(parse(text="Venn"))
    v <- Venn(SetNames=names(Sets), Weight=overlapDF$Weight)
    plotVenn <- eval(parse(text="Vennerable:::plotVenn"))
    plotVenn(v,doWeights=F)
}
pdf("ChIPseeker.analysis.pdf")

IKZF1 <- readPeakFile("p100.peaks.combined.LPS+IL21.IKZF1.nr.bed_peaks.xls",header=F)
STAT3 <- readPeakFile("p100.peaks.combined.LPS+IL21.STAT3.nr.bed_peaks.xls",header=F)
JUN <- readPeakFile("p100.peaks.combined.LPS+IL21.cJUN.nr.bed_peaks.xls",header=F)
allpeaks = GenomicRanges::GRangesList(IKZF1=IKZF1,JUN=JUN)

only.IKZF1 <- readPeakFile("only.IKZF1.txt",header=F)
only.JUN <- readPeakFile("only.JUN.txt",header=F)
only.Shared <- readPeakFile("only.Shared.txt",header=F)
combined.peaks = GenomicRanges::GRangesList(only.IKZF1=only.IKZF1,only.JUN=only.JUN,Shared=only.Shared)
    
#IKZF1.1st.and.2nd = GenomicRanges::GRangesList(IKZF1.1st=IKZF1.1st,IKZF1.2nd=IKZF1)
#vennplot(IKZF1.1st.and.2nd,by = "Vennerable")

par(mfrow=c(1,2))
no.of.peaks  = c(length(allpeaks$IKZF1),length(allpeaks$JUN))
names(no.of.peaks) = c("IKZF1","JUN")
col = c("lightblue","cyan")
mp = barplot(no.of.peaks,col=col,ylab="No. of Peaks",axisnames=FALSE)
text(mp, par("usr")[3], labels = names(no.of.peaks), srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=1)
vennplot(allpeaks,by = "Vennerable")


allpeaks = combined.peaks$Shared
#peakAnnoList <- lapply(allpeaks, annotatePeak, TxDb=txdb,verbose=FALSE)
#peakAnnoList = annotatePeak(allpeaks,TxDb=txdb,verbose=FALSE)
#plotAnnoPie(peakAnnoList,main = "IKZF1 and JUN")
#genes= lapply(peakAnnoList, function(i) as.data.frame(i)$geneId)
genes = as.data.frame(peakAnnoList)$geneId
#compGO <- compareCluster(geneCluster   = genes, ont = "BP",fun="enrichGO", OrgDb= "org.Mm.eg.db",readable=TRUE)
compGO = enrichGO(genes, ont = "BP",OrgDb= "org.Mm.eg.db",readable=TRUE)
b1 = barplot(compGO, title = "GO Analysis",showCategory = 8, font.size=12)
c1 = cnetplot(compGO,showCategory = 2,layout="kk", node_label = "all",
         cex_label_category = 1.5,cex_label_gene = 1, max.overlaps = 2)
#compPathway <- compareCluster(geneCluster   = genes, fun="enrichPathway", organism="mouse",readable=TRUE)
compPathway <- enrichPathway(genes, organism="mouse",readable=TRUE)

b2 = barplot(compPathway, title = "Reactome Pathway Analysis",showCategory = 8,font.size=12)
c2 = cnetplot(compPathway,showCategory = 3,layout="kk", node_label = "category",
         cex_label_category = 1.5,cex_label_gene = 1, max.overlaps = 2)
c3 = cnetplot(compPathway,showCategory = 5,layout="kk", node_label = "category",
         cex_label_category = 1.2,cex_label_gene = 1, max.overlaps = 3,color_category='firebrick', 
         color_gene='steelblue')

cowplot::plot_grid(b1, b2, ncol=1)
cowplot::plot_grid(c1, c3, ncol=1)


dev.off()
