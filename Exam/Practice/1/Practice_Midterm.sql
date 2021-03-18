/*
 (10 Points Each) Spend some time reviewing the last page of this exam – it describes a system by which instructors
	are related to courses and courses have TA's. Instructors create exams and exams have questions.
	Write the following queries:
*/

/*============================================================================ Q1
Q1:	Return the first 10 Instructor and Course they teach and order the list by the Instructor name and then the Course.
	Return the following columns: Instructor.Name, Course.Name and name them: InstructorName, CourseName. Do not use OFFSET
*/

	SELECT TOP(10) I.Name AS InstructorName, C.Name AS CourseName
	FROM Instructors I, Courses C, CourseInstructors CI
	WHERE I.InstructorID = CI.InstructorID AND C.CourseID = CI.CourseID
	ORDER BY InstructorName,CourseName



/*============================================================================ Q2
Q2:	Write the query that will return all the Instructors that are not assigned to a course.
	Do this without using a JOIN statement of any sort (meaning, do not use an implicit or explicit join)
	(hint: we did this in the beginning of the semester)
*/
	SELECT * 
	FROM Instructors
	WHERE InstructorID NOT IN (SELECT InstructorID FROM CourseInstructors)



/*============================================================================ Q3
Q3:	Write the explicit version to the above query
*/

	SELECT I.* 
	FROM Instructors I
		LEFT JOIN CourseInstructors CI ON I.InstructorID = CI.InstructorID
	WHERE CI.InstructorID IS NULL

/*============================================================================ Q4
Q4:	Write a UNION query that will return all the Instructor's name, ExamID, and the total number of 
	points the exam is worth (this is calculated from the ExamQuestions) that was given between 
	1/1/2018 and 12/31/2018 and do not add up to 100 points. Include a field called "status"
	that will show "Under" if the points are less than 100 and "Over" if the points are more than 100.
	Also, disregard exams that don't have any questions. 
*/
		SELECT	I.Name,
				E.ExamID,
				[TotalPoints] = SUM(EQ.Points),
				[Status] = 'Under'
		FROM Instructors I
			JOIN Exams E ON E.InstructorID = I.InstructorID
			JOIN ExamsQuestions EQ ON EQ.ExamID = E.ExamID
		GROUP BY I.Name,E.ExamID
		HAVING SUM(EQ.Points)<100
	UNION  
		SELECT	I.Name,
				E.ExamID,
				[TotalPoints] = SUM(EQ.Points),
				[Status] = 'Over'
		FROM Instructors I
			JOIN Exams E ON E.InstructorID = I.InstructorID
			JOIN ExamsQuestions EQ ON EQ.ExamID = E.ExamID
		GROUP BY I.Name,E.ExamID
		HAVING SUM(EQ.Points)>100
		ORDER BY I.Name

		

/*============================================================================ Q5
Q5:	Write the above query using a CASE statement
*/
		SELECT	I.Name,
				E.ExamID,
				[TotalPoints] = SUM(EQ.Points),
				[Status] =	CASE
								WHEN SUM(EQ.Points) < 100 THEN 'Under'
								ELSE 'Over'
							END 	
		FROM Instructors I
			JOIN Exams E ON E.InstructorID = I.InstructorID
			JOIN ExamsQuestions EQ ON EQ.ExamID = E.ExamID
		WHERE  EOMONTH(E.ExamDate) BETWEEN '2018-01-01' AND '2018-12-31'
		GROUP BY I.Name,E.ExamID
		HAVING SUM(EQ.Points) <> 100
		ORDER BY I.Name

		


/*============================================================================ Q6
Q6:	Return a list of TA's that are listed in more than 2 courses. Sort the list by the TA's name
*/
	SELECT T.*
	FROM TAs T
		JOIN CourseTAs CT ON CT.TAID = T.TAID
	GROUP BY T.Name,T.TAID
	HAVING COUNT(CT.CourseID)>2
	ORDER BY T.Name

/*============================================================================ Q7
Q7:	Return a list of the number of exams by state and the average points for the exams. Order by state
*/
	
	SELECT I.State,COUNT(DISTINCT E.ExamID),AVG(EQ.Points)
	FROM Instructors I
		JOIN Exams E ON E.InstructorID = I.InstructorID
		JOIN ExamsQuestions EQ ON E.ExamID = EQ.ExamID
	GROUP BY I.State
	ORDER BY I.State

/*============================================================================ Q8
Q8:	Given the fact that I want to see 20 Instructors at a time write the code that will return the
	records 46-65. Return all columns and sort the list by state and then the Instructor's name.
*/
	
	SELECT * FROM Instructors
	ORDER BY State, Name
		OFFSET 45 ROWS
			FETCH NEXT 20 ROWS ONLY


/*============================================================================ Q9
Q9:	Return a list of Instructors and their TA's.  If they don't have a TA then the TA's name should be "TA NEEDED". 
	Note: an Instructor's TAs are defined by Instructors and TA's having the same course ID
*/
	
	SELECT	I.Name AS InstructorName,
			IIF(T.Name IS NULL, 'TA NEEDED', T.Name) AS TAName
	FROM Instructors I
		JOIN CourseInstructors CI ON I.InstructorID = CI.InstructorID
		LEFT JOIN CourseTAs CT ON CI.CourseID = CT.CourseID
		LEFT JOIN TAs T ON CT.TAID = T.TAID
	

	
	

/*============================================================================ Q10
Q10:Return a list of Instructor names and the TA's that proctored the Instructor's exam BUT are not their TA.
	In other words, show the list of TA's that proctored exams that they were not the TA for.
	Return the Instructor's name, the TA's name, and the ExamID. Sort the list by the TA's name
*/



	SELECT I.Name AS InstructorName,T.Name AS TAName, E.ExamID
	FROM Instructors I, Exams E, TAs T
	WHERE	I.InstructorID = E.InstructorID AND
			E.TAID = T.TAID AND
			T.TAID NOT IN (
				SELECT TAID
				FROM CourseTAs CT, CourseInstructors CI
				WHERE CI.InstructorID = I.InstructorID AND CT.CourseID = CI.CourseID
			)
	ORDER BY T.Name