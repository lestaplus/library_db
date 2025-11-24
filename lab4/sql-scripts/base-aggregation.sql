--загальна кількість книг у бібліотеці
SELECT COUNT(*) AS total_books
FROM Book;

--дохід, середній чек та максимальний платіж
SELECT 
    SUM(amount) AS total_revenue,
    ROUND(AVG(amount), 2) AS average_payment,
    MAX(amount) AS max_payment
FROM Payment
WHERE status = 'COMPLETED';

--найстаріша та найновіша книга
SELECT 
    MIN(publication_date) AS oldest_book_date,
    MAX(publication_date) AS newest_book_date
FROM Book;

--кількість унікальних країн, звідки походять автори
SELECT COUNT(DISTINCT country) AS unique_author_countries
FROM Author;