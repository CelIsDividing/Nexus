You will need to create a local MySQL (because the key type is identity) database with the following code to run the webapp successfully:

CREATE TABLE id_users (
 id BIGINT AUTO_INCREMENT PRIMARY KEY,
 clearance VARCHAR(255),
 email VARCHAR(255),
 password VARCHAR(255),
 username VARCHAR(255)
);
CREATE TABLE id_friend_requests (
 id BIGINT AUTO_INCREMENT PRIMARY KEY,
 sent_at DATETIME(6),
 status VARCHAR(255),
 sender_id BIGINT,
 receiver_id BIGINT,
 FOREIGN KEY (sender_id) REFERENCES id_users(id),
 FOREIGN KEY (receiver_id) REFERENCES id_users(id)
);
CREATE TABLE id_friendships (
 id BIGINT AUTO_INCREMENT PRIMARY KEY,
 user1_id BIGINT,
 user2_id BIGINT,
 FOREIGN KEY (user1_id) REFERENCES id_users(id),
 FOREIGN KEY (user2_id) REFERENCES id_users(id)
);
CREATE TABLE id_posts (
 id BIGINT AUTO_INCREMENT PRIMARY KEY,
 content LONGTEXT,
 created_at DATETIME(6),
 title VARCHAR(255),
 author_id BIGINT,
 FOREIGN KEY (author_id) REFERENCES id_users(id)
);
CREATE TABLE id_messages (
 id BIGINT AUTO_INCREMENT PRIMARY KEY,
 content LONGTEXT,
 sent_at DATETIME(6),
 sender_id BIGINT,
 receiver_id BIGINT,
 FOREIGN KEY (sender_id) REFERENCES id_users(id),
 FOREIGN KEY (receiver_id) REFERENCES id_users(id)
);