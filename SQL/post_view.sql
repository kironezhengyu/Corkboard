CREATE VIEW `corkboard`.`post_view` AS
SELECT post.postId, post.topic, messageId, message.userName AS user_commenting, post.userName AS user_op, nickname, message.ts, content, num_likes-1 as num_likes
FROM post, message, user, post_likes
WHERE post.postId = message.postId AND message.userName = user.username AND post_likes.postId=post.postId;
