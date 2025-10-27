# 📘 Лабораторна робота №2  
**Тема:** Перетворення ER-діаграми на реляційну схему PostgreSQL  
**Проєкт:** Онлайн-бібліотека (Online Library System)

## 🧱 SQL-схема бази даних

#### User
```sql
CREATE TABLE "User" (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    birth_date DATE,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO "User" (name, surname, email, password, birth_date, registration_date) VALUES
('Ivan', 'Petrenko', 'ivan.petrenko@example.com', 'pass123', '1998-04-21', NOW()),
('Anna', 'Kovalenko', 'anna.kovalenko@example.com', 'pass456', '2000-12-10', NOW()),
('Dmytro', 'Shevchenko', 'dmytro.shevchenko@example.com', 'pass789', '1995-08-05', NOW());
```
#### Subscription
```sql
CREATE TABLE Subscription (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES "User"(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE,
    type VARCHAR(50) NOT NULL,
    status VARCHAR(30) CHECK (status IN ('active','expired','cancelled')) NOT NULL
);

INSERT INTO Subscription (user_id, start_date, end_date, type, status) VALUES
(1, '2025-01-01', '2025-12-31', 'Premium', 'active'),
(2, '2025-03-01', '2025-09-01', 'Standard', 'expired'),
(3, '2025-06-15', NULL, 'Trial', 'active');
```

#### Publisher
```sql
CREATE TABLE Publisher (
    publisher_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    country VARCHAR(100),
    founded_date DATE
);

INSERT INTO Publisher (name, country, founded_date) VALUES
('Pearson Education', 'USA', '1990-04-15'),
('KyivBook', 'Ukraine', '2005-06-12'),
('O’Reilly Media', 'USA', '1980-01-01');
```

#### Book
```sql
CREATE TABLE Book (
    book_id SERIAL PRIMARY KEY,
    publisher_id INT REFERENCES Publisher(publisher_id) ON DELETE SET NULL,
    name VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publication_date DATE,
    pages_count INT CHECK (pages_count > 0)
);

INSERT INTO Book (publisher_id, name, isbn, publication_date, pages_count) VALUES
(1, 'Learning SQL', '9780596520830', '2021-01-10', 320),
(2, 'Ukrainian History', '9786171234567', '2018-05-20', 540),
(3, 'Advanced Python', '9781492051367', '2020-11-01', 450);
```

#### Author
```sql
CREATE TABLE Author (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    birth_date DATE,
    country VARCHAR(100)
);

INSERT INTO Author (name, surname, birth_date, country) VALUES
('Mark', 'Lutz', '1956-03-05', 'USA'),
('Oleh', 'Hnatiuk', '1985-07-22', 'Ukraine'),
('David', 'Beazley', '1963-01-01', 'USA');
```

#### Genre
```sql
CREATE TABLE Genre (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

INSERT INTO Genre (name, description) VALUES
('Education', 'Books that provide learning materials and tutorials'),
('History', 'Books about historical events and people'),
('Programming', 'Books related to software development and coding');
```

#### Payment
```sql
CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES "User"(user_id) ON DELETE CASCADE,
    subscription_id INT REFERENCES Subscription(subscription_id) ON DELETE CASCADE,
    amount NUMERIC(8,2) CHECK (amount > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_type VARCHAR(50) CHECK (payment_type IN ('card','paypal','bank')),
    status VARCHAR(30) CHECK (status IN ('completed','pending','failed'))
);

INSERT INTO Payment (user_id, subscription_id, amount, payment_type, status) VALUES
(1, 1, 199.99, 'card', 'completed'),
(2, 2, 99.50, 'paypal', 'completed'),
(3, 3, 0.00, 'card', 'pending'); //error (amount > 0)
```

#### Loan
```sql
CREATE TABLE Loan (
    loan_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT REFERENCES "User"(user_id) ON DELETE CASCADE,
    book_id INT REFERENCES Book(book_id) ON DELETE CASCADE,
    status VARCHAR(30) CHECK (status IN ('active','returned','expired')) NOT NULL,
    access_end_date DATE,
    subscription_id INT REFERENCES Subscription(subscription_id) ON DELETE SET NULL,
    PRIMARY KEY (loan_date, user_id, book_id)
);

INSERT INTO Loan (user_id, book_id, status, access_end_date, subscription_id) VALUES
(1, 1, 'active', '2025-12-31', 1),
(2, 2, 'returned', '2025-08-01', 2),
(3, 3, 'active', '2025-11-15', 3);
```

#### BookAuthor
```sql
CREATE TABLE BookAuthor (
    book_id INT REFERENCES Book(book_id) ON DELETE CASCADE,
    author_id INT REFERENCES Author(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

INSERT INTO BookAuthor (book_id, author_id) VALUES
(1, 1),
(3, 3),
(2, 2);
```

#### BookGenre
```sql
CREATE TABLE BookGenre (
    book_id INT REFERENCES Book(book_id) ON DELETE CASCADE,
    genre_id INT REFERENCES Genre(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, genre_id)
);

INSERT INTO BookGenre (book_id, genre_id) VALUES
(1, 1),
(1, 3),
(2, 2),
(3, 3);
```
