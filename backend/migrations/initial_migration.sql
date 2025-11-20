-- =====================================================
-- Database Migration: BookNest Initial Schema
-- =====================================================
-- IMPORTANT: Always use [dbo] schema in this file.
-- The migration-runner will automatically replace [dbo] with [project_booknest]
-- at runtime based on the PROJECT_ID environment variable.
-- DO NOT hardcode [project_XXX] - always use [dbo]!
-- DO NOT create schema here - migration-runner creates it programmatically.
--
-- NAMING CONVENTION (CRITICAL):
-- Use camelCase for ALL column names to align with JavaScript/TypeScript frontend
-- CORRECT: [userId], [createdAt], [firstName]
-- WRONG: [user_id], [created_at], [first_name]
-- Exception: [id] is always lowercase
-- =====================================================

-- =====================================================
-- TABLES
-- =====================================================

/**
 * @table book Brief table for storing book information
 * @multitenancy true
 * @softDelete true
 * @alias bk
 */
CREATE TABLE [dbo].[book] (
  [id] INTEGER IDENTITY(1,1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [title] NVARCHAR(200) NOT NULL,
  [author] NVARCHAR(100) NOT NULL,
  [yearPublished] INTEGER NOT NULL,
  [genre] NVARCHAR(50) NOT NULL,
  [coverImage] NVARCHAR(500) NULL,
  [isbn] VARCHAR(20) NULL,
  [pageCount] INTEGER NOT NULL,
  [synopsis] NVARCHAR(2000) NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT 0
);
GO

/**
 * @table shelf Brief table for managing book shelves and reading status
 * @multitenancy true
 * @softDelete false
 * @alias shf
 */
CREATE TABLE [dbo].[shelf] (
  [id] INTEGER IDENTITY(1,1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [idBook] INTEGER NOT NULL,
  [shelfType] TINYINT NOT NULL,
  [dateAdded] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [startDate] DATE NULL,
  [completionDate] DATE NULL,
  [currentPage] INTEGER NULL,
  [lastUpdated] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
GO

/**
 * @table review Brief table for book reviews and ratings
 * @multitenancy true
 * @softDelete true
 * @alias rev
 */
CREATE TABLE [dbo].[review] (
  [id] INTEGER IDENTITY(1,1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [idBook] INTEGER NOT NULL,
  [rating] NUMERIC(3,1) NOT NULL,
  [reviewText] NVARCHAR(MAX) NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateUpdated] DATETIME2 NULL,
  [visibility] TINYINT NOT NULL DEFAULT 1,
  [deleted] BIT NOT NULL DEFAULT 0
);
GO

/**
 * @table readingGoal Brief table for annual reading goals
 * @multitenancy true
 * @softDelete false
 * @alias rgl
 */
CREATE TABLE [dbo].[readingGoal] (
  [id] INTEGER IDENTITY(1,1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [year] INTEGER NOT NULL,
  [bookTarget] INTEGER NOT NULL,
  [pageTarget] INTEGER NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateUpdated] DATETIME2 NULL,
  [status] TINYINT NOT NULL DEFAULT 1
);
GO

-- =====================================================
-- PRIMARY KEYS
-- =====================================================

/**
 * @primaryKey pkBook
 * @keyType Object
 */
ALTER TABLE [dbo].[book]
ADD CONSTRAINT [pkBook] PRIMARY KEY CLUSTERED ([id]);
GO

/**
 * @primaryKey pkShelf
 * @keyType Object
 */
ALTER TABLE [dbo].[shelf]
ADD CONSTRAINT [pkShelf] PRIMARY KEY CLUSTERED ([id]);
GO

/**
 * @primaryKey pkReview
 * @keyType Object
 */
ALTER TABLE [dbo].[review]
ADD CONSTRAINT [pkReview] PRIMARY KEY CLUSTERED ([id]);
GO

/**
 * @primaryKey pkReadingGoal
 * @keyType Object
 */
ALTER TABLE [dbo].[readingGoal]
ADD CONSTRAINT [pkReadingGoal] PRIMARY KEY CLUSTERED ([id]);
GO

-- =====================================================
-- FOREIGN KEYS
-- =====================================================

/**
 * @foreignKey fkShelf_Book Links shelf entries to books
 * @target dbo.book
 */
ALTER TABLE [dbo].[shelf]
ADD CONSTRAINT [fkShelf_Book] FOREIGN KEY ([idBook])
REFERENCES [dbo].[book]([id]);
GO

/**
 * @foreignKey fkReview_Book Links reviews to books
 * @target dbo.book
 */
ALTER TABLE [dbo].[review]
ADD CONSTRAINT [fkReview_Book] FOREIGN KEY ([idBook])
REFERENCES [dbo].[book]([id]);
GO

-- =====================================================
-- CHECK CONSTRAINTS
-- =====================================================

/**
 * @check chkBook_YearPublished Validates publication year range
 */
ALTER TABLE [dbo].[book]
ADD CONSTRAINT [chkBook_YearPublished] CHECK ([yearPublished] BETWEEN 1000 AND YEAR(GETDATE()));
GO

/**
 * @check chkBook_PageCount Validates page count range
 */
ALTER TABLE [dbo].[book]
ADD CONSTRAINT [chkBook_PageCount] CHECK ([pageCount] BETWEEN 1 AND 10000);
GO

/**
 * @check chkShelf_ShelfType Validates shelf type values
 * @enum {1} Want to Read
 * @enum {2} Reading
 * @enum {3} Read
 */
ALTER TABLE [dbo].[shelf]
ADD CONSTRAINT [chkShelf_ShelfType] CHECK ([shelfType] BETWEEN 1 AND 3);
GO

/**
 * @check chkShelf_CurrentPage Validates current page is within book page count
 */
ALTER TABLE [dbo].[shelf]
ADD CONSTRAINT [chkShelf_CurrentPage] CHECK ([currentPage] IS NULL OR [currentPage] >= 1);
GO

/**
 * @check chkReview_Rating Validates rating range
 */
ALTER TABLE [dbo].[review]
ADD CONSTRAINT [chkReview_Rating] CHECK ([rating] BETWEEN 0.5 AND 5.0);
GO

/**
 * @check chkReview_Visibility Validates visibility values
 * @enum {1} Public
 * @enum {2} Private
 */
ALTER TABLE [dbo].[review]
ADD CONSTRAINT [chkReview_Visibility] CHECK ([visibility] BETWEEN 1 AND 2);
GO

/**
 * @check chkReadingGoal_BookTarget Validates book target range
 */
ALTER TABLE [dbo].[readingGoal]
ADD CONSTRAINT [chkReadingGoal_BookTarget] CHECK ([bookTarget] BETWEEN 1 AND 1000);
GO

/**
 * @check chkReadingGoal_PageTarget Validates page target range
 */
ALTER TABLE [dbo].[readingGoal]
ADD CONSTRAINT [chkReadingGoal_PageTarget] CHECK ([pageTarget] IS NULL OR [pageTarget] BETWEEN 1 AND 1000000);
GO

/**
 * @check chkReadingGoal_Status Validates goal status values
 * @enum {1} Active
 * @enum {2} Completed
 * @enum {3} Archived
 */
ALTER TABLE [dbo].[readingGoal]
ADD CONSTRAINT [chkReadingGoal_Status] CHECK ([status] BETWEEN 1 AND 3);
GO

-- =====================================================
-- INDEXES
-- =====================================================

/**
 * @index ixBook_Account Multi-tenancy isolation index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixBook_Account]
ON [dbo].[book]([idAccount])
WHERE [deleted] = 0;
GO

/**
 * @index ixBook_User Books by user
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixBook_User]
ON [dbo].[book]([idAccount], [idUser])
WHERE [deleted] = 0;
GO

/**
 * @index ixBook_Genre Search by genre
 * @type Search
 */
CREATE NONCLUSTERED INDEX [ixBook_Genre]
ON [dbo].[book]([idAccount], [genre])
WHERE [deleted] = 0;
GO

/**
 * @index ixShelf_Account Multi-tenancy isolation index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixShelf_Account]
ON [dbo].[shelf]([idAccount]);
GO

/**
 * @index ixShelf_User Shelves by user
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixShelf_User]
ON [dbo].[shelf]([idAccount], [idUser]);
GO

/**
 * @index ixShelf_Book Shelf entries by book
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixShelf_Book]
ON [dbo].[shelf]([idAccount], [idBook]);
GO

/**
 * @index uqShelf_UserBook Ensures one shelf per book per user
 * @type Performance
 * @unique true
 */
CREATE UNIQUE NONCLUSTERED INDEX [uqShelf_UserBook]
ON [dbo].[shelf]([idAccount], [idUser], [idBook]);
GO

/**
 * @index ixReview_Account Multi-tenancy isolation index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixReview_Account]
ON [dbo].[review]([idAccount])
WHERE [deleted] = 0;
GO

/**
 * @index ixReview_Book Reviews by book
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixReview_Book]
ON [dbo].[review]([idAccount], [idBook])
WHERE [deleted] = 0;
GO

/**
 * @index ixReview_User Reviews by user
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixReview_User]
ON [dbo].[review]([idAccount], [idUser])
WHERE [deleted] = 0;
GO

/**
 * @index ixReadingGoal_Account Multi-tenancy isolation index
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixReadingGoal_Account]
ON [dbo].[readingGoal]([idAccount]);
GO

/**
 * @index uqReadingGoal_UserYear Ensures one goal per user per year
 * @type Performance
 * @unique true
 */
CREATE UNIQUE NONCLUSTERED INDEX [uqReadingGoal_UserYear]
ON [dbo].[readingGoal]([idAccount], [idUser], [year]);
GO

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

/**
 * @summary
 * Creates a new book in the user's library
 * 
 * @procedure spBookCreate
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - POST /api/v1/internal/book
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {NVARCHAR(200)} title - Book title
 * @param {NVARCHAR(100)} author - Book author
 * @param {INT} yearPublished - Publication year
 * @param {NVARCHAR(50)} genre - Book genre
 * @param {NVARCHAR(500)} coverImage - Cover image URL (optional)
 * @param {VARCHAR(20)} isbn - ISBN code (optional)
 * @param {INT} pageCount - Number of pages
 * @param {NVARCHAR(2000)} synopsis - Book synopsis (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookCreate]
  @idAccount INTEGER,
  @idUser INTEGER,
  @title NVARCHAR(200),
  @author NVARCHAR(100),
  @yearPublished INTEGER,
  @genre NVARCHAR(50),
  @coverImage NVARCHAR(500) = NULL,
  @isbn VARCHAR(20) = NULL,
  @pageCount INTEGER,
  @synopsis NVARCHAR(2000) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Required parameter validation
   * @throw {titleRequired}
   */
  IF @title IS NULL OR LEN(@title) = 0
  BEGIN
    ;THROW 51000, 'titleRequired', 1;
  END;

  /**
   * @validation Required parameter validation
   * @throw {authorRequired}
   */
  IF @author IS NULL OR LEN(@author) = 0
  BEGIN
    ;THROW 51000, 'authorRequired', 1;
  END;

  /**
   * @validation Required parameter validation
   * @throw {genreRequired}
   */
  IF @genre IS NULL OR LEN(@genre) = 0
  BEGIN
    ;THROW 51000, 'genreRequired', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

    INSERT INTO [dbo].[book] (
      [idAccount],
      [idUser],
      [title],
      [author],
      [yearPublished],
      [genre],
      [coverImage],
      [isbn],
      [pageCount],
      [synopsis],
      [dateCreated],
      [deleted]
    )
    VALUES (
      @idAccount,
      @idUser,
      @title,
      @author,
      @yearPublished,
      @genre,
      @coverImage,
      @isbn,
      @pageCount,
      @synopsis,
      GETUTCDATE(),
      0
    );

    /**
     * @output {BookCreated, 1, 1}
     * @column {INT} id - Created book identifier
     */
    SELECT SCOPE_IDENTITY() AS [id];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Retrieves a specific book by ID
 * 
 * @procedure spBookGet
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/internal/book/:id
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} id - Book identifier
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookGet]
  @idAccount INTEGER,
  @id INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Data consistency validation
   * @throw {bookDoesntExist}
   */
  IF NOT EXISTS (
    SELECT 1
    FROM [dbo].[book] bk
    WHERE bk.[id] = @id
      AND bk.[idAccount] = @idAccount
      AND bk.[deleted] = 0
  )
  BEGIN
    ;THROW 51000, 'bookDoesntExist', 1;
  END;

  /**
   * @output {BookDetails, 1, n}
   * @column {INT} id - Book identifier
   * @column {NVARCHAR} title - Book title
   * @column {NVARCHAR} author - Book author
   * @column {INT} yearPublished - Publication year
   * @column {NVARCHAR} genre - Book genre
   * @column {NVARCHAR} coverImage - Cover image URL
   * @column {VARCHAR} isbn - ISBN code
   * @column {INT} pageCount - Number of pages
   * @column {NVARCHAR} synopsis - Book synopsis
   * @column {DATETIME2} dateCreated - Creation date
   */
  SELECT
    bk.[id],
    bk.[title],
    bk.[author],
    bk.[yearPublished],
    bk.[genre],
    bk.[coverImage],
    bk.[isbn],
    bk.[pageCount],
    bk.[synopsis],
    bk.[dateCreated]
  FROM [dbo].[book] bk
  WHERE bk.[id] = @id
    AND bk.[idAccount] = @idAccount
    AND bk.[deleted] = 0;
END;
GO

/**
 * @summary
 * Lists all books for a user with optional filtering
 * 
 * @procedure spBookList
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/internal/book
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {NVARCHAR(50)} genre - Filter by genre (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookList]
  @idAccount INTEGER,
  @idUser INTEGER,
  @genre NVARCHAR(50) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @output {BookList, n, n}
   * @column {INT} id - Book identifier
   * @column {NVARCHAR} title - Book title
   * @column {NVARCHAR} author - Book author
   * @column {INT} yearPublished - Publication year
   * @column {NVARCHAR} genre - Book genre
   * @column {NVARCHAR} coverImage - Cover image URL
   * @column {INT} pageCount - Number of pages
   * @column {DATETIME2} dateCreated - Creation date
   */
  SELECT
    bk.[id],
    bk.[title],
    bk.[author],
    bk.[yearPublished],
    bk.[genre],
    bk.[coverImage],
    bk.[pageCount],
    bk.[dateCreated]
  FROM [dbo].[book] bk
  WHERE bk.[idAccount] = @idAccount
    AND bk.[idUser] = @idUser
    AND bk.[deleted] = 0
    AND (@genre IS NULL OR bk.[genre] = @genre)
  ORDER BY bk.[dateCreated] DESC;
END;
GO

/**
 * @summary
 * Updates book information
 * 
 * @procedure spBookUpdate
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - PUT /api/v1/internal/book/:id
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} id - Book identifier
 * @param {NVARCHAR(200)} title - Book title
 * @param {NVARCHAR(100)} author - Book author
 * @param {INT} yearPublished - Publication year
 * @param {NVARCHAR(50)} genre - Book genre
 * @param {NVARCHAR(500)} coverImage - Cover image URL (optional)
 * @param {VARCHAR(20)} isbn - ISBN code (optional)
 * @param {INT} pageCount - Number of pages
 * @param {NVARCHAR(2000)} synopsis - Book synopsis (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookUpdate]
  @idAccount INTEGER,
  @id INTEGER,
  @title NVARCHAR(200),
  @author NVARCHAR(100),
  @yearPublished INTEGER,
  @genre NVARCHAR(50),
  @coverImage NVARCHAR(500) = NULL,
  @isbn VARCHAR(20) = NULL,
  @pageCount INTEGER,
  @synopsis NVARCHAR(2000) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Data consistency validation
   * @throw {bookDoesntExist}
   */
  IF NOT EXISTS (
    SELECT 1
    FROM [dbo].[book] bk
    WHERE bk.[id] = @id
      AND bk.[idAccount] = @idAccount
      AND bk.[deleted] = 0
  )
  BEGIN
    ;THROW 51000, 'bookDoesntExist', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

    UPDATE [dbo].[book]
    SET
      [title] = @title,
      [author] = @author,
      [yearPublished] = @yearPublished,
      [genre] = @genre,
      [coverImage] = @coverImage,
      [isbn] = @isbn,
      [pageCount] = @pageCount,
      [synopsis] = @synopsis
    WHERE [id] = @id
      AND [idAccount] = @idAccount;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Soft deletes a book
 * 
 * @procedure spBookDelete
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - DELETE /api/v1/internal/book/:id
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} id - Book identifier
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookDelete]
  @idAccount INTEGER,
  @id INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Data consistency validation
   * @throw {bookDoesntExist}
   */
  IF NOT EXISTS (
    SELECT 1
    FROM [dbo].[book] bk
    WHERE bk.[id] = @id
      AND bk.[idAccount] = @idAccount
      AND bk.[deleted] = 0
  )
  BEGIN
    ;THROW 51000, 'bookDoesntExist', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

    UPDATE [dbo].[book]
    SET [deleted] = 1
    WHERE [id] = @id
      AND [idAccount] = @idAccount;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Adds or updates a book's shelf status
 * 
 * @procedure spShelfUpsert
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - POST /api/v1/internal/shelf
 * - PUT /api/v1/internal/shelf/:id
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} idBook - Book identifier
 * @param {TINYINT} shelfType - Shelf type (1=Want to Read, 2=Reading, 3=Read)
 * @param {DATE} startDate - Reading start date (optional)
 * @param {DATE} completionDate - Reading completion date (optional)
 * @param {INT} currentPage - Current page number (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spShelfUpsert]
  @idAccount INTEGER,
  @idUser INTEGER,
  @idBook INTEGER,
  @shelfType TINYINT,
  @startDate DATE = NULL,
  @completionDate DATE = NULL,
  @currentPage INTEGER = NULL
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @bookPageCount INTEGER;

  /**
   * @validation Data consistency validation
   * @throw {bookDoesntExist}
   */
  SELECT @bookPageCount = bk.[pageCount]
  FROM [dbo].[book] bk
  WHERE bk.[id] = @idBook
    AND bk.[idAccount] = @idAccount
    AND bk.[deleted] = 0;

  IF @bookPageCount IS NULL
  BEGIN
    ;THROW 51000, 'bookDoesntExist', 1;
  END;

  /**
   * @validation Business rule validation
   * @throw {startDateRequired}
   */
  IF @shelfType IN (2, 3) AND @startDate IS NULL
  BEGIN
    ;THROW 51000, 'startDateRequired', 1;
  END;

  /**
   * @validation Business rule validation
   * @throw {completionDateRequired}
   */
  IF @shelfType = 3 AND @completionDate IS NULL
  BEGIN
    ;THROW 51000, 'completionDateRequired', 1;
  END;

  /**
   * @validation Business rule validation
   * @throw {currentPageRequired}
   */
  IF @shelfType = 2 AND @currentPage IS NULL
  BEGIN
    ;THROW 51000, 'currentPageRequired', 1;
  END;

  /**
   * @rule {db-shelf-read-auto-page} When moving to Read shelf, auto-update current page to total
   */
  IF @shelfType = 3
  BEGIN
    SET @currentPage = @bookPageCount;
  END;

  BEGIN TRY
    BEGIN TRAN;

    IF EXISTS (
      SELECT 1
      FROM [dbo].[shelf] shf
      WHERE shf.[idAccount] = @idAccount
        AND shf.[idUser] = @idUser
        AND shf.[idBook] = @idBook
    )
    BEGIN
      UPDATE [dbo].[shelf]
      SET
        [shelfType] = @shelfType,
        [startDate] = @startDate,
        [completionDate] = @completionDate,
        [currentPage] = @currentPage,
        [lastUpdated] = GETUTCDATE()
      WHERE [idAccount] = @idAccount
        AND [idUser] = @idUser
        AND [idBook] = @idBook;
    END
    ELSE
    BEGIN
      INSERT INTO [dbo].[shelf] (
        [idAccount],
        [idUser],
        [idBook],
        [shelfType],
        [dateAdded],
        [startDate],
        [completionDate],
        [currentPage],
        [lastUpdated]
      )
      VALUES (
        @idAccount,
        @idUser,
        @idBook,
        @shelfType,
        GETUTCDATE(),
        @startDate,
        @completionDate,
        @currentPage,
        GETUTCDATE()
      );
    END;

    /**
     * @output {ShelfUpdated, 1, 1}
     * @column {INT} id - Shelf entry identifier
     */
    SELECT [id]
    FROM [dbo].[shelf]
    WHERE [idAccount] = @idAccount
      AND [idUser] = @idUser
      AND [idBook] = @idBook;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Lists books on a specific shelf for a user
 * 
 * @procedure spShelfList
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/internal/shelf
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {TINYINT} shelfType - Filter by shelf type (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spShelfList]
  @idAccount INTEGER,
  @idUser INTEGER,
  @shelfType TINYINT = NULL
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @output {ShelfList, n, n}
   * @column {INT} id - Shelf entry identifier
   * @column {INT} idBook - Book identifier
   * @column {NVARCHAR} title - Book title
   * @column {NVARCHAR} author - Book author
   * @column {NVARCHAR} genre - Book genre
   * @column {NVARCHAR} coverImage - Cover image URL
   * @column {INT} pageCount - Total pages
   * @column {TINYINT} shelfType - Shelf type
   * @column {DATE} startDate - Reading start date
   * @column {DATE} completionDate - Reading completion date
   * @column {INT} currentPage - Current page
   * @column {NUMERIC} progressPercent - Reading progress percentage
   * @column {DATETIME2} dateAdded - Date added to shelf
   */
  SELECT
    shf.[id],
    bk.[id] AS [idBook],
    bk.[title],
    bk.[author],
    bk.[genre],
    bk.[coverImage],
    bk.[pageCount],
    shf.[shelfType],
    shf.[startDate],
    shf.[completionDate],
    shf.[currentPage],
    CASE
      WHEN shf.[currentPage] IS NOT NULL AND bk.[pageCount] > 0
      THEN CAST(shf.[currentPage] AS NUMERIC(5,2)) / bk.[pageCount] * 100
      ELSE 0
    END AS [progressPercent],
    shf.[dateAdded]
  FROM [dbo].[shelf] shf
    JOIN [dbo].[book] bk ON (bk.[idAccount] = shf.[idAccount] AND bk.[id] = shf.[idBook])
  WHERE shf.[idAccount] = @idAccount
    AND shf.[idUser] = @idUser
    AND bk.[deleted] = 0
    AND (@shelfType IS NULL OR shf.[shelfType] = @shelfType)
  ORDER BY shf.[lastUpdated] DESC;
