--книги, що товщі за середнє значення
SELECT name, pages_count
FROM Book
WHERE pages_count > (
    SELECT AVG(pages_count) 
    FROM Book
);

--дата останнього платежу для кожного користувача
SELECT 
    u.email,
    (SELECT MAX(payment_date) 
     FROM Payment p 
     WHERE p.user_id = u.user_id) AS last_payment_date
FROM "User" u;

--автори, книги яких видані видавництвами зі США
SELECT name, surname
FROM Author
WHERE author_id IN (
    SELECT ba.author_id 
    FROM BookAuthor ba
    JOIN Book b ON ba.book_id = b.book_id
    JOIN Publisher p ON b.publisher_id = p.publisher_id
    WHERE p.country = 'USA'
);

--знайти користувачів, які ніколи не робили платежів
SELECT name, surname, email
FROM "User"
WHERE user_id NOT IN (
    SELECT DISTINCT user_id 
    FROM Payment
);