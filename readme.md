#### Quickrun

1. ```
docker  run  -v `pwd`:`pwd` -w `pwd` -i -t  anuras/mapnik pwd
```
2. Print maps: `sudo ./00-run-all-countries.sh config-files/patagonia.csv`
3. Print maps: `sudo ./00-run-all-states.sh config-files/north-america-sample-bc.csv`

#### Important files:
* `input/geofiles` - shapefiles (download from [geofabrik.de](https://download.geofabrik.de))
* `osmnames/city-boundary-files` - city boundaries
* `color-schemas` - color schemas, the used schema is hardcoded in the `.sh` files