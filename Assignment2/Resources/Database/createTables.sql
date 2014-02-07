--==============================================================
-- SQLite Create Tables
--==============================================================

-- pragma foreign_keys = true;

--==============================================================
-- Table: Product
--==============================================================
create table if not exists Product (
id                   INTEGER PRIMARY KEY AUTOINCREMENT     not null,
name                 text                 not null,
productDescription   text,
regularPrice         int                  not null,
salePrice            int,
photoName            text,
stores               text

);

--==============================================================
-- Table: Color
--==============================================================
create table if not exists Color (
id                   INTEGER PRIMARY KEY AUTOINCREMENT     not null,
productId            int                  not null,
name                 text                 not null,
argbValue            int                  not null,

foreign key (productId) references Product (id)
);