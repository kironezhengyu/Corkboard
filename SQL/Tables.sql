CREATE TABLE user (
         userName VARCHAR(10) NOT NULL,
         PRIMARY KEY(userName),
         nickname VARCHAR(100) NOT NULL,
         password CHAR(32) NOT NULL
       );
CREATE TABLE post(
       userName VARCHAR(10),
       FOREIGN KEY (userName) REFERENCES user(userName),
       postId INT(30) NOT NULL,
       topic VARCHAR(100) NOT NULL
);

CREATE TABLE message(
      postId INT(30) NOT NULL,
       messageId INT(30) NOT NULL,
       FOREIGN KEY (postId) REFERENCES post(postId),
       PRIMARY KEY(messageId),
       content TEXT ,
       timeStamp TIMESTAMP(8) NOT NULL,
       userName VARCHAR(10) NOT NULL,
       FOREIGN KEY (userName) REFERENCES user(userName)
);

CREATE TABLE likes (
        messageId INT(30) NOT NULL,
        userName VARCHAR(10) NOT NULL,
        PRIMARY KEY (messageId, userName),
        FOREIGN KEY (messageId) REFERENCES message.messageId,
        FOREIGN KEY (userName) REFERENCES user.userName
);
CREATE TABLE friends (
        userName VARCHAR(10) NOT NULL,
        friend_user_name VARCHAR(10) NOT NULL,
        PRIMARY KEY (userName, friend_user_name),
        FOREIGN KEY (userName) REFERENCES user.userName,
        FOREIGN KEY (friend_user_name) REFERENCES user.userName
);
CREATE TABLE board_post (
       userName VARCHAR(10) NOT NULL,
        postId INT(30) NOT NULL,
        PRIMARY KEY (userName, PostID),
        FOREIGN KEY (userName) REFERENCES user.userName,
        FOREIGN KEY (postID) REFERENCES post.PostID
);
CREATE TABLE attachment (
        messageId INT(30) NOT NULL,
        link varchar(255),
        PRIMARY KEY (messageId, link),
        FOREIGN KEY (messageId) REFERENCES message.messageId
);