CREATE VIEW `corkboard`.`post_view` AS
SELECT post.postId, messageId, message.userName, nickname, ts, content
FROM post, message, user
WHERE post.postId = message.postId AND message.userName = user.username;