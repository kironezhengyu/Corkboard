CREATE VIEW `corkboard`.`post_view` AS
SELECT post.postId, post.topic, messageId, message.userName AS user_commenting, post.userName AS user_op, nickname, ts, content
FROM post, message, user
WHERE post.postId = message.postId AND message.userName = user.username;