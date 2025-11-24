--INNER JOIN: Повний список книг з авторами
SELECT b.name AS book_title, a.name || ' ' || a.surname AS author_name
FROM Book b
JOIN BookAuthor ba ON b.book_id = ba.book_id
JOIN Author a ON ba.author_id = a.author_id;

--LEFT JOIN: Активність користувачів
SELECT u.email, b.name AS current_book
FROM "User" u
LEFT JOIN Loan l ON u.user_id = l.user_id AND l.status = 'ACTIVE'
LEFT JOIN Book b ON l.book_id = b.book_id;

--RIGHT JOIN: Перевірка чи є жанри без книг
SELECT b.name AS book_title, g.name AS genre
FROM BookGenre bg
RIGHT JOIN Genre g ON bg.genre_id = g.genre_id
LEFT JOIN Book b ON bg.book_id = b.book_id;

--Деталі підписки користувачів
SELECT u.name, u.surname, s.type, s.start_date, s.end_date
FROM "User" u
JOIN Subscription s ON u.user_id = s.user_id;