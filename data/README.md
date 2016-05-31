
# Data Sets

This is a list of the source and download links for all data sets used in
lecture. If a file name is listed, the data set is included in this repository.

* `sts98.rds`: STS 98 student majors

* [NOAA Significant Earthquakes][quakes] (look for the "Download" link)

* `noaa_daily.csv`: NOAA Climate Data Online daily summaries for several
  different cities ([source][NOAA CDO]).

* `dogs.rds`: made-up "toy" data about dogs

* [FiveThirtyEight data sets][FiveThirtyEightData] behind the articles at
  [FiveThirtyEight][] (use git to clone the repository).

* [Craigslist Vehicles Data][vehicles] for the San Francisco Bay Area. These
  posts were downloaded May 4th, 2016 and include variables similar to those in
  the Craigslist apartment data set.

*   US Census Bureau shape files, in the `maps/` directory:

    + `shp_county.rds`
    + `shp_place.rds`
    + `shp_urban.rds`

    These can be used to make maps that show census-designated urban areas and
    places. The counties file has more accurate county borders. To get started,
    try

    ```r
    county = readRDS("shp_county.rds")

    plot(county)
    ```

* `random_points.rds`: made-up "toy" data to demonstrate correlation

* `inventory/`: made-up "toy" data to demonstrate joins

* `example.html`: an example web page with simple HTML

[quakes]: http://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1
[NOAA CDO]: http://www.ncdc.noaa.gov/cdo-web/
[FiveThirtyEightData]: https://github.com/fivethirtyeight/data
[FiveThirtyEight]: http://fivethirtyeight.com/
[vehicles]: http://anson.ucdavis.edu/~nulle/cl_vehicles.rds

