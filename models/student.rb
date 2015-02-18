class Student
  attr_reader :squad_id, :id
  attr_accessor :name, :age, :spirit_animal

  def initialize params, existing=false
    @id = params["id"]
    @squad_id = params["squad_id"]
    @name = params["name"]
    @age = params["age"]
    @spirit_animal = params["spirit_animal"]
    @existing = existing
  end

  def existing?
    @existing
  end

#establish/allow connection to db
  def self.conn= connection
    @conn = connection
  end

  def self.conn
    @conn
  end

  def self.all?
    @conn.exec("SELECT * FROM students")
  end


#display specific student
  def self.find squad_id, id
    new @conn.exec('SELECT * FROM students WHERE id = $1 AND squad_id = $2', [ id, squad_id ] )[0], true
  end

#create / edit student
  def self.save
    if existing?
      Student.conn.exec('UPDATE students SET name=$1, age=$2, spirit_animal=$3 WHERE squad_id = $4', [ name, age, spirit_animal, id ] )
    else
      Student.conn.exec('INSERT INTO students (name, age, spirit_animal, squad_id) VALUES ($1, $2, $3,$4)', [ name, age, spirit_animal, squad_id ] )
    end
  end


  def self.create params
    new(params).save
  end

  def self.destroy
     Student.conn.exec('DELETE FROM students WHERE id = ($1)', [ id ] )
  end


end




























