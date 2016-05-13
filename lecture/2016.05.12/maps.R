
# 1. Get the map regions.

map_county = readRDS("data/maps/shp_county.rds")
map_place = readRDS("data/maps/shp_place.rds")

sf = c("San Francisco", "San Mateo")

#names(map_place)
#head(map_place$county)
#head(map_county$NAME)

map_sf_place = subset(map_place, county %in% sf)
map_sf_county = subset(map_county, NAME %in% sf)

#map_sf_place$county = droplevels(map_sf_place$county)
#table(map_sf_place$county)
#head(map_sf_place$NAME)

# 2. Label each post with its map region.
#
# Already done! Use shp_county and shp_place columns.

# 3. Get the statistic of interest by region. (could be before #1-2)

v_sf = subset(v, shp_county %in% la)
v_sf$shp_place = droplevels(v_sf$shp_place)
prices = tapply(v_sf$price, v_sf$shp_place, median, na.rm = T)
# Put medians in same order as map regions (do this after #1-2):
prices = prices[as.character(map_sf_place$NAME)]

# 4. Make a color palette.

library("viridis")
palette = viridis(4)
col = palette[cut(prices, 4)]

# 5. Plot the map!

plot(map_sf_county)
plot(map_sf_place, col = col, add = T)



# Other stuff
# -----------
c("a" = 5, "b" = 6, "c" = 7)[c("a", "b", "c")]

other_col = c(rep("white", 30), "red", "white", "blue")
