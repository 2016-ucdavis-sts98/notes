# Description:
#   Functions for working with shapefiles.
#
#   This script requires the rgdal and sp packages. You can load the functions
#   in the script with
#
#       source("shapefile_tools.R")
#
#   A "map" as referred to here is an object loaded with `read_shapefile()` or
#   with class SpatialPolygonsDataFrame.


library("rgdal")
library("sp")
library("stringr")


#' Read A Shapefile
#'
#' This function reads the shapefile in the specified directory.
#'
#' @param dir shapefile directory
#'
read_shapefile = function(dir) {
  # Find the .shp file in the directory.
  re = "[.]shp$"
  shp = list.files(dir, re, ignore.case = TRUE)
  if (length(shp) == 0)
    stop(sprintf("no shapefile found in %s.", dir))
  shp = str_replace(shp[[1]], re, "")

  # Read the shapefile.
  readOGR(dir, shp)
}


#' Locate Row Regions
#'
#' For a map and each row of a data frame, this function determines which
#' region the row's latitude and longitude fall into. The output is a data
#' frame with the same number of rows and order as the original, for easy
#' column-binding.
#'
#' @param x data frame with latitude and longitude columns
#' @param shape map or similar object with projection info
in_region = function(x, shape) {
  lat = x[["latitude"]]
  lng = x[["longitude"]]

  # Remove missing values, but "remember" the original row order.
  not_na = !(is.na(lat) | is.na(lng))
  idx = rep_len(NA, nrow(x))
  idx[not_na] = seq_len(sum(not_na))

  # Map each row to a region.
  pts = to_spatial_points(lat[not_na], lng[not_na], shape)
  over(pts, shape)[idx, ]
}


#' Convert To SpatialPoints
#'
#' This function converts lat/lng coordinates to a SpatialPoints object. This
#' is a helper for the in_region() function.
#'
#' @param lat latitude vector
#' @param lng longitude vector
#' @param shape map or similar with projection info
#'
to_spatial_points = function(lat, lng, shape) {
  coords = cbind(lng, lat)
  proj = CRS(proj4string(shape))
  SpatialPoints(coords, proj) 
}
