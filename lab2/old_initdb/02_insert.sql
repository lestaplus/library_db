INSERT INTO "User" (name, surname, email, password_hash, birth_date, registration_date) VALUES
('Ivan', 'Petrenko', 'ivan.petrenko@example.com', '$2a$12$bqED1wKkFHhe.jOJpVEJBe.fFdlZPYkaL2XHCmFZjORQH1vLrBZ0W', '1998-04-21', NOW()),
('Anna', 'Kovalenko', 'anna.kovalenko@example.com', '$2a$12$Oyu9t85nLdOIF3AhKEtsne9vRBIAKEwQvZwtVo7lWZuwA6nzPcqB6', '2000-12-10', NOW()),
('Dmytro', 'Shevchenko', 'dmytro.shevchenko@example.com', '$2a$12$jNogN/Ze0ZAgBK0S1P/7q.FWqwvJ9G4kmO7gyFmTx7WDJihXW22e.', '1995-08-05', NOW());

INSERT INTO Subscription (user_id, start_date, end_date, type, status) VALUES
(1, '2025-01-01', '2025-12-31', 'PREMIUM', 'ACTIVE'),
(2, '2025-03-01', '2025-09-01', 'STANDARD', 'EXPIRED'),
(3, '2025-10-15', '2025-11-15', 'TRIAL', 'ACTIVE');

INSERT INTO Publisher (name, country, founded_date) VALUES
('Pearson Education', 'USA', '1990-04-15'),
('KyivBook', 'Ukraine', '2005-06-12'),
('O’Reilly Media', 'USA', '1980-01-01');

INSERT INTO Book (publisher_id, name, isbn, publication_date, pages_count) VALUES
(1, 'Learning SQL', '9780596520830', '2021-01-10', 320),
(2, 'Ukrainian History', '9786171234567', '2018-05-20', 540),
(3, 'Advanced Python', '9781492051367', '2020-11-01', 450);

INSERT INTO Author (name, surname, birth_date, country) VALUES
('Mark', 'Lutz', '1956-03-05', 'USA'),
('Oleh', 'Hnatiuk', '1985-07-22', 'Ukraine'),
('David', 'Beazley', '1963-01-01', 'USA');

INSERT INTO Genre (name, description) VALUES
('Education', 'Books that provide learning materials and tutorials'),
('History', 'Books about historical events and people'),
('Programming', 'Books related to software development and coding');

INSERT INTO Payment (user_id, subscription_id, amount, payment_type, status) VALUES
(1, 1, 199.99, 'CARD', 'COMPLETED'),
(2, 2, 99.50, 'PAYPAL', 'COMPLETED'),
(3, 3, 50.00, 'CARD', 'PENDING');

INSERT INTO Loan (user_id, book_id, status, access_end_date, subscription_id) VALUES
(1, 1, 'ACTIVE', '2025-12-31', 1),
(2, 2, 'RETURNED', '2025-08-01', 2),
(3, 3, 'ACTIVE', '2025-11-15', 3);

INSERT INTO BookAuthor (book_id, author_id) VALUES
(1, 1),
(3, 3),
(2, 2);

INSERT INTO BookGenre (book_id, genre_id) VALUES
(1, 1),
(1, 3),
(2, 2),
(3, 3);