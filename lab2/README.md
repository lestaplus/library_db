# 📘 Лабораторна робота №2  
**Тема:** Перетворення ER-діаграми на реляційну схему PostgreSQL  
**Проєкт:** Онлайн-бібліотека (Online Library System)

## 🧱 SQL-схема бази даних

#### ENUM Types
```sql
CREATE TYPE subscription_status AS ENUM (
	'ACTIVE',
	'EXPIRED',
	'CANCELLED'
);

CREATE TYPE subscription_type AS ENUM (
	'TRIAL',
	'STANDARD',
	'PREMIUM'
);

CREATE TYPE payment_status AS ENUM (
	'COMPLETED',
	'PENDING',
	'FAILED'
);

CREATE TYPE payment_type AS ENUM (
	'CARD',
	'PAYPAL',
	'CRYPTO'
);

CREATE TYPE loan_status AS ENUM (
	'ACTIVE',
	'RETURNED',
	'EXPIRED'
);
```

#### User
```sql
CREATE TABLE IF NOT EXISTS "User" (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    birth_date DATE,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO "User" (name, surname, email, password_hash, birth_date, registration_date) VALUES
('Ivan', 'Petrenko', 'ivan.petrenko@example.com', '$2a$12$bqED1wKkFHhe.jOJpVEJBe.fFdlZPYkaL2XHCmFZjORQH1vLrBZ0W', '1998-04-21', NOW()),
('Anna', 'Kovalenko', 'anna.kovalenko@example.com', '$2a$12$Oyu9t85nLdOIF3AhKEtsne9vRBIAKEwQvZwtVo7lWZuwA6nzPcqB6', '2000-12-10', NOW()),
('Dmytro', 'Shevchenko', 'dmytro.shevchenko@example.com', '$2a$12$jNogN/Ze0ZAgBK0S1P/7q.FWqwvJ9G4kmO7gyFmTx7WDJihXW22e.', '1995-08-05', NOW());
```

#### Subscription
```sql
CREATE TABLE IF NOT EXISTS Subscription (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    type subscription_type NOT NULL,
    status subscription_status NOT NULL
);

INSERT INTO Subscription (user_id, start_date, end_date, type, status) VALUES
(1, '2025-01-01', '2025-12-31', 'PREMIUM', 'ACTIVE'),
(2, '2025-03-01', '2025-09-01', 'STANDARD', 'EXPIRED'),
(3, '2025-10-15', '2025-11-15', 'TRIAL', 'ACTIVE');
```

#### Publisher
```sql
CREATE TABLE IF NOT EXISTS Publisher (
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
CREATE TABLE IF NOT EXISTS Book (
    book_id SERIAL PRIMARY KEY,
    publisher_id INT REFERENCES Publisher(publisher_id) ON DELETE SET NULL,
    name VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
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
CREATE TABLE IF NOT EXISTS Author (
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
CREATE TABLE IF NOT EXISTS Genre (
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
CREATE TABLE IF NOT EXISTS Payment (
    payment_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    subscription_id INT NOT NULL REFERENCES Subscription(subscription_id) ON DELETE CASCADE,
    amount NUMERIC(8,2) CHECK (amount > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_type payment_type NOT NULL,
    status payment_status NOT NULL
);

INSERT INTO Payment (user_id, subscription_id, amount, payment_type, status) VALUES
(1, 1, 199.99, 'CARD', 'COMPLETED'),
(2, 2, 99.50, 'PAYPAL', 'COMPLETED'),
(3, 3, 50.00, 'CARD', 'PENDING');
```

#### Loan
```sql
CREATE TABLE IF NOT EXISTS Loan (
    loan_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    book_id INT NOT NULL REFERENCES Book(book_id) ON DELETE CASCADE,
    status loan_status NOT NULL,
    access_end_date DATE,
    subscription_id INT REFERENCES Subscription(subscription_id) ON DELETE SET NULL,
    PRIMARY KEY (loan_date, user_id, book_id)
);

INSERT INTO Loan (user_id, book_id, status, access_end_date, subscription_id) VALUES
(1, 1, 'ACTIVE', '2025-12-31', 1),
(2, 2, 'RETURNED', '2025-08-01', 2),
(3, 3, 'ACTIVE', '2025-11-15', 3);
```

#### BookAuthor
```sql
CREATE TABLE IF NOT EXISTS BookAuthor (
    book_id INT NOT NULL REFERENCES Book(book_id) ON DELETE CASCADE,
    author_id INT NOT NULL REFERENCES Author(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

INSERT INTO BookAuthor (book_id, author_id) VALUES
(1, 1),
(3, 3),
(2, 2);
```

#### BookGenre
```sql
CREATE TABLE IF NOT EXISTS BookGenre (
    book_id INT NOT NULL REFERENCES Book(book_id) ON DELETE CASCADE,
    genre_id INT NOT NULL REFERENCES Genre(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, genre_id)
);

INSERT INTO BookGenre (book_id, genre_id) VALUES
(1, 1),
(1, 3),
(2, 2),
(3, 3);
```
