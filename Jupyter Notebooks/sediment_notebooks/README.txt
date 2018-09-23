sediment_getter: 
	- compile raw xls file from https://pubs.usgs.gov/of/2003/of03-001/data/basemaps/usa/usa.htm
	- clean them 
	- defines sediment classification

loc_to_grid:
	- bin the obesrvation to a predefined (through GIS) grid element 

reduce_grid:
	- summarize the info available per grid element
		*count the number of samples per grid element that were classified ROCK, CLAY, SAND, etc. 

