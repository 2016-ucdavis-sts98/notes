## # STS 98 - Lecture 2016.05.10
##
## See [notes.R](notes.R) to follow along in RStudio.
##
## Also see the [R input](r_session.txt) from the lecture.

## Announcements
## -------------
## (5/12) Peer Review Due
##
## (5/17) Guest Speakers: Triage Consulting

## Questions
## ---------

## __Q__: When to use functions?

v = readRDS("cl_vehicles.rds")

## 1) As a shortcut to save typing/copying:
make_plot = function(x) {
  plot(price ~ odometer, x)
}

make_plot(v)
v_sp = split(v, v$fuel)
names(v_sp)

make_plot(v_sp$diesel)
make_plot(v_sp$gas)

## 2) As an organizational tool (especially for scripts that run on their own).
##
## 3) For the apply functions:
v_sp = split(v, v$fuel)
head(v_sp$gas)
lapply(v_sp, colnames)

sapply(v_sp, median, na.rm = T)

median_of_price = function(x) {
  median(x$price, na.rm = T)
}
median_of_price(v_sp$gas)

sapply(v_sp, median_of_price)

## Choropleths
## -----------
## Plot median odometer reading by county (just SF bay).
##
## Let's make one more map with the vehicles data, from start to finish:

library("maps")
library("viridis")

# 1. Get the map regions.
sfbay = c("san francisco", "san mateo", "santa clara", "contra costa",
  "alameda", "napa", "solano", "sonoma", "marin", "yolo", "sacramento")
sfbay = paste("california", sfbay, sep = ",")
sfbay = map("county", sfbay, namesonly = TRUE, plot = FALSE)

# 2. Label each post with its map region.
v$region = paste(v$shp_state, v$shp_county, sep = ",")
v$region = tolower(v$region)

# 3. Get the average odometer readings.
v_sf = subset(v, region %in% sfbay)
odo = tapply(v_sf$odometer, v_sf$region, median, na.rm = T)
odo = odo[sfbay]

# 4. Make a color palette.
br = c(0, 25000, 50000, 100000, Inf)
col = cut(odo, br)
palette = magma(10)[3:6]

# 5. Plot the map!
map("county", sfbay, col = palette[col], fill = TRUE, mar = c(1, 1, 4, 1),
    bg = "gray60")
title("Odometer Readings for SF Bay", line = 1)
map.text("county", sfbay, add = TRUE, col = "white")
legend("bottomleft", levels(col), fill = palette, cex = 0.75)
map.scale(-123.10, 37.48, metric = FALSE, cex = 0.5)

# For a different-colored scale, see the map_scale.R file. The only way to do
# it is to rewrite the map.scale() function.

## If you want to make side-by-side maps, set `mfrow` before plotting:

par(mfrow = c(2, 1))
# map(...)

## Afterwards, reset `mfrow` to the default:

par(mfrow = c(1, 1))

## You can reuse the same 5-step process for any map.

# 1. Get the map regions.
la = c("orange", "los angeles")
la = paste("california", la, sep = ",")

# 2. Label each post with its map region.
#
# Already done!

# 3. Get the average odometer readings.
v_la = subset(v, region %in% la)
odo = tapply(v_la$odometer, v_la$region, median, na.rm = T)

# 4. Make a color palette.
col = cut(odo, br)

# 5. Plot the map!
map("county", la, col = palette[col], fill = TRUE, bg = "gray50")

## Here's a breakdown of some of the functions used:

# paste() pastes strings together
paste(c("davis", "sacramento"), c("california", "nevada"), sep = ",")

# %in% checks if elements of one vector are in another
c("california", "california,alameda") %in% sfbay

# The categorical variable created with cut() behaves like integers, so we can
# use it to subset the palette. This maps categories to colors.
palette[col]

## What are the drawbacks of choropleths?
##
## Choropleths are basically a kind of binning. We can't be sure that the value
## we see is evenly distributed across the region. The region shapes aren't
## even based on the data!
##
## Using points instead of a choropleth:

# 1-3 were done above. No changes are needed.

# 4. Make a color palette.
v_sf$col = cut(v_sf$odometer, br)

# 5. Plot the map!
map("county", sfbay)
points(v_sf$longitude, v_sf$latitude, col = palette[v_sf$col],
       pch = 19, cex = 0.5)
legend("bottomleft", levels(v_sf$col), pch = 19, col = palette)


## Interactive Maps
## ----------------
## JavaScript is a programming language for making websites. _Leaflet_ is a
## JavaScript library (a package) for making interactive maps.
##
## The leafletR package lets you control Leaflet from R. You don't need to know
## any JavaScript.

# install.packages("leafletR")
library("leafletR")

m = leaflet()
m

# Convert the data to a format leaflet understands. Make sure to remove NAs.
v_latlon = subset(v, !is.na(latitude), c("latitude", "longitude", "odometer"))
#v_latlon = v_latlon[1:100, ]
geo = toGeoJSON(v_latlon)

# Set up a style for the map. Don't use Inf as a break with leafletR.
br[5] = 1e10
style = styleGrad("odometer", br, style.par = "col", style.val = palette)

# Plot the map. It'll show up in your web browser.
m = leaflet(geo, popup = "odometer", style = style)
m

## To include a leafletR map in your report, use screenshots.
##
## When you submit your assignment, make sure to include the .html and .geojson
## files leafletR creates!
