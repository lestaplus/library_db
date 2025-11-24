--скільки грошей витратив кожен користувач
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

--середній обсяг книг по країнах видавництв
SELECT pub.country, ROUND(AVG(b.pages_count), 0) AS avg_pages
FROM Publisher pub
JOIN Book b ON pub.publisher_id = b.publisher_id
GROUP BY pub.country;

--прибутковість типів підписок
SELECT s.type, SUM(p.amount) AS revenue
FROM Subscription s
JOIN Payment p ON s.subscription_id = p.subscription_id
WHERE p.status = 'COMPLETED'
GROUP BY s.type
ORDER BY revenue DESC;

--найпопулярніші жанри серед читачів
SELECT g.name, COUNT(l.book_id) AS times_borrowed
FROM Genre g
JOIN BookGenre bg ON g.genre_id = bg.genre_id
JOIN Loan l ON bg.book_id = l.book_id
GROUP BY g.name
ORDER BY times_borrowed DESC;