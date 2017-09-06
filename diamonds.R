
install.packages("hexbin")
library(tidyverse)

ggplot(diamonds, aes(carat,price)) + 
  geom_hex()

# playing around
ggplot(diamonds, aes(carat,price)) + 
  geom_hex() +
facet_wrap( ~ cut)
  #  facet_grid( cut ~ clarity)

ggsave("diamonds.pdf")

write_csv(diamonds, "diamonds.csv")