
computeMatrix reference-point --referencePoint center -R shared.IKZF1.peaks.summits.bed -S WJL2020*IgG*.bw WJL2021_252*.bw WJL2021_263*.bw WJL2021_253*.bw WJL2021_261*.bw WJL2021_254*.bw WJL2021_262*.bw -p 24 -b 3000 -a 3000 --skipZeros -o matrix_combined.IKZF1.summits.gz --samplesLabel IgG IKZF1.r1 IKZF1.r2 cJUN.r1 cJUN.r2 STAT3.r1 STAT3.r2 

plotHeatmap -m matrix_combined.IKZF1.summits.gz -out combined.IKZF1.peak.summit.png --colorMap 'coolwarm' --whatToShow 'plot, heatmap and colorbar' 

computeMatrix reference-point --referencePoint center -R shared.IKZF1.peaks.summits.bed -S WJL2020*IgG*.bw WJL2021_257*.bw WJL2021_255*.bw WJL2021_256*.bw WJL2021_260*.bw WJL2021_258*.bw WJL2021_259*.bw WJL2021_263*.bw WJL2021_261*.bw WJL2021_262*.bw -p 24 -b 3000 -a 3000 --skipZeros -o matrix_IKZF1.cJUN.STAT3.summits.gz --samplesLabel IgG untreat.IKZF1 untreat.cJUN untreat.STAT3 LPS.IKZF1 LPS.cJUN LPS.STAT3 LPS+IL21.IKZF1 LPS+IL21.cJUN LPS+IL21.STAT3

plotHeatmap -m matrix_IKZF1.cJUN.STAT3.summits.gz -out IKZF1.cJUN.STAT3.summit.png --colorMap 'coolwarm' --whatToShow 'plot, heatmap and colorbar' 

