require('pg')
require('pry')

class SqlRunner

  def self.run( sql, values = [] )
    begin
      db = PG.connect({ dbname: 'uk', host: 'localhost' })
      db.prepare("query", sql)
      result = db.exec_prepared( "query", values )
    ensure
      db.close() if db != nil
    end
    return result
  end

  def self.create(sql, values)
    # creates new record and returns
    # the newly created row's id
    result = self.run(sql, values)
    p result
    result.first()['id'].to_i
  end

  def self.update(sql, values)
    # update
    self.run(sql, values)
  end

  def self.all(sql, values, clazz)
    # return a map of objects of type clazz
    results = self.run(sql, values)
    results.map {|hash| clazz.new(hash)}
  end

  def self.get(sql, values, clazz)
    # run and return instance of clazz
    results = self.run(sql, values)
    clazz.new(results.first)
  end

end
