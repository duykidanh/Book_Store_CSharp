--create database BookStoreManager;

-- INITAL 1: running this section after running the database using register an account in identity




use BookStoreManager;

CREATE TABLE MANAGER(
	ManagerID INT PRIMARY KEY IDENTITY(1,1),
	AccountID nvarchar(128) UNIQUE not null,
)

CREATE TABLE TIER(
	TierID INT PRIMARY KEY IDENTITY(1,1),
	TierName NVARCHAR(50) UNIQUE,
	TierDiscount DECIMAL(4,2) DEFAULT 0 NOT NULL UNIQUE,
	TierLevel INT NOT NULL DEFAULT 0 UNIQUE,
	ManagerID INT not null,
    FOREIGN KEY (ManagerID) REFERENCES MANAGER(ManagerID)
)

CREATE TABLE Person(
	PersonID INT PRIMARY KEY IDENTITY(1,1),
	PersonName NVARCHAR(50) NOT NULL,
	PersonAddress NVARCHAR(100),
	PersonStatus NVARCHAR(50) DEFAULT 'ACTIVE',
		CONSTRAINT CHK_PersonStatus
		CHECK(PersonStatus IN('ACTIVE', 'LOCKED')),
	AccountID nvarchar(128) UNIQUE,
	TierID INT not null,
	FOREIGN KEY (TierID) REFERENCES TIER(TierID),
	ManagerID INT not null,
    FOREIGN KEY (ManagerID) REFERENCES MANAGER(ManagerID)
)