END;
GO

/**
 * @summary
 * Updates reading progress for a book
 * 
 * @procedure spShelfUpdateProgress
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - PATCH /api/v1/internal/shelf/:id/progress
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} idBook - Book identifier
 * @param {INT} currentPage - Current page number
 */
CREATE OR ALTER PROCEDURE [dbo].[spShelfUpdateProgress]
  @idAccount INTEGER,
  @idUser INTEGER,
  @idBook INTEGER,
  @currentPage INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @bookPageCount INTEGER;

  /**
   * @validation Data consistency validation
   * @throw {shelfEntryDoesntExist}
   */
  SELECT @bookPageCount = bk.[pageCount]
  FROM [dbo].[shelf] shf
    JOIN [dbo].[book] bk ON (bk.[idAccount] = shf.[idAccount] AND bk.[id] = shf.[idBook])
  WHERE shf.[idAccount] = @idAccount
    AND shf.[idUser] = @idUser
    AND shf.[idBook] = @idBook
    AND bk.[deleted] = 0;

  IF @bookPageCount IS NULL
  BEGIN
    ;THROW 51000, 'shelfEntryDoesntExist', 1;
  END;

  /**
   * @validation Business rule validation
   * @throw {currentPageExceedsTotal}
   */
  IF @currentPage > @bookPageCount
  BEGIN
    ;THROW 51000, 'currentPageExceedsTotal', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

    UPDATE [dbo].[shelf]
    SET
      [currentPage] = @currentPage,
      [lastUpdated] = GETUTCDATE()
    WHERE [idAccount] = @idAccount
      AND [idUser] = @idUser
      AND [idBook] = @idBook;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Creates or updates a book review
 * 
 * @procedure spReviewUpsert
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - POST /api/v1/internal/review
 * - PUT /api/v1/internal/review/:id
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} idBook - Book identifier
 * @param {NUMERIC} rating - Rating (0.5 to 5.0)
 * @param {NVARCHAR} reviewText - Review text (optional)
 * @param {TINYINT} visibility - Visibility (1=Public, 2=Private)
 */
