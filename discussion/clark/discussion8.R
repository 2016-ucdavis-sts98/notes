biz = read.csv("~/data/BoulderResults/businesses.csv")

biz2 = read.csv("~/data/BoulderResults/businesses.csv"
                , stringsAsFactors = FALSE)

sapply(biz2, class)

ins = read.csv("~/data/BoulderResults/inspections.csv")
feed = read.csv("~/data/BoulderResults/feed_info.csv")

head(biz)
dim(biz)
sapply(biz, class)

# When are strings preferred over factors?
x = factor(c('a', 'b'), levels=c('a', 'b', 'c'))
x2 = as.factor(as.character(x))
levels(x2)
levels(x2) = c('A', 'B')

insbiz = merge(ins, biz)

head(insbiz)

head(biz$name)

# Find beer
beer = grep(pattern = 'beer', biz$name, value = TRUE
            , ignore.case = TRUE)

findfood = function(pat, nm = biz$name){
  grep(pattern = pat, nm, value = TRUE
           , ignore.case = TRUE)
}

findfood('boba')

findfood('pizza')

x = as.factor(c('1,900', '2,500', '1,600'))
x = gsub(',', '', x)
x2 = as.integer(x)