CREATE TABLE WALLET(
	WalletID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT UNIQUE not null,
	Balance DECIMAL(12,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (CustomerID) REFERENCES Person(PersonID)
)
CREATE TABLE BANK_ACCOUNT(
	BankAccountID INT PRIMARY KEY IDENTITY(1,1),
	BankAccountNumber NVARCHAR(16) UNIQUE
		 CONSTRAINT CK_BankAccountNumber
		 CHECK (BankAccountNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	BankAccountName NVARCHAR(50) NOT NULL,
	BankCVC NVARCHAR(3) not null
		 CONSTRAINT CK_BankCVC
		 CHECK (BankCVC LIKE '[0-9][0-9][0-9]'),
	CustomerID INT not null,
	FOREIGN KEY (CustomerID) REFERENCES Person(PersonID),
)
CREATE TABLE TRANSACTION_DETAIL(
	TransactionID INT PRIMARY KEY IDENTITY(1,1),
	TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
	TransactionAmount DECIMAL(12,2) NOT NULL,
	BankAccountID INT not null,
	FOREIGN KEY (BankAccountID) REFERENCES BANK_ACCOUNT(BankAccountID),
)
CREATE TABLE PUBLISHER(
	PublisherID INT PRIMARY KEY IDENTITY(1,1),
	PublisherName NVARCHAR(100) NOT NULL UNIQUE,
	PublisherDescription NVARCHAR(500),
	PublisherImage NVARCHAR(200),
	ManagerID INT not null ,
    FOREIGN KEY (ManagerID) REFERENCES MANAGER(ManagerID)
)
CREATE TABLE CATEGORY(
	CategoryID INT PRIMARY KEY IDENTITY(1,1),
	CategoryName NVARCHAR(100) NOT NULL UNIQUE,
	CategoryDescription NVARCHAR(100) NOT NULL,
	ManagerID INT not null,
	FOREIGN KEY (ManagerID) REFERENCES MANAGER(ManagerID),
)
CREATE TABLE PROMOTION(
	PromotionID INT PRIMARY KEY IDENTITY(1,1),
	PromotionName NVARCHAR(200) NOT NULL,
	PromotionDiscount DECIMAL(4,2) NOT NULL,
	PromotionStartDate DATETIME DEFAULT GETDATE() NOT NULL,
	PromotionEndDate DATETIME DEFAULT DATEADD(DAY,14,GETDATE()) NOT NULL,
	PromotionIsValid bit default 0 NOT NULL,
	ManagerID INT not null,
    FOREIGN KEY (ManagerID) REFERENCES MANAGER(ManagerID)
)
alter table PROMOTION add PromotionDetails TEXT;
CREATE TABLE BOOK_COLLECTION(
	BookCollectionID INT PRIMARY KEY IDENTITY(1,1),
	BookCollectionName NVARCHAR(200) NOT NULL,
	ManagerID INT not null,
    FOREIGN KEY (ManagerID) REFERENCES MANAGER(ManagerID)
)
alter table book_collection add constraint UQ_BookCollectionName Unique(BookCollectionName)

CREATE TABLE BOOK_EDITION(
	EditionID INT PRIMARY KEY IDENTITY(1,1),
	EditionPrice DECIMAL(12,2) NOT NULL,
		CONSTRAINT CHK_EditionPrice
		CHECK(EditionPrice >= 1000),
	EditionDescription NVARCHAR(500),
	EditionYear NVARCHAR(4) NOT NULL ,
		CONSTRAINT CHK_EditionYear
		CHECK(EditionYear LIKE '[0-9][0-9][0-9][0-9]'),
	EditionPageCount INT NOT NULL,
	EditionName NVARCHAR(200) NOT NULL,
	EditionAuthor NVARCHAR(100) NOT NULL,
	ManagerID INT not null,
    FOREIGN KEY (ManagerID) REFERENCES MANAGER(ManagerID)
)
alter table BOOK_EDITION alter column EditionPageCount int
alter table BOOK_EDITION drop constraint CHK_EditionPrice

create table MARKED_BOOK(
	CustomerID INT not null,
	EditionID INT not null,
	PRIMARY KEY(CustomerID, EditionID),
	FOREIGN KEY (CustomerID) REFERENCES PERSON(PersonID),
	FOREIGN KEY (EditionID) REFERENCES BOOK_EDITION(EditionID),
)
create table BOOK_CATEGORY(
	EditionID INT not null,
	CategoryID INT not null,
	primary key(EditionID, CategoryID),
	FOREIGN KEY (EditionID) REFERENCES BOOK_EDITION(EditionID),
	FOREIGN KEY (CategoryID) REFERENCES CATEGORY(CategoryID)
)
alter table BOOK_EDITION add BookCollectionID int;
alter table BOOK_EDITION add foreign key (BookCollectionID) REFERENCES BOOK_COLLECTION(BookCollectionID)

CREATE TABLE BOOK_PROMOTION(
	PromotionID INT not null,
	EditionID INT not null,
	PRIMARY KEY(PromotionID, EditionID),
	FOREIGN KEY (PromotionID) REFERENCES PROMOTION(PromotionID),
	FOREIGN KEY (EditionID) REFERENCES BOOK_EDITION(EditionID),
)
CREATE TABLE STOCK_RECEIVED_NOTE(
	StockReceivedNoteID  INT PRIMARY KEY IDENTITY(1,1),
	StockReceivedNoteDate DATETIME NOT NULL DEFAULT GETDATE(),
	PublisherID INT not null,
	FOREIGN KEY (PublisherID) REFERENCES PUBLISHER(PublisherID),
	ManagerID INT not null,
    FOREIGN KEY (ManagerID) REFERENCES MANAGER(ManagerID)
)
CREATE TABLE STOCK_RECEIVED_NOTE_DETAIL(
	NoteDetailQuantity INT NOT NULL DEFAULT 0,
		CONSTRAINT CHK_NoteDetailQuantity
		CHECK(NoteDetailQuantity >=0),
	NoteDetailPrice DECIMAL(12,2) NOT NULL,
		CONSTRAINT CHK_NoteDetailPrice
		CHECK(NoteDetailPrice >= 1000),
	EditionID INT not null,
	StockReceivedNoteID INT not null,
	PRIMARY KEY(EditionID, StockReceivedNoteID),
	FOREIGN KEY (EditionID) REFERENCES BOOK_EDITION(EditionID),
	FOREIGN KEY (StockReceivedNoteID) REFERENCES STOCK_RECEIVED_NOTE(StockReceivedNoteID),
)
CREATE TABLE STOCK_INVENTORY(
	InventoryStockInTotal INT NOT NULL DEFAULT 0,
		CONSTRAINT CHK_InventoryStockInTotal
		CHECK(InventoryStockInTotal >=0),
	InventoryStockOutTotal INT NOT NULL DEFAULT 0,
		CONSTRAINT CHK_InventoryStockOutTotal
		CHECK(InventoryStockOutTotal >=0),
	InventoryAvailableStock INT NOT NULL DEFAULT 0,
	EditionID INT NOT NULL,
	PRIMARY KEY(EditionID),
	FOREIGN KEY (EditionID) REFERENCES BOOK_EDITION(EditionID)
)
CREATE TABLE BOOK_REVIEW(
	ReviewID INT PRIMARY KEY IDENTITY(1,1),
	ReviewDescription NVARCHAR(1000) NOT NULL,
	ReviewDate DATETIME NOT NULL DEFAULT GETDATE(),
	CustomerID int not null,
	EditionID INT not null,
	CONSTRAINT UQ_CustomerEdition UNIQUE (CustomerID, EditionID),
	FOREIGN KEY (EditionID) REFERENCES BOOK_EDITION(EditionID),
	FOREIGN KEY (CustomerID) REFERENCES PERSON(PersonID),
)
alter table BOOK_REVIEW add ReviewRating int not null
alter table BOOK_REVIEW add constraint CHK_Rating check(ReviewRating between 1 and 5)

CREATE TABLE BOOK_EDITION_IMAGE(
	EditionImageID INT PRIMARY KEY IDENTITY(1,1),
	EditionImage NVARCHAR(100) NOT NULL,
	EditionID INT not null,
	FOREIGN KEY (EditionID) REFERENCES BOOK_EDITION(EditionID),
)
CREATE TABLE CUSTOMER_ORDER(
	OrderID INT PRIMARY KEY IDENTITY(1,1),
	OrderDate DATETIME DEFAULT GETDATE() NOT NULL,
	OrderTotalPrice DECIMAL(12,2) NOT NULL DEFAULT 0,
	OrderStatus NVARCHAR(50) NOT NULL DEFAULT 'INITIAL',
		CONSTRAINT CHK_OrderStatus
		CHECK(OrderStatus IN ('INITIAL', 'WAITING','CANCEL BY CUSTOMER','PROCESSING','IS AVAILABLE AT STORE', 'DELIVERING','SUCCESS','CANCEL BECAUSE OF MANY FAILED DELIVERING')),
	OrderShippingMethod NVARCHAR(50) NOT NULL DEFAULT 'SHIPPING',
		CONSTRAINT CHK_OrderShippingMethod
		CHECK(OrderShippingMethod IN ('SHIPPING','RECEIVE AT STORE')),
	OrderPaymentMethod NVARCHAR(50) NOT NULL DEFAULT 'CASH',
		CONSTRAINT CHK_OrderPaymentMethod
		CHECK(OrderPaymentMethod IN ('CASH','CURRENT BALANCE')),
	StaffID INT,
	CustomerID INT not null,
	ShipperID INT,
	FOREIGN KEY (StaffID) REFERENCES PERSON(PersonID),
	FOREIGN KEY (CustomerID) REFERENCES PERSON(PersonID),
	FOREIGN KEY (ShipperID) REFERENCES PERSON(PersonID),
)
CREATE TABLE CUSTOMER_ORDER_DETAIL(
	DetailCurrentPrice DECIMAL(12,2),
		CONSTRAINT CHK_DetailCurrentPrice
		CHECK(DetailCurrentPrice >= 1000),
	DetailQuantity INT not null,
	OrderID INT not null,
	EditionID INT not null,
	primary key (EditionID, OrderID),
	FOREIGN KEY (EditionID) REFERENCES BOOK_EDITION(EditionID),
	FOREIGN KEY (OrderID) REFERENCES CUSTOMER_ORDER(OrderID)
)
CREATE TABLE SHIP_CONFIRMATION(
	ConfirmationDate DATETIME NOT NULL DEFAULT GETDATE(),
	ConfirmationImage NVARCHAR(50) NOT NULL,
	OrderID INT not null,
	ShipperID INT not null,
	primary key(OrderID,ShipperID),
	FOREIGN KEY (OrderID) REFERENCES CUSTOMER_ORDER(OrderID),
	FOREIGN KEY (ShipperID) REFERENCES PERSON(PersonID)
)

--index
--CREATE UNIQUE NONCLUSTERED INDEX idx_Customer_Phone_Number
--ON Person(PersonPhoneNumber)
--WHERE PersonPhoneNumber IS NOT NULL;


