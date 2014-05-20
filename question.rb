require './question_requires.rb'

class Question < Question_Obj
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    results.map { |result| Question.new(result) }
  end
  
  attr_accessor :id, :title, :body, :author_id
  
  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def columns
    [@title, @body, @author_id]
  end
  
  def table
    "questions"
  end
  
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL
    
    results.map { |result| Question.new(result) }.first
  end
  
  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.author_id = ?
    SQL
    
    results.map { |result| Question.new(result) }
  end
  
  def author
    User.find_by_id(self.author_id)
  end
  
  def replies
    Reply.find_by_question_id(self.id)
  end
  
  def followers
    Follower.followers_for_question_id(self.id)
  end
  
  def self.most_followed(n)
    Follower.most_followed_questions(n)
  end
  
  def likers
    Like.likers_for_question_id(self.id)
  end
  
  def num_likes
    Like.num_likes_for_question_id(self.id)
  end
  
  def self.most_liked(n)
    Like.most_liked_questions(n)
  end
end