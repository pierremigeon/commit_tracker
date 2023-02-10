
#get script path
args <- commandArgs(trailingOnly = F)  
scriptPath <- normalizePath(dirname(sub("^--file=", "", args[grep("^--file=", args)])))
setwd(scriptPath)
files <- dir(pattern=".*.data$")

for (f in files) {
	#read-data
	a <- read.table(file=f, header=TRUE)

	#ignore old format data files
	if (!("Commit_num" %in% colnames(a))) {
		next;
	}

	#reverse
	a <- a[nrow(a):1,]

	#determine outliers
	cutoff <- mean(a$Sum[2:nrow(a)]) + 3*sd(a$Sum[2:nrow(a)])

	#create png
	png(paste(f, "_sum_barplot.png", sep=""), width=640, height=480)
	par(mar = c(7, 7, 6, 5))
	
	#plot
	barplot(a$Sum[a$Sum < cutoff] ~ a$Commit_num[a$Sum < cutoff], xlab="Project Branch Commit Number", ylab="Sum Changes Made", main="Productivity: Sum of Deletions & Insertions For Each Commit", las=2, cex.names=0.5, col=rainbow(15))
# col=rainbow(length(a$Sum[a$Sum < cutoff])))

	#close pdf
	dev.off()
}
