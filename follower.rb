require './question_requires.rb'

class Follower
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_followers')
    results.map { |result| Follower.new(result) }
  end
  
  attr_accessor :follower_id, :question_id
  
  def initialize(options = {})
    @follower_id = options['follower_id']
    @question_id = options['question_id']
  end
  
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_followers
      WHERE
        follower_id = ?
    SQL
    
    results.map { |result| Follower.new(result) }.first
  end
  
  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM 
        users 
      JOIN 
        question_followers ON users.id = question_followers.follower_id
      WHERE
        question_id = ?
    SQL
    
    results.map { |result| User.new(result) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        questions 
      JOIN 
        question_followers ON questions.id = question_followers.question_id
      WHERE
        follower_id = ?
    SQL
    
    results.map { |result| Question.new(result) }
  end
  
  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM 
        questions 
      JOIN 
        question_followers ON questions.id = question_followers.question_id
      GROUP BY questions.id
      ORDER BY COUNT(question_followers.follower_id) DESC
    SQL
    
    results.map { |result| Question.new(result) }[0...n]
  end
end