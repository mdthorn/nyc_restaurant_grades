library(ggplot2)
library(reshape)
library(scales)
library(choroplethr)

ggplot(grades_by_month, aes(x=month, y=value, group=variable, color=variable)) + geom_line() + 
  geom_hline(aes(yintercept=avg), linetype="dashed", color="gray57") + xlab("") +
  ylab("% of Restaurants with 'A' Grade") + scale_y_continuous(labels=percent) + 
  theme(legend.position="none") + ggtitle("NYC Restaurant Grades by Month of Year") + 
  theme(plot.title=element_text(face="bold")) + facet_wrap(~ variable, ncol=1)

zip_choropleth(total_clean, county_zoom=manhattan, title="Manhattan Restaurant Grades by Zip Code", legend="% of Restaurants Graded A")
