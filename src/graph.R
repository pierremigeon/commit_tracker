library(dplyr)

df <- read.table(file='./totals.data', header=TRUE)

#create png
png("./totals_lineplot.png", width=700, height=480)
par(mar = c(5, 7, 6, 5))

df$Date <- as.Date(df$Date)

df <- df %>%
	group_by(Date) %>%
	mutate(Date_Sum = sum(Sum), Insert_Sum = sum(Insert), Delete_Sum = sum(Delete))

df <- df %>%
	filter(Date_Sum < 1300)

df <- df %>%
	distinct( Date_Sum, .keep_all = TRUE)

df.bar <- barplot(df$Date_Sum, ylim = c(-50, 1500), ylab="Count", main='Number & Types of Changes for Commits by Day')

ind <- match( c(2019,2020,2021,2022,2023), format(df$Date, "%Y"))
axis(1, df.bar[ind,], labels = format(df$Date[ind], "%Y"))

lines(x = df.bar, y = df$Insert_Sum, col='green')
lines(x = df.bar, y = df$Delete_Sum, col='blue')
df$Date_Sum[df$Number == 0] = -10
df$Date_Sum[df$Number != 0] = NA
lines(x = df.bar, y = df$Date_Sum, col='red')
legend(x='top', legend=c("Sum", "Insert", "Delete", 'no commit'), fill=c('black', 'green', 'blue', 'red'), border=c('black'), horiz=TRUE)

dev.off()
