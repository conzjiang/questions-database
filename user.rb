require './question_requires.rb'

class User < Question_Obj
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM users')
    results.map { |result| User.new(result) }
  end
  
  attr_accessor :id, :fname, :lname
  
  def initialize(options = {})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end
  
  def columns
    [@fname, @lname]
  end
  
  def table
    "users"
  end

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    results.map { |result| User.new(result) }.first
  end
  
  def self.find_by_name(fname, lname)
    
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL
    
    results.map { |result| User.new(result) }
  end
  
  def authored_questions
    Question.find_by_author_id(self.id)
  end
  
  def authored_replies
    Reply.find_by_user_id(self.id)
  end
  
  def followed_questions
    Follower.followed_questions_for_user_id(self.id)
  end
  
  def liked_questions
    Like.liked_questions_for_user_id(self.id)
  end
  
  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        AVG(likes.c)
      FROM 
        (SELECT 
          COUNT(question_likes.user_id) AS c
        FROM
          question_likes
        JOIN 
          questions ON question_likes.question_id = questions.id
        WHERE 
          questions.author_id = ?
        GROUP BY
          questions.id) likes
    SQL
    
    results.first.values.first
  end
end

