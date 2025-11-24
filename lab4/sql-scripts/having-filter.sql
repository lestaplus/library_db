--пошук жанрів, у яких є більше ніж 1 книга
SELECT g.name AS genre_name, COUNT(bg.book_id) AS books_in_genre
FROM Genre g
JOIN BookGenre bg ON g.genre_id = bg.genre_id
GROUP BY g.name
HAVING COUNT(bg.book_id) > 1;

--дні з високим доходом
SELECT DATE(payment_date) AS pay_day, SUM(amount) AS daily_total
FROM Payment
GROUP BY DATE(payment_date)
HAVING SUM(amount) > 100.00;

--видавці, які видають великі книги
SELECT p.name, ROUND(AVG(b.pages_count), 0) AS avg_pages
FROM Publisher p
JOIN Book b ON p.publisher_id = b.publisher_id
GROUP BY p.name
HAVING AVG(b.pages_count) > 400;