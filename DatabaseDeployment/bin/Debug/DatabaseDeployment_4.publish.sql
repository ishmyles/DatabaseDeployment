﻿/*
Deployment script for myles

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar TestData "true"
:setvar DatabaseName "myles"
:setvar DefaultFilePrefix "myles"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
PRINT N'Dropping [dbo].[FK_BOOK_AUTHOR]...';


GO
ALTER TABLE [dbo].[Book] DROP CONSTRAINT [FK_BOOK_AUTHOR];


GO
PRINT N'Starting rebuilding table [dbo].[Author]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Author] (
    [AuthorID]      INT           NOT NULL,
    [AuthorName]    NVARCHAR (15) NOT NULL,
    [AuthorSurname] NVARCHAR (15) NOT NULL,
    [TFN]           NVARCHAR (11) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_AUTHOR1] PRIMARY KEY CLUSTERED ([AuthorID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Author])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Author] ([AuthorID], [AuthorName], [AuthorSurname], [TFN])
        SELECT   [AuthorID],
                 [AuthorName],
                 [AuthorSurname],
                 [TFN]
        FROM     [dbo].[Author]
        ORDER BY [AuthorID] ASC;
    END

DROP TABLE [dbo].[Author];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Author]', N'Author';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_AUTHOR1]', N'PK_AUTHOR', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[Book]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Book] (
    [ISBN]          NVARCHAR (20) NOT NULL,
    [Title]         NVARCHAR (45) NOT NULL,
    [YearPublished] NVARCHAR (4)  NOT NULL,
    [AuthorID]      INT           NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_BOOK1] PRIMARY KEY CLUSTERED ([ISBN] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Book])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Book] ([ISBN], [Title], [YearPublished], [AuthorID])
        SELECT   [ISBN],
                 [Title],
                 [YearPublished],
                 [AuthorID]
        FROM     [dbo].[Book]
        ORDER BY [ISBN] ASC;
    END

DROP TABLE [dbo].[Book];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Book]', N'Book';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_BOOK1]', N'PK_BOOK', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[Student]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Student] (
    [StudentID] NVARCHAR (9)  NOT NULL,
    [FirstName] NVARCHAR (15) NOT NULL,
    [Surname]   NVARCHAR (15) NOT NULL,
    [Email]     NVARCHAR (30) NOT NULL,
    [Mobile]    INT           NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_STUDENT1] PRIMARY KEY CLUSTERED ([StudentID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Student])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Student] ([StudentID], [FirstName], [Surname], [Email], [Mobile])
        SELECT   [StudentID],
                 [FirstName],
                 [Surname],
                 [Email],
                 [Mobile]
        FROM     [dbo].[Student]
        ORDER BY [StudentID] ASC;
    END

DROP TABLE [dbo].[Student];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Student]', N'Student';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_STUDENT1]', N'PK_STUDENT', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_BOOK_AUTHOR]...';


GO
ALTER TABLE [dbo].[Book] WITH NOCHECK
    ADD CONSTRAINT [FK_BOOK_AUTHOR] FOREIGN KEY ([AuthorID]) REFERENCES [dbo].[Author] ([AuthorID]);


GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

IF '$(TestData)' = 'true'

BEGIN

DELETE FROM STUDENT;
DELETE FROM BOOK;
DELETE FROM AUTHOR;


INSERT INTO STUDENT (StudentID, FirstName, Surname, Email, Mobile) VALUES
('s12345678', 'Fred', 'Flintstone', '12345678@student@swin.edu.au', 0400555111),
('s23456789', 'Barney', 'Rubble', '23456789@student@swin.edu.au', 0400555222),
('s34567890', 'Fred', 'Flintstone', '34567890@student@swin.edu.au', 0400555333);

INSERT INTO AUTHOR (AuthorID, AuthorName, AuthorSurname, TFN) VALUES
(32567, 'Edgar', 'Codd', '150 111 122'),
(76543, 'Vinton', 'Cerf', '150 222 333'),
(12345, 'Alan', 'Turing', '150 333 444');

INSERT INTO BOOK (ISBN, Title, YearPublished, AuthorID) VALUES
('978-3-16-148410-0', 'Relationships with Databases, the Ins and outs', '1970', 32567),
('978-3-16-148410-1', 'Normalisation, how to make a database geek fit in', '1970', 32567),
('978-3-16-148410-2', 'TCP/IP, the protocol for the masses', '1970', 76543),
('978-3-16-148410-3', 'The Man, the Bombe, and the Enigma', '1970', 12345);

END;
GO

GO