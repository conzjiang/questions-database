require './question_requires.rb'

class Reply
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    results.map { |result| Reply.new(result) }
  end
  
  attr_accessor :id, :body, :question_id, :parent_id, :user_id
  
  def initialize(options = {})
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
  end
  
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL
    
    results.map { |result| Reply.new(result) }.first
  end
  
  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end
  
  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.user_id = ?
    SQL
    
    results.map { |result| Reply.new(result) }
  end
  
  def author
    results = QuestionsDatabase.instance.execute(<<-SQL, self.user_id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL
    
    results.map { |result| User.new(result) }.first
  end
  
  def question
    results = QuestionsDatabase.instance.execute(<<-SQL, self.question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL
    
    results.map { |result| Question.new(result) }.first
  end
  
  def parent_reply
    results = QuestionsDatabase.instance.execute(<<-SQL, self.parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL
    
    results.map { |result| Reply.new(result) }.first
  end
  
  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_reply = ?
    SQL
    
    results.map { |result| Reply.new(result) }
  end
end