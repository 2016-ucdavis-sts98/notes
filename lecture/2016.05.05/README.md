# STS 98 - Lecture 2016.05.05

See [notes.R](notes.R) to follow along in RStudio.

Also see the [R input](r_session.txt) from the lecture.

Announcements
-------------

Assignment 4 is now posted.

A short peer review for assignment 3 will be posted this evening and due in
one week.


Questions
---------


Maps!!!
-------

The Craigslist vehicles data has a structure similar to the Craigslist
apartments data on assignment 4.

Each row is one post. For the vehicles data, the posts are about vehicles
for sale in the San Francisco Bay Area.

```r
v = readRDS("cl_vehicles.rds")

names(v)
head(v[-2])
v[1, 2]
```

A key feature of this data set is that it includes latitude and longitude,
so we can make maps!

There are _a lot_ of packages for making maps in R. Here's a few:

Package      | Description
------------ | -----------
maps         | make simple static maps
RgoogleMaps  | make static maps with backgrounds from Google maps
choroplethr  | make choropleths (advanced features)
cartography  | make static maps (advanced features)
leafletR     | interactive maps with the Leaflet JavaScript library
rMaps        | interactive maps (still in development)

Let's start simple.

```r
# install.packages("maps")
library("maps")
```

The `map()` function is the starting point.

```r
?map

map()
```

The `database` parameter controls which map is drawn.

The `regions` parameter controls which regions are drawn.

Use the `namesonly` parameter to get region names for a particular map. You
might also want to set the `plot` parameter to `FALSE` for this.

```r
map("state", "California")
map("county")

map("county", namesonly = TRUE, plot = FALSE)
map("county", "california,sacramento")
```

A map is just a set of shapes (also called _polygons_).

A _region_ is one or more shapes in a map. Each shape in a region has a
name in the format `region:shape` or `region,shape`.

```r
map("county", "california")
```

Use `map.text()` to add labels. You can use the default labels, or chose
your own.

```r
map.text("county", "california")
```

The `add` parameter lets you add to the current map.

```r
map("county")
map.text("county", "california", add = TRUE)
```

Example - Post Locations
------------------------
How can you visualize where the car posts came from?

```r
map("state")
points(v$longitude, v$latitude)

map("county", "california")
points(v$longitude, v$latitude)

map("county", "california")
smoothScatter(v$longitude, v$latitude, 1000, add = TRUE)
map("county", "california", add = TRUE)
```

How can you zoom in on the San Francisco Bay area?

One way is to set `xlim` and `ylim` to an appropriate longitude/latitude.

Another way:

```r
map("county", c("california,san francisco", "california,san mateo"))
```

How can you automate typing the county names?

The `paste()` function glues strings together. Its `sep` parameter controls
the characters separating each string.

```r
paste("hello", "world", sep = ",")

sfbay_counties = c("san francisco", "san mateo", "marin", "alameda", "contra
  costa", "napa", "sonoma", "santa clara", "solano", "yolo", "sacramento")
sfbay = paste("california", sfbay_counties, sep = ",")

map("county", sfbay)
smoothScatter(v$longitude, v$latitude, 3000, add = TRUE)
map("county", sfbay, add = TRUE)
```

A larger `nbin` setting for `smoothScatter()` results in a smoother plot,
but also takes more time to draw.

Example - Choropleth
---------------------
How can you visualize the price of vehicles by county?

First, compute a price for each county!

```r
nrow(v)

by_county = split(v$price, v$shp_county)
sapply(by_county, mean, na.rm = TRUE)

# Same thing:
prices = tapply(v$price, v$shp_county, mean, na.rm = TRUE)
```

Color shapes in a map by assigning a vector to the `col` parameter.

You also need to set `fill` to `TRUE`.

```r
map("county", sfbay, fill = TRUE, col = c("red", "blue"))
counties = map("county", sfbay, namesonly = TRUE, plot = FALSE)
```

You need to match the average prices to map regions.

The names in our price vector don't match!

```r
prices
names(prices)
```

How can you convert the `shp_state` and `shp_county` variables to a region
name?

```r
v$map_region = paste(v$shp_state, v$shp_county, sep = ",")
head(v$map_region)

tolower("HELLO world")
v$map_region = tolower(v$map_region)
head(v$map_region)
```

Now compute the average prices again.

```r
prices = tapply(v$price, v$map_region, mean, na.rm = TRUE)
prices
prices = prices[counties]
```

Great, but how can you assign a color to each number?

```r
map("county", sfbay, fill = TRUE, col = prices)
```

Factors behave like colors.

```r
cut(prices, 4)
price_cat = cut(prices, 4, dig.lab = 10)

typeof(price_cat)
levels(price_cat)
map("county", sfbay, fill = TRUE, col = price_cat)
legend("bottomleft", levels(price_cat), fill = 1:4, cex = 1)
```

But now there's two new problems!

```r
# install.packages("viridis")
library("viridis")
pal = magma(4)

# Use the levels (1-4) of the factor to select the colors.
names(price_cat) = sfbay
levels(price_cat) = c("cheap", "mid-cheap", "mid-expensive", "expensive")
price_cat
colors = pal[price_cat]
names(colors) = sfbay

map("county", sfbay, fill = TRUE, col = pal[price_cat])
legend("bottomleft", levels(price_cat), fill = pal, cex = 1)
```

Quick Reference
---------------
There's a lot of useful functions in the `maps` package:

Function     | Description
------------ | -----------
map          | make a map
map.text     | make a map with labels
map.axes     | add axes to a map
map.scale    | add a scale to a map
map.where    | identify which map region a point falls into
smooth.map   | alternative to smoothScatter
identify.map | identify map regions by clicking


RgoogleMaps
-----------
The Rgooglemaps package can fetch images from Google Maps or OpenStreetMap.

```r
library("RgoogleMaps")
```

Download a map with the `GetMap()` function.

The `center` parameter specifies where the map is centered.

The `zoom` parameter specifies the zoom level as an integer.

```r
m = GetMap(c(37.78, -122.42), zoom = 8)
```

Use the `PlotOnStaticMap()` function to display a map.

```r
PlotOnStaticMap(m, v$latitude, v$longitude, cex = 0.15)
```

What if you want to color the points by county? This is a silly example, but
it shows how to color the points.

```r
# First subset to the counties of interest.
sf_v = subset(v, map_region %in% sfbay)

# Now convert map_region to a categorical variable.
sf_v$map_region_cat = factor(sf_v$map_region)
levels(sf_v$map_region_cat)

# Now get a color palette with one color for each category.
length(levels(sf_v$map_region_cat))
pal = viridis(11)

# Finally, assign a color to each post, then plot the posts.
sf_v$color = pal[sf_v$map_region_cat]
