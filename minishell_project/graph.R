
#create PDF:
pdf("rplot.pdf")

#read-data:
a <- read.table(file='/Users/pierremigeon/Desktop/code_projects/commit_tracker/minishell_project/minishell::master.data', header=TRUE)

#reverse:
a <- a[nrow(a):1,]

#determine outliers
cutoff <- mean(a$Sum[2:nrow(a)]) + 3*sd(a$Sum[2:nrow(a)])

#plot
barplot(a$Sum[a$Sum < cutoff] ~ a$Commit_num[a$Sum < cutoff], ylab="Sum Changes Made", main="Productivity: Sum of Deletions & Insertions For Each Commit", las=2, cex.names=0.5)

#close pdf
dev.off()
