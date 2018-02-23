library(tidyverse)

## TIBBLE PACKAGE - modern re-imagining of the data frame
# 0. Use tibble instead of data.frame
data.frame(x = runif(100), y = 2 * x + rnorm(100)) # Won't work
data.frame(x = (x = runif(100)), y = 2 * x + rnorm(100)) # Works, but creates 'x'
tibble(x = runif(100), y = 2 * x + rnorm(100)) # Perfect

## DPLYR PACKAGE - grammar of data manipulation
# 1. Use %>% instead of ()
x <- 22
cos(sin(log(x, 15)))
x %>% log(15) %>% sin() %>% cos() # First argument from left

y <- sample(LETTERS, 15)
setdiff(x = LETTERS, y = y)
y %>% setdiff(x = LETTERS, y = .) # Use '.'

# EXERCISES: Use %>% operator
z <- list(1:10, 20:30, 40:50)
do.call(sum, lapply(z, mean))

v <- sample(-5:5, 20, TRUE)
which(v > 0)

# 2. Select variables from tibble
df <- tibble(x = runif(100), y = 2 * x + rnorm(100))
df[,"x"]
select(df, x)
df %>% select(x)
df %>% select(2) # Using column number
df %>% select(z = y)
df[, c("x", "y")]
select(df, x, y)
df %>% select(y, x) # Changed order

# EXERCISES: 
df1 <- mtcars %>% as.tibble()
df2 <- iris %>% as.tibble()
# Select vars from cyl to wt from df1

# Select vars from wt to cyl from df1

# Select vars with 'a' from df1

# Select vars that starts with 'Sepal' from df2

# Select ALL vars from df2 but change name of 'Species' to 'Gatunek'

# 3. Filter rows from tibble
df <- tibble(x = runif(100), y = 2 * x + rnorm(100), z = sample(c(1, NA), 100, TRUE))
df[df$x > 0.5, ]
df %>% filter(x > 0.5)
df[df$x > 0.5 & df$y < 0.7, ]
df %>% filter(x > 0.5, y < 0.7)
df[df$x > 0.5 | df$y < 0.7, ]
df %>% filter(x > 0.5 | y < 0.7)

# EXERCISES: 
# From df filter rows taht x is between 0.2 and 0.7.

# From df filter rows that z is NA

# From df filter rows that z is not NA. Keep only x and z vars.

# 4. Create new vars with mutate
df <- tibble(x = runif(100), y = 2 * x + rnorm(100), z = sample(c(1, NA), 100, TRUE))
df %>% mutate(a = x + y)
df %>% mutate(x = x - y) # Rewrite x
df %>% mutate(a = x + y,
              b = a^2) # Use a when creating b
df %>% transmute(a = x + y,
                 b = a^2) # Selects only new vars

# EXERCISES:
# In df create new varibale 'new' equal to 10 for every row

# In df create a variable 'str_x' being a concatenation of string 'str_' and variable x

# In df create a variable 'str_xy' being a concatenation of vars x and y

# In df create a variable 'is_na' equal 1 if z is NA, 0 otherwise

# In df create a variable 'x_group' equal to 1 if x < 0.33, 2 if 0.33 <= x < 0.66, 3 otherwise. Use case_when()

# 5. Get summary statistics using summarise
df <- tibble(x = runif(100), y = 2 * x + rnorm(100), z = sample(c(1:3, NA), 100, TRUE))
df %>% summarise(x_mean = mean(x), median_y = median(y))

# 6. Group tibble using group_by
df %>% group_by(z) %>% summarise(x_mean = mean(x), median_y = median(y))
df %>% group_by(z) %>% mutate(y_avg_group = mean(y)) %>% ungroup()

# EXERCISES:
df3 <- tibble(x = sample(1:2, 100, TRUE),
              y = sample(1:2, 100, TRUE),
              z = sample(1:2, 100, TRUE),
              v = sample(1:2, 100, TRUE))
# In df create a variable 'x_group' equal to 1 if x < 0.33, 2 if 0.33 <= x < 0.66, 3 otherwise and
# variable 'rounded_y' equal to rounded value of y, then
# group_by x_group and
# create summary 'n_obs' equal to number of obs in each group,
# 'n_dist_rounded_y' equal to number of distinct values of rounded_y,
# 'min_x' equal to minimum value of x

# Group df3 by all vars (don't use names or indexes) and get number of obs in each group called 'n_obs',
# then create new variable equal to mean of n_obs for whole dataset (not in groups)

# 7. Sort tibble using arrange
df <- tibble(x = runif(100), y = 2 * x + rnorm(100), z = sample(c(1:3, NA), 100, TRUE))
df %>% arrange(z, desc(y))

# 8. _if
# EXERCISES:
df4 <- tibble(x = sample(letters[1:4], 100, TRUE),
              y = sample(LETTERS[1:4], 100, TRUE),
              z = runif(100))
# In df4 mutate all character vars into factors, then group by all factor variables and
# summarise mean value of z for each group

# 9. _all
# EXERCISES:
df1 <- mtcars %>% as.tibble()
# From df1 select only numeric vars, then mutate square of each variable (use funs())

# 10. _at
# EXERCISES:
# In df1 for vars from 'hp' to 'wt' create summary variable equal corelation betweeen them and mpg (use funs() and vars())

# 11. Binding and joins
df5 <- tibble(x = sample(letters[1:10], 6), y = rnorm(6))
df6 <- tibble(x = sample(letters[1:10], 6), z = runif(6))
bind_cols(df5, df6)
bind_rows(df5, df6)
bind_rows(list(df5, df6)) # Works on lists
left_join(df5, df6) # And other joins...

## PURRR PACKAGE - functional programming
# 12. Use map instead of for loop
1:10 %>% map(~ .x + 6)
1:10 %>% map_dbl(~ .x + 6)
list(1, 2, 3) %>% map_dbl(~ .x + 6)
map2(1:3, 4:6, ~ .x + .y)

library(XML)
img_path <- "dataset/JPEGImages/"
annot_path <- "dataset/Annotations/"

all_imgs <- list.files(annot_path, pattern = ".xml$", full.names = TRUE) %>%
  map(~ {
    data <- xmlParse(.x) %>%
      xmlToList()
    list("filename" = paste0(img_path, data$filename, ".jpg"),
         "height" = data$size$height,
         "width" = data$size$width,
         "object" = data[names(data) == "object"] %>%
           map(~ cbind(name = .x$name, .x$bndbox %>% bind_cols())) %>%
           bind_rows())
  })

