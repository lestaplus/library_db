--кількість книг у кожного видавця
SELECT p.name AS publisher_name, COUNT(b.book_id) AS books_count
FROM Publisher p
JOIN Book b ON p.publisher_id = b.publisher_id
GROUP BY p.name;

--розподіл користувачів за типами підписки
SELECT type AS subscription_type, COUNT(user_id) AS users_count
FROM Subscription
GROUP BY type;

--скільки книг зараз на руках, а скільки повернуто
SELECT status AS loan_status, COUNT(*) AS quantity
FROM Loan
GROUP BY status;

--середній розмір платежу в залежності від методу оплати
SELECT payment_type, ROUND(AVG(amount), 2) AS avg_transaction_size
FROM Payment
GROUP BY payment_type;