CREATE OR ALTER PROCEDURE [dbo].[spReviewUpsert]
  @idAccount INTEGER,
  @idUser INTEGER,
  @idBook INTEGER,
  @rating NUMERIC(3,1),
  @reviewText NVARCHAR(MAX) = NULL,
  @visibility TINYINT = 1
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Data consistency validation
   * @throw {bookNotInReadShelf}
   */
  IF NOT EXISTS (
    SELECT 1
    FROM [dbo].[shelf] shf
      JOIN [dbo].[book] bk ON (bk.[idAccount] = shf.[idAccount] AND bk.[id] = shf.[idBook])
    WHERE shf.[idAccount] = @idAccount
      AND shf.[idUser] = @idUser
      AND shf.[idBook] = @idBook
      AND shf.[shelfType] = 3
      AND bk.[deleted] = 0
  )
  BEGIN
    ;THROW 51000, 'bookNotInReadShelf', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

    IF EXISTS (
      SELECT 1
      FROM [dbo].[review] rev
      WHERE rev.[idAccount] = @idAccount
        AND rev.[idUser] = @idUser
        AND rev.[idBook] = @idBook
        AND rev.[deleted] = 0
    )
    BEGIN
      UPDATE [dbo].[review]
      SET
        [rating] = @rating,
        [reviewText] = @reviewText,
        [visibility] = @visibility,
        [dateUpdated] = GETUTCDATE()
      WHERE [idAccount] = @idAccount
        AND [idUser] = @idUser
        AND [idBook] = @idBook
        AND [deleted] = 0;
    END
    ELSE
    BEGIN
      INSERT INTO [dbo].[review] (
        [idAccount],
        [idUser],
        [idBook],
        [rating],
        [reviewText],
        [dateCreated],
        [visibility],
        [deleted]
      )
      VALUES (
        @idAccount,
        @idUser,
        @idBook,
        @rating,
        @reviewText,
        GETUTCDATE(),
        @visibility,
        0
      );
    END;

    /**
     * @output {ReviewUpdated, 1, 1}
     * @column {INT} id - Review identifier
     */
    SELECT [id]
    FROM [dbo].[review]
    WHERE [idAccount] = @idAccount
      AND [idUser] = @idUser
      AND [idBook] = @idBook
      AND [deleted] = 0;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Lists reviews for a user or book
 * 
 * @procedure spReviewList
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/internal/review
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier (optional)
 * @param {INT} idBook - Book identifier (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spReviewList]
  @idAccount INTEGER,
  @idUser INTEGER = NULL,
  @idBook INTEGER = NULL
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @output {ReviewList, n, n}
   * @column {INT} id - Review identifier
   * @column {INT} idBook - Book identifier
   * @column {NVARCHAR} title - Book title
   * @column {NVARCHAR} author - Book author
   * @column {NUMERIC} rating - Rating value
   * @column {NVARCHAR} reviewText - Review text
   * @column {DATETIME2} dateCreated - Creation date
   * @column {DATETIME2} dateUpdated - Last update date
   * @column {TINYINT} visibility - Visibility setting
   */
  SELECT
    rev.[id],
    bk.[id] AS [idBook],
    bk.[title],
    bk.[author],
    rev.[rating],
    rev.[reviewText],
    rev.[dateCreated],
    rev.[dateUpdated],
    rev.[visibility]
  FROM [dbo].[review] rev
    JOIN [dbo].[book] bk ON (bk.[idAccount] = rev.[idAccount] AND bk.[id] = rev.[idBook])
  WHERE rev.[idAccount] = @idAccount
    AND rev.[deleted] = 0
    AND bk.[deleted] = 0
    AND (@idUser IS NULL OR rev.[idUser] = @idUser)
    AND (@idBook IS NULL OR rev.[idBook] = @idBook)
  ORDER BY rev.[dateCreated] DESC;
