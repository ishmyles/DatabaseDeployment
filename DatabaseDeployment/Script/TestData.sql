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

IF '$(LoadTestData)' = 'true'

BEGIN

DELETE FROM Student;
DELETE FROM Book;
DELETE FROM Author;

INSERT INTO Student(StudentID, FirstName, Surname, Email, Mobile) VALUES
('s12345678', 'Fred', 'Flintstone', '12345678@student@swin.edu.au', 0400555111),
('s23456789', 'Barney', 'Rubble', '23456789@student@swin.edu.au', 0400555222),
('s34567890', 'Fred', 'Flintstone', '34567890@student@swin.edu.au', 0400555333);

INSERT INTO Author(AuthorID, AuthorName, AuthorSurname, TFN) VALUES
(32567, 'Edgar', 'Codd', '150 111 122'),
(76543, 'Vinton', 'Cerf', '150 222 333'),
(12345, 'Alan', 'Turing', '150 333 444');


INSERT INTO Book(ISBN, Title, YearPublished, AuthorID) VALUES
('978-3-16-148410-0', 'Relationships with Databases, the Ins and outs', '1970', 32567),
('978-3-16-148410-1', 'Normalisation, how to make a database geek fit in', '1970', 32567),
('978-3-16-148410-2', 'TCP/IP, the protocol for the masses', '1970', 76543),
('978-3-16-148410-3', 'The Man, the Bombe, and the Enigma', '1970', 12345);

END;