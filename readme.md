Simple Pub Finder App
=====================

This is a quick test of Sinatra/Ruby to find pubs, using an OSM postgres database.

- You can search for a town/city using a wildcard pattern
- you can then choose nearby places
- clicking on the **map** link takes you to an osm map centered on the location at an appropriate zoom level
- clicking on **nearby** finds nearby places
- clicking on **pubs** lists the pubs in that area
- clicking on the name of a pub lists pubs near that pub :)
- distances are euclidian ('as the crow flies')
- walk times are approximate and assume 5km/h. They're scaled up by approx. sqrt(2) to approximate manhattan distances...

It assumes the existence of a local postgres database called 'uk' which has the postgis extension enabled. The data can be imported using data downloaded from GeoFabrik and this tool assumes the data was imported into postgres using the osm2pgsql tool.

start the tool using

```
cd code
ruby main.rb
```

the app can be viewed at localhost:4567