END;
GO

/**
 * @summary
 * Soft deletes a review
 * 
 * @procedure spReviewDelete
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - DELETE /api/v1/internal/review/:id
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} id - Review identifier
 */
CREATE OR ALTER PROCEDURE [dbo].[spReviewDelete]
  @idAccount INTEGER,
  @id INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Data consistency validation
   * @throw {reviewDoesntExist}
   */
  IF NOT EXISTS (
    SELECT 1
    FROM [dbo].[review] rev
    WHERE rev.[id] = @id
      AND rev.[idAccount] = @idAccount
      AND rev.[deleted] = 0
  )
  BEGIN
    ;THROW 51000, 'reviewDoesntExist', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

    UPDATE [dbo].[review]
    SET [deleted] = 1
    WHERE [id] = @id
      AND [idAccount] = @idAccount;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Creates or updates a reading goal
 * 
 * @procedure spReadingGoalUpsert
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - POST /api/v1/internal/reading-goal
 * - PUT /api/v1/internal/reading-goal/:id
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} year - Goal year
 * @param {INT} bookTarget - Book target count
 * @param {INT} pageTarget - Page target count (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spReadingGoalUpsert]
  @idAccount INTEGER,
  @idUser INTEGER,
  @year INTEGER,
  @bookTarget INTEGER,
  @pageTarget INTEGER = NULL
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Business rule validation
   * @throw {yearMustBeCurrentOrFuture}
   */
  IF @year < YEAR(GETDATE())
  BEGIN
    ;THROW 51000, 'yearMustBeCurrentOrFuture', 1;
  END;

  /**
   * @validation Business rule validation
   * @throw {yearTooFarInFuture}
   */
  IF @year > YEAR(GETDATE()) + 5
  BEGIN
    ;THROW 51000, 'yearTooFarInFuture', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

    IF EXISTS (
      SELECT 1
      FROM [dbo].[readingGoal] rgl
      WHERE rgl.[idAccount] = @idAccount
        AND rgl.[idUser] = @idUser
        AND rgl.[year] = @year
    )
    BEGIN
      UPDATE [dbo].[readingGoal]
      SET
        [bookTarget] = @bookTarget,
        [pageTarget] = @pageTarget,
        [dateUpdated] = GETUTCDATE()
      WHERE [idAccount] = @idAccount
        AND [idUser] = @idUser
        AND [year] = @year;
    END
    ELSE
    BEGIN
      INSERT INTO [dbo].[readingGoal] (
        [idAccount],
        [idUser],
        [year],
        [bookTarget],
        [pageTarget],
        [dateCreated],
        [status]
      )
      VALUES (
        @idAccount,
        @idUser,
        @year,
        @bookTarget,
        @pageTarget,
        GETUTCDATE(),
        1
      );
    END;

    /**
     * @output {GoalUpdated, 1, 1}
     * @column {INT} id - Goal identifier
     */
    SELECT [id]
    FROM [dbo].[readingGoal]
    WHERE [idAccount] = @idAccount
      AND [idUser] = @idUser
      AND [year] = @year;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Retrieves reading goal with progress for a specific year
 * 
 * @procedure spReadingGoalGet
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/internal/reading-goal/:year
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} year - Goal year
 */
