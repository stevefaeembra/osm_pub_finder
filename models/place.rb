require_relative("../db/sql_runner")
require('pry')

class Place

  attr_reader :id, :osm_id, :name, :place, :longitude, :latitude, :distance

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @osm_id = options['osm_id'].to_i
    @name = options['name']
    @place = options['place']
    @longitude = options['longitude'].to_f
    @latitude = options['latitude'].to_f
    @distance = options['distance'].to_f if options['distance']
  end

  def self.find(osm_id)
    sql='
      select
        osm_id,
        "name",
        place,
        st_x(st_transform(way,4326)) as longitude,
        st_y(st_transform(way,4326)) as latitude
      from
        planet_osm_point where osm_id = $1
    '
    params = [osm_id]
    SqlRunner.get(sql,params,Place)
  end

  def self.search(pattern)
    pattern.gsub! /[*]/,"%"
    p pattern
    sql = '
      select
        osm_id,
	      "name",
        place,
	      st_x(st_transform(way,4326)) as longitude,
	      st_y(st_transform(way,4326)) as latitude
      from
	      planet_osm_point
      where
	      place in (\'city\',\'town\',\'village\',\'hamlet\',\'suburb\',\'neighbourhood\')
	    and
        lower("name") like $1
      order by lower("name") asc;
    '
    params = [pattern]
    SqlRunner.all(sql,params,Place)
  end

  def find_nearby_places()
    # find places within 5km
    sql = '
      with home as (
      	select
      		st_transform(way,27700) as geom
      	from
      		planet_osm_point
      	where
      		osm_id = $1
      )
      select
      	p."name" as "name",
      	p.osm_id,
      	p.place,
      	st_x(st_transform(p.way,4326)) as longitude,
      	st_y(st_transform(p.way,4326)) as latitude,
      	st_distance(
      		st_transform(home.geom,27700),
      		st_transform(p.way,27700)
      	) as distance
      from
      	home,
      	planet_osm_point p
      where
      	p."name" is not null and
      	p.place is not null and
      	p.place in (\'city\',\'town\',\'village\',\'hamlet\',\'neighbourhood\',\'suburb\') and
      	st_dwithin(home.geom,st_transform(p.way,27700),5000)
      order by
      	distance asc;
    '
    params = [@osm_id]
    # binding.pry
    SqlRunner.all(sql,params,Place)
  end

  def map_url
    x = @longitude
    y = @latitude
    "https://www.openstreetmap.org/#map=13/#{y}/#{x}"
  end

end
