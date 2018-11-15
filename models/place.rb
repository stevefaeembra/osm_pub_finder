require_relative("../db/sql_runner")

class Place

  attr_reader :id, :unid, :name, :place, :longitude, :latitude

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @unid = options['unid'].to_i
    @name = options['name']
    @place = options['place']
    @longitude = options['longitude'].to_f
    @latitude = options['latitude'].to_f
  end

  def self.search(pattern)
    pattern.gsub! /[*]/,"%"
    p pattern
    sql = '
      select
        osm_id as unid,
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

  def map_url
    x = @longitude
    y = @latitude
    "https://www.openstreetmap.org/#map=13/#{y}/#{x}"
  end

end
