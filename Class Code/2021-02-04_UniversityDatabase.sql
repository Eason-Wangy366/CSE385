/*
	Database:	UniversityDatabase
	Author  :	Mike Stahr
	Date	:	2021-02-04
*/
--==================================================== Create Database
USE master;
GO

DROP DATABASE IF EXISTS UniversityDatabase;
GO

CREATE DATABASE UniversityDatabase;
GO

USE UniversityDatabase;
GO

--==================================================== Create Tables
CREATE TABLE tblTeachers (
	teacherId		INT			NOT NULL	PRIMARY KEY		IDENTITY,
	name			VARCHAR(30)	NOT NULL,
	email			VARCHAR(30)	NULL		DEFAULT(NULL),
	isRetired		BIT			NOT NULL	DEFAULT(0)
)
GO

CREATE TABLE tblCourses (
	courseId		INT			NOT NULL	PRIMARY KEY		IDENTITY,
	name			VARCHAR(30)	NOT NULL,
	section			CHAR(1)		NOT NULL,
	credits			INT			NOT NULL	DEFAULT(3)
)
GO

CREATE TABLE tblStudents (
	studentId		INT			NOT NULL	PRIMARY KEY		IDENTITY,
	name			VARCHAR(30)	NOT NULL,
	email			VARCHAR(30)	NULL		DEFAULT(NULL),
	yearInSchool	INT			NOT NULL	DEFAULT(1)
)
GO

CREATE TABLE tblTeacherCourses (
	teacherId		INT			NOT NULL	FOREIGN KEY	REFERENCES tblTeachers(teacherId),
	courseId		INT			NOT NULL	FOREIGN KEY	REFERENCES tblCourses(courseId),
	isActive		BIT			NOT NULL	DEFAULT(1),
	activeDate		DATE		NOT NULL,
	inActiveDate	DATE			NULL	DEFAULT(NULL),
	PRIMARY KEY	(
		teacherId, 
		courseId
	)
)
GO

CREATE TABLE tblStudentCourses (
	studentId		INT			NOT NULL	FOREIGN KEY	REFERENCES tblStudents(studentId),
	courseId		INT			NOT NULL	FOREIGN KEY	REFERENCES tblCourses(courseId),
	currentGrade	FLOAT			NULL,
	isDeleted		BIT			NOT NULL	DEFAULT(0),
	PRIMARY KEY	(
		studentId, 
		courseId
	)
)
GO
