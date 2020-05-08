# Third day of tidyR
# Demetra Panos
# 9/3/19

## clear environment ##
rm(list =ls())

## load library ##
library("tidyverse")

## load data
tx_injuries <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-10/tx_injuries.csv")

safer_parks <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-10/saferparks.csv")

DeviceTypeByState <- safer_parks %>% 
  group_by(acc_state, device_type) %>%
  summarise(Count = sum(num_injured))

DeviceCategoryByState <- safer_parks %>% 
  group_by(device_category, acc_state) %>%
  summarise(Count = sum(num_injured))

InjuryTypeByDevice <- safer_parks %>% 
  group_by(category, device_category) %>%
  summarise(Count = sum(num_injured))

InjuryTypeByGender <- safer_parks %>% 
  group_by(category, gender) %>%
  summarise(Count = sum(num_injured))


## example 2 ####
# 
# # Create dataset
# data <- data.frame(
#   individual=paste( "Mister ", seq(1,60), sep=""),
#   group=c( rep('A', 10), rep('B', 30), rep('C', 14), rep('D', 6)) ,
#   value=sample( seq(10,100), 60, replace=T)
)
## Set a number of 'empty bar' to add at the end of each group
# empty_bar <- 4
# to_add <- data.frame( matrix(NA, empty_bar*nlevels(data$group), ncol(data)) )
# colnames(to_add) <- colnames(data)
# to_add$group <- rep(levels(data$group), each=empty_bar)
# data <- rbind(data, to_add)
# data <- data %>% arrange(group)
# data$id <- seq(1, nrow(data))

unique <- unique(DeviceCategoryByState$device_category)
DeviceCategoryByState$device_category <- as.factor(DeviceCategoryByState$device_category)
DeviceCategoryByState$acc_state <- as.factor(DeviceCategoryByState$acc_state)

# Set a number of 'empty bar' to add at the end of each group
empty_bar <- 4
to_add <- data.frame( matrix(NA, empty_bar*nlevels(DeviceCategoryByState$device_category), ncol(DeviceCategoryByState)) )
colnames(to_add) <- colnames(DeviceCategoryByState)
to_add$device_category <- rep(levels(DeviceCategoryByState$device_category), each=empty_bar)
dat <- rbind(DeviceCategoryByState, to_add)
dat <- data %>% arrange(device_category)
DeviceCategoryByState$id <- seq(1, nrow(DeviceCategoryByState))

# Get the name and the y position of each label
label_data <- DeviceCategoryByState
number_of_bar <- nrow(label_data)
angle <- 90 - 360 * (label_data$id-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
label_data$hjust <- ifelse( angle < -90, 1, 0)
label_data$angle <- ifelse(angle < -90, angle+180, angle)

# Order data:
DeviceCategoryByState = DeviceCategoryByState %>% arrange(device_category, Count)
# Make the plot
p <- ggplot(DeviceCategoryByState, aes(x=as.factor(id), y=Count, fill=device_category)) +       # Note that id is a factor. If x is numeric, there is some space between the first bar
  geom_bar(stat="identity", alpha=0.5) +
  ylim(-100,120) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.margin = unit(rep(-1,4), "cm") 
  ) +
  coord_polar() + 
  geom_text(data=label_data, aes(x=id, y=Count+10, label=acc_state, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=2.5, angle= label_data$angle, inherit.aes = FALSE ) 

p
