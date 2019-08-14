require_relative('../db/sql_runner')
require_relative('./album')

class Artist

  attr_reader :id
  attr_accessor :name
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save
    sql = "INSERT INTO artists (name) VALUES ($1) RETURNING *"
    values = [@name]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def Artist.delete_all
    sql = "DELETE FROM artists"
    SqlRunner.run(sql)
  end

  def Artist.all
    sql = "SELECT * FROM artists"
    artists = SqlRunner.run(sql)
    return artists.map { |artist| Artist.new(artist)}
  end

  def select_from_albums
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [@id]
    albums_found = SqlRunner.run(sql, values)
    result = albums_found.map { |album| Album.new(album)  }
    return result
  end

  def update
    sql = "UPDATE artists SET name = $1 WHERE id = $2 RETURNING *"
    values = [@name, @id]
    result = SqlRunner.run(sql, values)
    updated_artist = Artist.new(result[0])
    return updated_artist
  end

  def delete
    sql = "DELETE FROM artists WHERE id =$1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def Artist.find_by_id(id_number)
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id_number]
    search_result = SqlRunner.run(sql, values)[0]
    return Artist.new(search_result)
  end


end
