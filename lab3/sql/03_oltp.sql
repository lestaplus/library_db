SELECT user_id, name, email
FROM "User"
LIMIT 3;

SELECT subscription_id, user_id, type, status 
FROM Subscription 
WHERE status = 'ACTIVE';

SELECT publisher_id, name 
FROM Publisher 
WHERE country = 'USA';

SELECT book_id, name, publication_date 
FROM Book 
ORDER BY publication_date DESC 
LIMIT 2;

SELECT author_id, name, surname 
FROM Author 
WHERE country = 'USA';

SELECT genre_id, name 
FROM Genre;

SELECT payment_id, amount, status 
FROM Payment 
WHERE status = 'COMPLETED';

SELECT user_id, book_id, status 
FROM Loan 
WHERE status = 'ACTIVE';

SELECT * 
FROM BookAuthor 
LIMIT 5;

SELECT * 
FROM BookGenre 
LIMIT 5;

SELECT u.name, b.name AS book_name, l.status
FROM Loan l
JOIN "User" u ON u.user_id = l.user_id
JOIN Book b ON b.book_id = l.book_id
WHERE l.status = 'ACTIVE';

SELECT b.name, p.name AS publisher
FROM Book b
JOIN Publisher p ON p.publisher_id = b.publisher_id
WHERE p.country = 'USA';

SELECT u.name, s.type, s.status
FROM Subscription s
JOIN "User" u ON u.user_id = s.user_id
WHERE s.status = 'ACTIVE';


INSERT INTO "User" (name, surname, email, password_hash, birth_date)
VALUES ('Taras', 'Bondarenko', 'taras.bond@example.com', '$2a$12$xxxx', '1999-03-29');

INSERT INTO Subscription (user_id, start_date, end_date, type, status)
VALUES (1, '2026-01-01', '2026-12-31', 'PREMIUM', 'ACTIVE');

INSERT INTO Publisher (name, country, founded_date)
VALUES ('NovaBooks', 'Ukraine', '2019-02-15');

INSERT INTO Book (publisher_id, name, isbn, publication_date, pages_count)
VALUES (1, 'PostgreSQL Internals', '9781111111112', '2024-10-10', 600);

INSERT INTO Author (name, surname, birth_date, country)
VALUES ('Alex', 'Rogers', '1980-03-09', 'Canada');

INSERT INTO Genre (name, description)
VALUES ('Cybersecurity', 'Books about digital security and hacking techniques');

INSERT INTO Payment (user_id, subscription_id, amount, payment_type, status)
VALUES (2, 2, 179.99, 'CARD', 'PENDING');

INSERT INTO Loan (user_id, book_id, status, access_end_date, subscription_id)
VALUES (2, 2, 'ACTIVE', '2026-10-10', 2);

INSERT INTO BookAuthor (book_id, author_id)
VALUES (2, 1);

INSERT INTO BookGenre (book_id, genre_id)
VALUES (3, 1);