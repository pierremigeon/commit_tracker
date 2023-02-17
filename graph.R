
df <- read.table(file='commit_tracker::master.data', header=TRUE)

#create png
png("commit_tracker_lineplot.png", width=700, height=480)
par(mar = c(7, 7, 6, 5))

plot(df$Sum[df$Sum < 1000], type='s', xlab="Commit", ylab='Count', main='Summary of Changes Per commit')
lines(df$Insert[df$Sum < 1000], type='h', col='green')
lines(df$Delete[df$Sum < 1000], type='o', col='blue')
legend(x='topright', legend=c("Sum", "Insert", "Delete"), fill=c('black', 'green', 'blue'), border=c('black'))

dev.off()

