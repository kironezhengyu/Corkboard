CREATE TABLE user (
         userName VARCHAR(100) NOT NULL,
         nickname VARCHAR(100) NOT NULL,
         password VARCHAR(100) NOT NULL,
		 PRIMARY KEY(userName)
       );
	   
CREATE TABLE post(
       postId INT(30) NOT NULL AUTO_INCREMENT,
	   userName VARCHAR(100),
	   topic VARCHAR(100) NOT NULL,
       FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE SET NULL,
	   PRIMARY KEY(postId)
);

CREATE TABLE message(
       postId INT(30) NOT NULL,
       messageId INT(30) NOT NULL AUTO_INCREMENT,
       content TEXT ,
       ts TIMESTAMP NOT NULL,
       userName VARCHAR(100),
	   FOREIGN KEY (postId) REFERENCES post(postId) ON DELETE CASCADE,
       FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE SET NULL,
	   PRIMARY KEY (messageId)
);

CREATE TABLE likes (
        postId INT(30) NOT NULL,
        userName VARCHAR(100) NOT NULL,
        PRIMARY KEY (postId, userName),
        FOREIGN KEY (postId) REFERENCES post(postId) ON DELETE CASCADE,
        FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE CASCADE
);
CREATE TABLE friends (
        userName VARCHAR(100) NOT NULL,
        friend_user_name VARCHAR(10) NOT NULL,
        PRIMARY KEY (userName, friend_user_name),
        FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE CASCADE,
        FOREIGN KEY (friend_user_name) REFERENCES user(userName) ON DELETE CASCADE
);
CREATE TABLE board_post (
        userName VARCHAR(100) NOT NULL,
        postId INT(30) NOT NULL,
        PRIMARY KEY (userName, PostId),
        FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE CASCADE,
        FOREIGN KEY (postId) REFERENCES post(postId) ON DELETE CASCADE
);
CREATE TABLE attachment (
        messageId INT(30) NOT NULL,
        link varchar(255) NOT NULL,
        PRIMARY KEY (messageId, link),
        FOREIGN KEY (messageId) REFERENCES message(messageId) ON DELETE CASCADE
);
