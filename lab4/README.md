# 📘 Лабораторна робота №4
**Тема:** Аналітичні SQL-запити (OLAP)
**Проєкт:** Онлайн-бібліотека (Online Library System)

## 1. Базова агрегація
*Використання `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`*
```sql
SELECT COUNT(*) AS total_books
FROM Book;

SELECT 
    SUM(amount) AS total_revenue,
    ROUND(AVG(amount), 2) AS average_payment,
    MAX(amount) AS max_payment
FROM Payment
WHERE status = 'COMPLETED';

SELECT 
    MIN(publication_date) AS oldest_book_date,
    MAX(publication_date) AS newest_book_date
FROM Book;

SELECT COUNT(DISTINCT country) AS unique_author_countries
FROM Author;
```
## 2. Групування даних
*Використання `GROUP BY`*
```sql
SELECT p.name AS publisher_name, COUNT(b.book_id) AS books_count
FROM Publisher p
JOIN Book b ON p.publisher_id = b.publisher_id
GROUP BY p.name;

SELECT type AS subscription_type, COUNT(user_id) AS users_count
FROM Subscription
GROUP BY type;

SELECT status AS loan_status, COUNT(*) AS quantity
FROM Loan
GROUP BY status;

SELECT payment_type, ROUND(AVG(amount), 2) AS avg_transaction_size
FROM Payment
GROUP BY payment_type;
```
## 3. Фільтрування груп
*Використання `HAVING`*
```sql
SELECT g.name AS genre_name, COUNT(bg.book_id) AS books_in_genre
FROM Genre g
JOIN BookGenre bg ON g.genre_id = bg.genre_id
GROUP BY g.name
HAVING COUNT(bg.book_id) > 1;

SELECT DATE(payment_date) AS pay_day, SUM(amount) AS daily_total
FROM Payment
GROUP BY DATE(payment_date)
HAVING SUM(amount) > 100.00;

SELECT p.name, ROUND(AVG(b.pages_count), 0) AS avg_pages
FROM Publisher p
JOIN Book b ON p.publisher_id = b.publisher_id
GROUP BY p.name
HAVING AVG(b.pages_count) > 400;
```
## 4. JOIN-операції
*Використання `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`*
```sql
SELECT b.name AS book_title, a.name || ' ' || a.surname AS author_name
FROM Book b
JOIN BookAuthor ba ON b.book_id = ba.book_id
JOIN Author a ON ba.author_id = a.author_id;

SELECT u.email, b.name AS current_book
FROM "User" u
LEFT JOIN Loan l ON u.user_id = l.user_id AND l.status = 'ACTIVE'
LEFT JOIN Book b ON l.book_id = b.book_id;

SELECT b.name AS book_title, g.name AS genre
FROM BookGenre bg
RIGHT JOIN Genre g ON bg.genre_id = g.genre_id
LEFT JOIN Book b ON bg.book_id = b.book_id;

SELECT u.name, u.surname, s.type, s.start_date, s.end_date
FROM "User" u
JOIN Subscription s ON u.user_id = s.user_id;
```
## 5. Багатотаблична агрегація
```sql
SELECT 
    u.name, 
    u.surname, 
    COUNT(p.payment_id) AS transactions_count, 
    SUM(p.amount) AS total_spent
FROM "User" u
JOIN Payment p ON u.user_id = p.user_id
WHERE p.status = 'COMPLETED'
GROUP BY u.user_id, u.name, u.surname
ORDER BY total_spent DESC;

SELECT pub.country, ROUND(AVG(b.pages_count), 0) AS avg_pages
FROM Publisher pub
JOIN Book b ON pub.publisher_id = b.publisher_id
GROUP BY pub.country;

SELECT s.type, SUM(p.amount) AS revenue
FROM Subscription s
JOIN Payment p ON s.subscription_id = p.subscription_id
WHERE p.status = 'COMPLETED'
GROUP BY s.type
ORDER BY revenue DESC;

SELECT g.name, COUNT(l.book_id) AS times_borrowed
FROM Genre g
JOIN BookGenre bg ON g.genre_id = bg.genre_id
JOIN Loan l ON bg.book_id = l.book_id
GROUP BY g.name
ORDER BY times_borrowed DESC;
```
## 6. Підзапити
```sql
SELECT name, pages_count
FROM Book
WHERE pages_count > (
    SELECT AVG(pages_count) 
    FROM Book
);

SELECT 
    u.email,
    (SELECT MAX(payment_date) 
     FROM Payment p 
     WHERE p.user_id = u.user_id) AS last_payment_date
FROM "User" u;

SELECT name, surname
FROM Author
WHERE author_id IN (
    SELECT ba.author_id 
    FROM BookAuthor ba
    JOIN Book b ON ba.book_id = b.book_id
    JOIN Publisher p ON b.publisher_id = p.publisher_id
    WHERE p.country = 'USA'
);

SELECT name, surname, email
FROM "User"
WHERE user_id NOT IN (
    SELECT DISTINCT user_id 
    FROM Payment
);
```