CREATE OR ALTER PROCEDURE [dbo].[spReadingGoalGet]
  @idAccount INTEGER,
  @idUser INTEGER,
  @year INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @booksRead INTEGER;
  DECLARE @pagesRead INTEGER;

  /**
   * @rule {db-goal-progress-calculation} Calculate books and pages read in the specified year
   */
  SELECT
    @booksRead = COUNT(DISTINCT shf.[idBook]),
    @pagesRead = SUM(bk.[pageCount])
  FROM [dbo].[shelf] shf
    JOIN [dbo].[book] bk ON (bk.[idAccount] = shf.[idAccount] AND bk.[id] = shf.[idBook])
  WHERE shf.[idAccount] = @idAccount
    AND shf.[idUser] = @idUser
    AND shf.[shelfType] = 3
    AND YEAR(shf.[completionDate]) = @year
    AND bk.[deleted] = 0;

  SET @booksRead = ISNULL(@booksRead, 0);
  SET @pagesRead = ISNULL(@pagesRead, 0);

  /**
   * @output {GoalProgress, 1, n}
   * @column {INT} id - Goal identifier
   * @column {INT} year - Goal year
   * @column {INT} bookTarget - Book target count
   * @column {INT} pageTarget - Page target count
   * @column {INT} booksRead - Books read count
   * @column {INT} pagesRead - Pages read count
   * @column {NUMERIC} progressPercent - Progress percentage
   * @column {TINYINT} status - Goal status
   */
  SELECT
    rgl.[id],
    rgl.[year],
    rgl.[bookTarget],
    rgl.[pageTarget],
    @booksRead AS [booksRead],
    @pagesRead AS [pagesRead],
    CASE
      WHEN rgl.[bookTarget] > 0
      THEN CAST(@booksRead AS NUMERIC(5,1)) / rgl.[bookTarget] * 100
      ELSE 0
    END AS [progressPercent],
    rgl.[status]
  FROM [dbo].[readingGoal] rgl
  WHERE rgl.[idAccount] = @idAccount
    AND rgl.[idUser] = @idUser
    AND rgl.[year] = @year;
