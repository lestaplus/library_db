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

CREATE TABLE IF NOT EXISTS "User" (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    birth_date DATE,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Subscription (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    type subscription_type NOT NULL,
    status subscription_status NOT NULL
);

CREATE TABLE IF NOT EXISTS Publisher (
    publisher_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    country VARCHAR(100),
    founded_date DATE
);

CREATE TABLE IF NOT EXISTS Book (
    book_id SERIAL PRIMARY KEY,
    publisher_id INT REFERENCES Publisher(publisher_id) ON DELETE SET NULL,
    name VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publication_date DATE,
    pages_count INT CHECK (pages_count > 0)
);

CREATE TABLE IF NOT EXISTS Author (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    birth_date DATE,
    country VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Genre (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS Payment (
    payment_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    subscription_id INT NOT NULL REFERENCES Subscription(subscription_id) ON DELETE CASCADE,
    amount NUMERIC(8,2) CHECK (amount > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_type payment_type NOT NULL,
    status payment_status NOT NULL
);

CREATE TABLE IF NOT EXISTS Loan (
    loan_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    book_id INT NOT NULL REFERENCES Book(book_id) ON DELETE CASCADE,
    status loan_status NOT NULL,
    access_end_date DATE,
    subscription_id INT REFERENCES Subscription(subscription_id) ON DELETE SET NULL,
    PRIMARY KEY (loan_date, user_id, book_id)
);

CREATE TABLE IF NOT EXISTS BookAuthor (
    book_id INT NOT NULL REFERENCES Book(book_id) ON DELETE CASCADE,
    author_id INT NOT NULL REFERENCES Author(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

CREATE TABLE IF NOT EXISTS BookGenre (
    book_id INT NOT NULL REFERENCES Book(book_id) ON DELETE CASCADE,
    genre_id INT NOT NULL REFERENCES Genre(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, genre_id)
);