
install.packages("hexbin")
library(tidyverse)

ggplot(diamonds, aes(x = carat,y = price)) + 
  geom_hex()

# playing around
ggplot(diamonds, aes(x = carat,y = price)) + 
  geom_hex() +
facet_wrap( ~ cut)
  #  facet_grid( cut ~ clarity)

ggsave("diamonds.pdf")

write_csv(diamonds, "diamonds.csv")


# Useful Shortcuts --------------------------------------------------------
#  ------------------------------------------------------------------------
# creating separator -> ctrl + shift + R
# pipe -> ctrl + shift + M
# assignment operator <-  =  alt + - (minus)



# =============
# Chapter 1 - ggplot 2
# =============

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg, mapping = aes(x= displ, y = hwy)) + 
  geom_point() +
  geom_smooth()

ggplot(data = mpg, mapping = aes(x= displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) +
  geom_smooth()

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group=1))

# adding color

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity),
           position = 'dodge'
           )
seq(1,10)

# =============
# Chapter 3 - Data Transformation with dplyr
# =============

#install.packages("nycflights13")
library(nycflights13)

flights %>% filter(month == 1, day == 1)
flights %>% filter(month %in% c(11,12))

# shortcut for pipe -> ctrl + shift + M

# filter - pick observations by values

flights %>% colnames
flights %>% select(carrier, arr_delay, dep_delay) %>% arrange(carrier)


# Chapter 4 ---------------------------------------------------------------
# shortcut for creating separator -> ctrl + shift + R

flights %>% mutate(hours = air_time / 60)
flights %>% mutate(dep_delay_hours = dep_delay / 60) %>% 
  arrange(desc(dep_delay)) %>% 
  select(carrier, dep_delay_hours, dep_delay)

by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

delays <- flights %>% 
  group_by(dest) %>% 
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count >20, dest != "HNL")

# now, plot it
ggplot(data = delays,
       mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) + 
  geom_smooth(se = FALSE)

# similar to describe() in python
flights %>% summary

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

class(not_cancelled)

# which destinations have the most carriers?
not_cancelled %>% 
  group_by(dest) %>%  # group by destination
  summarise(num_unique_carriers = n_distinct(carrier)) %>%  #aggregate num distinct carriers
  arrange(desc(num_unique_carriers)) # sort it
  
# what porportion of flights are delayed by more than an hour ? by carrier

not_cancelled %>% 
  group_by(carrier) %>%  # group by destination
  summarise( hours_perc = mean(arr_delay > 60)  ) %>%  #aggregate num distinct carriers
  arrange(hours_perc) # sort it

# what dep time has lowest delays ?

not_cancelled %>% 
  group_by(dep_time) %>%  # group by destination
  summarise( total_delay = sum(arr_delay[arr_delay > 0])  ) %>%  #aggregate num distinct carriers
  arrange(total_delay) # sort it




# Chapter 5 - Exploratory Data Analysis -----------------------------------
#  ------------------------------------------------------------------------

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = .5)

# or if u wanna do it manually

diamonds %>% 
  count(cut_width(carat, 0.5))

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)

ggplot(smaller, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

# get unique / distinct values of a column
diamonds$cut %>%  unique



ggplot(data = diamonds[diamonds$])
