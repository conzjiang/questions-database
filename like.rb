require './question_requires.rb'

class Like
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
    results.map { |result| Like.new(result) }
  end
  
  attr_accessor :id, :user_id, :question_id
  
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM 
        users
      JOIN 
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    
    results.map { |result| User.new(result) }
  end
  
  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(user_id)
      FROM 
        question_likes
      WHERE
        question_likes.question_id = ?
    SQL
    
    # results == [{"COUNT(user_id)" => n}]
    results.first.values.first 
  end
  
  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL
    
    results.map { |result| Question.new(result) }
  end
  
  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM 
        questions 
      JOIN 
        question_likes ON questions.id = question_likes.question_id
      GROUP BY questions.id
      ORDER BY COUNT(question_likes.user_id) DESC
    SQL
    
    results.map { |result| Question.new(result) }[0...n]
  end
end
