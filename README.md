# Лабораторна робота №1: Збір вимог та розробка ER-схеми

## Проектування бази даних для онлайн-бібліотеки

Цей проект є виконанням лабораторної роботи №1, метою якої є аналіз вимог предметної області, виділення ключових сутностей та атрибутів, а також створення концептуальної ER-діаграми (Entity-Relationship Diagram) для майбутньої бази даних.

### Зміст
1. [Опис проекту](#опис-проекту)
2. [Команда](#команда)
3. [Збір вимог](#збір-вимог)
4. [ER-діаграма схеми](#er-діаграма-схеми)
5. [Опис сутностей та зв'язків](#опис-сутностей-та-звязків)
6. [Технології та інструменти](#технології-та-інструменти)

### Опис проекту
Система, що проектується, є платформою онлайн-бібліотеки, яка надає користувачам доступ до каталогу книг за моделлю підписки. Користувачі можуть реєструватися, оформлювати підписку, оплачувати її та отримувати доступ до книг на певний період (оренда). Система повинна зберігати інформацію про користувачів, книги, авторів, видавців, а також відстежувати всі операції, пов'язані з підписками та орендою книг.

#### Функціональні вимоги:
* Користувач повинен мати можливість створити обліковий запис.
* Користувач повинен мати можливість оформити та оплатити підписку.
* Система повинна дозволяти користувачеві "брати в оренду" книги з каталогу за наявності активної підписки.
* Система повинна відстежувати початок та кінець терміну оренди книги.

#### Вимоги до даних:
* Зберігати інформацію про користувачів (ім'я, email, пароль, дата народження).
* Зберігати дані про книги (назва, ISBN, дата публікації, кількість сторінок).
* Зберігати інформацію про авторів, жанри та видавців.
* Відстежувати підписки користувачів (тип, дати початку та кінця, статус).
* Зберігати історію платежів, пов'язаних із підписками.
* Зберігати історію оренди книг користувачами.

### ER-діаграма схеми

<details>
<summary>Код діаграми у форматі Mermaid</summary>

```mermaid
erDiagram
    User {
        int user_id PK
        varchar name
        varchar surname
        varchar email
        varchar password
        date birth_date
        datetime registration_date
    }
    Subscription {
        int subscription_id PK
        int user_id FK
        date start_date
        date end_date
        varchar type
        varchar status
    }
    Payment {
        int payment_id PK
        int user_id FK
        int subscription_id FK
        decimal amount
        datetime payment_date
        varchar payment_type
        varchar status
    }
    Loan {
        date loan_date PK
        int user_id PK, FK
        int book_id PK, FK
        varchar status
        datetime access_end_date
        int subscription_id FK
    }
    Book {
        int book_id PK
        int publisher_id FK
        varchar name
        varchar isbn
        date publication_date
        int pages_count
    }
    Publisher {
        int publisher_id PK
        varchar name
        varchar country
        date founded_date
    }
    Author {
        int author_id PK
        varchar name
        varchar surname
        date birth_date
        varchar country
    }
    Genre {
        int genre_id PK
        varchar name
        text description
    }
    BookAuthor {
        int book_id PK, FK
        int author_id PK, FK
    }
    BookGenre {
        int book_id PK, FK
        int genre_id PK, FK
    }

    User ||--|o Subscription : "has"
    User ||--o{ Loan : "borrows"
    User ||--o{ Payment : "makes"
    Subscription ||--|{ Payment : "paid for"
    Subscription ||--o{ Loan : "enables"
    Book ||--o{ Loan : "refers to"
    Publisher ||--o{ Book : "published by"
    Book ||--o{ BookAuthor : "written by"
    Author ||--o{ BookAuthor : "writes"
    Book ||--o{ BookGenre : "belongs to"
    Genre ||--o{ BookGenre : "includes"