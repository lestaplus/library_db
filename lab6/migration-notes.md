# Лабораторна робота №6
**Тема:** Міграції
**Проєкт:** Онлайн-бібліотека (Online Library System)

## Мета

Використати Prisma ORM для керування схемами та дослідити, як Prisma може аналізувати та змінювати схему вашої бази даних.

## 1. Міграція add-review-table
Було додано нову таблицю ```Review``` для збору відгуків користувачів про книги.

**schema.prisma:**
```prisma
model Review {
  id        Int      @id @default(autoincrement())
  rating    Int
  comment   String?
  createdAt DateTime @default(now())
  userId    Int      @map("user_id")
  bookId    Int      @map("book_id")
  user      User     @relation(fields: [userId], references: [user_id], onDelete: Cascade)
  book      book     @relation(fields: [bookId], references: [book_id], onDelete: Cascade)
}

// До User та Book додано поле review
model User {
  reviews Review[]
}
model Book {
  reviews Review[]
}
```

**migration.sql:**
```sql
-- CreateTable
CREATE TABLE "Review" (
    "id" SERIAL NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" INTEGER NOT NULL,
    "book_id" INTEGER NOT NULL,

    CONSTRAINT "Review_pkey" PRIMARY KEY ("id")
);
-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "book"("book_id") ON DELETE CASCADE ON UPDATE CASCADE;
```

## 2. Міграція add-is-verified
Було додано поле ```is_verified``` до моделі ```User``` для перевірки верифікації.

**schema.prisma:**
```prisma
model User {
  user_id           Int            @id @default(autoincrement())
  name              String         @db.VarChar(100)
  surname           String         @db.VarChar(100)
  email             String         @unique @db.VarChar(150)
  password_hash     String         @db.VarChar(255)
  birth_date        DateTime?      @db.Date
  registration_date DateTime?      @default(now()) @db.Timestamp(6)
  loan              loan[]
  subscription      subscription[]
  reviews           Review[]
  is_verified       Boolean @default(false) // додано поле
}
```

**migration.sql:**
```sql
-- AlterTable
ALTER TABLE "User" ADD COLUMN     "is_verified" BOOLEAN NOT NULL DEFAULT false;
```

## 3. Міграція remove-pages-count
Було видалено стовпець ```pages_count``` з моделі ```Book```.

**schema.prisma:**
```prisma
model book {
  book_id          Int          @id @default(autoincrement())
  publisher_id     Int?
  name             String       @db.VarChar(200)
  isbn             String       @unique @db.VarChar(20)
  publication_date DateTime?    @db.Date
  // видалено поле pages_count
  publisher        publisher?   @relation(fields: [publisher_id], references: [publisher_id], onUpdate: NoAction)
  bookauthor       bookauthor[]
  bookgenre        bookgenre[]
  loan             loan[]
  reviews          Review[]
}
```

**migration.sql:**
```sql
-- AlterTable
ALTER TABLE "book" DROP COLUMN "pages_count";
```