END;
GO

/**
 * @summary
 * Retrieves reading statistics for dashboard
 * 
 * @procedure spStatisticsGet
 * @schema dbo
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/internal/statistics
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} year - Year for statistics (optional, defaults to current year)
 */
CREATE OR ALTER PROCEDURE [dbo].[spStatisticsGet]
  @idAccount INTEGER,
  @idUser INTEGER,
  @year INTEGER = NULL
AS
BEGIN
  SET NOCOUNT ON;

  IF @year IS NULL
  BEGIN
    SET @year = YEAR(GETDATE());
  END;

  /**
   * @output {GeneralStats, 1, n}
   * @column {INT} totalBooksRead - Total books read in year
   * @column {INT} totalPagesRead - Total pages read in year
   * @column {NUMERIC} averageBooksPerMonth - Average books per month
   * @column {NUMERIC} averagePagesPerDay - Average pages per day
   * @column {NUMERIC} averageRating - Average rating given
   * @column {INT} averageReadingDays - Average days to complete a book
   */
  SELECT
    COUNT(DISTINCT shf.[idBook]) AS [totalBooksRead],
    SUM(bk.[pageCount]) AS [totalPagesRead],
    CAST(COUNT(DISTINCT shf.[idBook]) AS NUMERIC(5,1)) / 12 AS [averageBooksPerMonth],
    CAST(SUM(bk.[pageCount]) AS NUMERIC(8,1)) / 365 AS [averagePagesPerDay],
    AVG(rev.[rating]) AS [averageRating],
    AVG(DATEDIFF(DAY, shf.[startDate], shf.[completionDate])) AS [averageReadingDays]
  FROM [dbo].[shelf] shf
    JOIN [dbo].[book] bk ON (bk.[idAccount] = shf.[idAccount] AND bk.[id] = shf.[idBook])
    LEFT JOIN [dbo].[review] rev ON (rev.[idAccount] = shf.[idAccount] AND rev.[idBook] = shf.[idBook] AND rev.[deleted] = 0)
  WHERE shf.[idAccount] = @idAccount
    AND shf.[idUser] = @idUser
    AND shf.[shelfType] = 3
    AND YEAR(shf.[completionDate]) = @year
    AND bk.[deleted] = 0;

  /**
   * @output {TopGenres, n, n}
   * @column {NVARCHAR} genre - Genre name
   * @column {INT} bookCount - Number of books
   * @column {NUMERIC} percentage - Percentage of total
   */
  SELECT TOP 5
    bk.[genre],
    COUNT(*) AS [bookCount],
    CAST(COUNT(*) AS NUMERIC(5,1)) / NULLIF((SELECT COUNT(*) FROM [dbo].[shelf] shf2 JOIN [dbo].[book] bk2 ON (bk2.[idAccount] = shf2.[idAccount] AND bk2.[id] = shf2.[idBook]) WHERE shf2.[idAccount] = @idAccount AND shf2.[idUser] = @idUser AND shf2.[shelfType] = 3 AND YEAR(shf2.[completionDate]) = @year AND bk2.[deleted] = 0), 0) * 100 AS [percentage]
  FROM [dbo].[shelf] shf
    JOIN [dbo].[book] bk ON (bk.[idAccount] = shf.[idAccount] AND bk.[id] = shf.[idBook])
  WHERE shf.[idAccount] = @idAccount
    AND shf.[idUser] = @idUser
    AND shf.[shelfType] = 3
    AND YEAR(shf.[completionDate]) = @year
    AND bk.[deleted] = 0
  GROUP BY bk.[genre]
  ORDER BY [bookCount] DESC;

  /**
   * @output {TopAuthors, n, n}
   * @column {NVARCHAR} author - Author name
   * @column {INT} bookCount - Number of books
   * @column {NUMERIC} percentage - Percentage of total
   */
  SELECT TOP 5
    bk.[author],
    COUNT(*) AS [bookCount],
    CAST(COUNT(*) AS NUMERIC(5,1)) / NULLIF((SELECT COUNT(*) FROM [dbo].[shelf] shf2 JOIN [dbo].[book] bk2 ON (bk2.[idAccount] = shf2.[idAccount] AND bk2.[id] = shf2.[idBook]) WHERE shf2.[idAccount] = @idAccount AND shf2.[idUser] = @idUser AND shf2.[shelfType] = 3 AND YEAR(shf2.[completionDate]) = @year AND bk2.[deleted] = 0), 0) * 100 AS [percentage]
  FROM [dbo].[shelf] shf
    JOIN [dbo].[book] bk ON (bk.[idAccount] = shf.[idAccount] AND bk.[id] = shf.[idBook])
  WHERE shf.[idAccount] = @idAccount
    AND shf.[idUser] = @idUser
    AND shf.[shelfType] = 3
    AND YEAR(shf.[completionDate]) = @year
    AND bk.[deleted] = 0
  GROUP BY bk.[author]
  ORDER BY [bookCount] DESC;

  /**
   * @output {MonthlyDistribution, n, n}
   * @column {INT} month - Month number
   * @column {INT} bookCount - Books read in month
   * @column {INT} pageCount - Pages read in month
   */
  SELECT
    MONTH(shf.[completionDate]) AS [month],
    COUNT(DISTINCT shf.[idBook]) AS [bookCount],
    SUM(bk.[pageCount]) AS [pageCount]
  FROM [dbo].[shelf] shf
    JOIN [dbo].[book] bk ON (bk.[idAccount] = shf.[idAccount] AND bk.[id] = shf.[idBook])
  WHERE shf.[idAccount] = @idAccount
    AND shf.[idUser] = @idUser
    AND shf.[shelfType] = 3
    AND YEAR(shf.[completionDate]) = @year
    AND bk.[deleted] = 0
  GROUP BY MONTH(shf.[completionDate])
  ORDER BY [month];

  /**
   * @output {YearlyHistory, n, n}
   * @column {INT} year - Year
   * @column {INT} totalPages - Total pages read in year
   */
  SELECT
    YEAR(shf.[completionDate]) AS [year],
    SUM(bk.[pageCount]) AS [totalPages]
  FROM [dbo].[shelf] shf
    JOIN [dbo].[book] bk ON (bk.[idAccount] = shf.[idAccount] AND bk.[id] = shf.[idBook])
  WHERE shf.[idAccount] = @idAccount
    AND shf.[idUser] = @idUser
    AND shf.[shelfType] = 3
    AND bk.[deleted] = 0
  GROUP BY YEAR(shf.[completionDate])
  ORDER BY [year];
END;
GO