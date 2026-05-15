CREATE DATABASE SnapJoDB;
GO
USE SnapJoDB;

/*============ 1. USERS (الأساس لكل الحسابات) ============= */
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(50),
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Customer', 'Photographer', 'Admin')),
    CreatedAt DATETIME DEFAULT GETDATE()
);

/*============ 2. PHOTOGRAPHERS (تفاصيل المصورين) ============= */
CREATE TABLE Photographers (
    PhotographerId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT UNIQUE NOT NULL,
    Specialty NVARCHAR(100), -- أعراس، منتجات، إلخ
    Bio NVARCHAR(MAX),
    Location NVARCHAR(150), -- إربد، عمان، إلخ
    YearsOfExperience INT,
    ProfileImageUrl NVARCHAR(255),
    Status NVARCHAR(50) DEFAULT 'Approved', -- Pending, Approved, Suspended
    
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

/*============ 3. PORTFOLIO (معرض أعمال المصور) ============= */
CREATE TABLE Portfolio (
    PhotoId INT PRIMARY KEY IDENTITY(1,1),
    PhotographerId INT NOT NULL,
    ImageUrl NVARCHAR(255) NOT NULL,
    Title NVARCHAR(100),
    Category NVARCHAR(50), -- نوع الصورة داخل المعرض
    
    FOREIGN KEY (PhotographerId) REFERENCES Photographers(PhotographerId)
);

/*============ 4. PACKAGES (الباقات التي يقدمها المصور) ============= */
CREATE TABLE Packages (
    PackageId INT PRIMARY KEY IDENTITY(1,1),
    PhotographerId INT NOT NULL,
    PackageName NVARCHAR(150) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10,2) NOT NULL,
    DurationHours INT,
    IsFeatured BIT DEFAULT 0, -- هل الباقة مميزة؟
    
    FOREIGN KEY (PhotographerId) REFERENCES Photographers(PhotographerId)
);

/*============ 5. BOOKINGS (الحجوزات) ============= */
CREATE TABLE Bookings (
    BookingId INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT NOT NULL, -- UserId الخاص بالزبون
    PhotographerId INT NOT NULL,
    PackageId INT NOT NULL,
    BookingDate DATE NOT NULL,
    BookingTime TIME,
    TotalPrice DECIMAL(10,2),
    Notes NVARCHAR(MAX),
    Status NVARCHAR(50) DEFAULT 'Pending', -- Pending, Confirmed, Completed, Cancelled
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (CustomerId) REFERENCES Users(UserId),
    FOREIGN KEY (PhotographerId) REFERENCES Photographers(PhotographerId),
    FOREIGN KEY (PackageId) REFERENCES Packages(PackageId)
);

/*============ 6. WALLET (المحفظة المالية) ============= */
CREATE TABLE Wallet (
    WalletId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT UNIQUE NOT NULL,
    Balance DECIMAL(10,2) DEFAULT 0.00,
    LastTransactionDate DATETIME,

    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

/*============ 7. MESSAGES (نظام المحادثة) ============= */
CREATE TABLE Messages (
    MessageId INT PRIMARY KEY IDENTITY(1,1),
    SenderId INT NOT NULL,
    ReceiverId INT NOT NULL,
    MessageBody NVARCHAR(MAX) NOT NULL,
    IsRead BIT DEFAULT 0,
    SentAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (SenderId) REFERENCES Users(UserId),
    FOREIGN KEY (ReceiverId) REFERENCES Users(UserId)
);

/*============ 8. REVIEWS (التقييمات) ============= */
CREATE TABLE Reviews (
    ReviewId INT PRIMARY KEY IDENTITY(1,1),
    BookingId INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (BookingId) REFERENCES Bookings(BookingId)
);

/*============ 9. CONTACT MESSAGES (تواصل معنا) ============= */
CREATE TABLE ContactMessages (
    MessageId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    Subject NVARCHAR(150),
    MessageContent NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

GO

/*==========================================================
                      INSERT DATA (SEEDING)
============================================================*/

-- 1. INSERT USERS
INSERT INTO Users (FullName, Email, PasswordHash, Role)
VALUES
('Aya Admin', 'admin@snapjo.com', 'hash123', 'Admin'),
('Khalid Ahmad', 'khalid@gmail.com', 'hash456', 'Photographer'),
('Sara Ali', 'sara@gmail.com', 'hash789', 'Photographer'),
('Omar Client', 'omar@gmail.com', 'hash321', 'Customer');

-- 2. INSERT PHOTOGRAPHERS
INSERT INTO Photographers (UserId, Specialty, Bio, Location, YearsOfExperience, ProfileImageUrl)
VALUES
(2, N'بورتريه وتصوير منتجات', N'مصور محترف من إربد مهتم بالتفاصيل.', N'إربد', 5, '/images/khalid.jpg'),
(3, N'أعراس ومناسبات', N'أصنع من لحظاتكم ذكرى لا تنسى.', N'عمان', 8, '/images/sara.jpg');

-- 3. INSERT PACKAGES
INSERT INTO Packages (PhotographerId, PackageName, Description, Price, DurationHours)
VALUES
(1, N'باقة التصوير الخارجي', N'جلسة تصوير لمدة ساعتين في المواقع الأثرية', 40.00, 2),
(2, N'الباقة الذهبية للأعراس', N'تغطية كاملة للحفل مع ألبوم صور فاخر', 450.00, 6);

-- 4. INSERT WALLET
INSERT INTO Wallet (UserId, Balance)
VALUES
(1, 0.00), (2, 120.00), (3, 500.00), (4, 50.00);

-- 5. INSERT BOOKINGS
INSERT INTO Bookings (CustomerId, PhotographerId, PackageId, BookingDate, TotalPrice, Status)
VALUES
(4, 1, 1, '2026-06-10', 40.00, 'Confirmed');

-- 6. INSERT MESSAGES
INSERT INTO Messages (SenderId, ReceiverId, MessageBody)
VALUES
(4, 2, N'مرحبا خالد، هل أنت متاح في شارع الجامعة يوم السبت؟');