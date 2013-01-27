CREATE TABLE user (
         userName VARCHAR(10) NOT NULL,
         PRIMARY KEY(userName),
         nickname VARCHAR(100) NOT NULL,
         password VARCHAR(100) NOT NULL
       );
CREATE TABLE post(
       userName VARCHAR(10) NOT NULL,
       FOREIGN KEY (userName) REFERENCES user(userName),
       postId INT(30) NOT NULL AUTO_INCREMENT,
	   PRIMARY KEY(postId),
       topic VARCHAR(100) NOT NULL
);

CREATE TABLE message(
      postId INT(30) NOT NULL,
       messageId INT(30) NOT NULL AUTO_INCREMENT,
       FOREIGN KEY (postId) REFERENCES post(postId),
       PRIMARY KEY(messageId),
       content TEXT ,
       ts TIMESTAMP NOT NULL,
       userName VARCHAR(10) NOT NULL,
       FOREIGN KEY (userName) REFERENCES user(userName)
);

CREATE TABLE likes (
        messageId INT(30) NOT NULL,
        userName VARCHAR(10) NOT NULL,
        PRIMARY KEY (messageId, userName),
        FOREIGN KEY (messageId) REFERENCES message(messageId),
        FOREIGN KEY (userName) REFERENCES user(userName)
);
CREATE TABLE friends (
        userName VARCHAR(10) NOT NULL,
        friend_user_name VARCHAR(10) NOT NULL,
        PRIMARY KEY (userName, friend_user_name),
        FOREIGN KEY (userName) REFERENCES user(userName),
        FOREIGN KEY (friend_user_name) REFERENCES user(userName)
);
CREATE TABLE board_post (
       userName VARCHAR(10) NOT NULL,
        postId INT(30) NOT NULL,
        PRIMARY KEY (userName, PostId),
        FOREIGN KEY (userName) REFERENCES user(userName),
        FOREIGN KEY (postId) REFERENCES post(postId)
);
CREATE TABLE attachment (
        messageId INT(30) NOT NULL,
        link varchar(255) NOT NULL,
        PRIMARY KEY (messageId, link),
        FOREIGN KEY (messageId) REFERENCES message(messageId)
);
