CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  follower_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (follower_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  question_id INTEGER NOT NULL,
  parent_reply INTEGER,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Constance', 'Jiang'), ('Invisible', 'Partner'), ('Bob', 'George');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('hi', 'why', 1),
  ('hey', 'banana', 2),
  ('boo', 'what', 2);
  
INSERT INTO
  replies (body, question_id, parent_reply, user_id)
VALUES
  ('because', 1, null, 2),
  ('stop', 1, 1, 1);
  
INSERT INTO
  question_followers (follower_id, question_id)
VALUES
  (2, 1), (1, 3);
  
INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (3, 1), (3, 2), (3, 3), (2, 1), (1, 2);