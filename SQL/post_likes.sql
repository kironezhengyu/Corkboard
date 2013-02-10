create view `corkboard`.`post_likes` as
select postId, count(*) as num_likes from likes group by postId;
