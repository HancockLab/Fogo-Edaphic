


######
###
#           Plot sweepFinder in Fogo
###
######

pdf("Path to output pdf", width=4.33071, height=1.77165)
par(ps=7, mfrow=c(1,1), mar=c(1.1,2.7,0.5,0.5))
windows = c("100000") # c("10000", "50000", "100000", "1000000")
plotW=c(10, 5, 2, 1)

for (w in 1:length(windows)) {
  win = windows[[w]]
  winSize = win
  
  thresh=vector()
  length(thresh) = 6
  thresh[[1]] = 0
  maxClr=0.0
  positions=vector()
  pos_s=vector()
  chr=vector()
  clr=vector()
  
  for (c in 1:5) {
    m = as.matrix(read.table("Loop through results files from sweepfinder, one per chromosome"))
    
    positions = append(positions, (as.integer(m[,1]) + thresh[[c]]))
    pos_s = append(positions, (as.integer(m[,1])))
    chr = append(chr, rep(c, length(m[,1])))
    clr = append(clr, as.double(m[,2]))
    
    # Get Thresholds among chromosomes
    thresh[[c+1]] = thresh[[c]] + length(m[,1])*as.integer(winSize)
    
    # Get maximum clr
    if (max(m[,2]) > maxClr) {
      maxClr = max(m[,2])
    }
  }
  
  plot(0, 0, type="n", axes=F, ylab="",  # list(expression("CLR"), cex=1.5), 
       xlab="", xlim=c(thresh[[1]], thresh[[6]]), ylim=c(0, maxClr+1))
  
  polygon(x=c(0, 0, thresh[[2]], thresh[[2]]), y=c(0, maxClr+10, maxClr+10, 0), col = "lightblue", border = "lightblue")
  polygon(x=c(thresh[[3]], thresh[[3]], thresh[[4]], thresh[[4]]), y=c(0, maxClr+10, maxClr+10, 0), col = "lightblue", border = "lightblue")
  polygon(x=c(thresh[[5]], thresh[[5]], thresh[[6]], thresh[[6]]), y=c(0, maxClr+10, maxClr+10, 0), col = "lightblue", border = "lightblue")
  
  centromeres = c(15084050, 3616850, 13590100, 3953300, 11705550)
  
  chrName=vector()
  length(chrName) = 5
  for (c in 1:5) {
    centr = centromeres[[c]] + thresh[[c]]
    chrName[[c]] = thresh[[c]] + (thresh[[c+1]]-thresh[[c]])/2
    polygon(x=c(centr-50000, centr-50000, centr+50000, centr+50000 ), y=c(0, maxClr+1, maxClr+10, 0), col = "darkgrey", border = "darkgrey")
  }
  
  
  cutoff =quantile(clr, probs = c(0.99))
  for (snp in 1:length(clr)) {
    irtPos=10707874
    if (!(chr[[snp]] == 4 && positions[[snp]]-thresh[[c-1]] >= irtPos-(50000) && positions[[snp]]-thresh[[c-1]] <= irtPos+(50000))) {
      if (clr[[snp]] >= cutoff) {
        points(x=positions[[snp]], y=clr[[snp]], pch=20, col=rgb(39/255, 39/255, 0, 1.0), axes=F, ylab="", xlab="", add=T)
      } else {
        points(x=positions[[snp]], y=clr[[snp]], pch=20, col=rgb(0, 0, 205/255, 0.1), axes=F, ylab="", xlab="", add=T)
      }
    } else {
    }
  }
  segments(0, cutoff, positions[[length(positions)]], cutoff, lwd=0.5)
  
  axis(1, at=thresh, tick=TRUE, labels=F, cex=1.8)
  
  axis(1, at=chrName, tick=F, labels=c("Chr1", "Chr2", "Chr3", "Chr4", "Chr5"), line=-0.8) # , cex.axis=1.5)
  axis(2, at=c(0, 25, 50), labels=c("0", "25", "50"), tick=TRUE, las=1) # , cex.axis=1.5)
  
  title("", xlab="", ylab=expression(paste("CLR")), line=1.8)
  
}
dev.off()





