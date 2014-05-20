require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    
    self.results_as_hash = true
    self.type_translation = true
  end
end

class Question_Obj
  def values
    ("?, " * (self.instance_variables.count - 2))[0...-2]
  end
  
  def ivars
    self.instance_variables[1..-1].map { |v| v.to_s[1..-1] }.join(", ")
  end
  
  def set
    cols = self.instance_variables[1..-1].map { |v| v.to_s[1..-1] }
    cols.map { |col| "#{col} = ?" }.join(", ")
  end
  
  def save
    *new_columns = self.columns
    
    if self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, *new_columns)
        INSERT INTO
          "#{self.table}" (#{self.ivars})
        VALUES
          (#{values})
      SQL
    
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, *new_columns, self.id)
        UPDATE #{self.table}
        SET #{self.set}
        WHERE id = ?
      SQL
    end
  end
end