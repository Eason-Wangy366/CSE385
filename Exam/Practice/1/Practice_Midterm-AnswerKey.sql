/*
 (10 Points Each) Spend some time reviewing the last page of this exam – it describes a system by which instructors
	are related to courses and courses have TA's. Instructors create exams and exams have questions.
	Write the following queries:
*/

/*============================================================================ Q1
	Return the first 10 Instructor and Course they teach and order the list by the Instructor name and then the Course.
	Return the following columns: Instructor.Name, Course.Name and name them: InstructorName, CourseName. Do not use OFFSET
*/

	SELECT TOP(10) [InstructorName] = i.Name, [CourseName] = c.Name
	FROM Instructors i, Courses c, CourseInstructors ci
	WHERE i.InstructorID = ci.InstructorID AND ci.CourseID = c.CourseID
	ORDER BY instructorName, courseName


/*============================================================================ Q2
	Write the query that will return all the Instructors that are not assigned to a course.
	Do this without using a JOIN statement of any sort (meaning, do not use an implicit or explicit join)
	(hint: we did this in the beginning of the semester)
*/
	SELECT * 
	FROM Instructors
	WHERE InstructorID NOT IN (SELECT InstructorID FROM CourseInstructors)


/*============================================================================ Q3
	Write the explicit version to the above query
*/

	SELECT i.*
	FROM Instructors i
		LEFT JOIN CourseInstructors ci ON i.InstructorID = ci.InstructorID
	WHERE ci.CourseID IS NULL


/*============================================================================ Q4
	Write a UNION query that will return all the Instructor's name, ExamID, and the total number of 
	points the exam is worth (this is calculated from the ExamQuestions) that was given between 
	1/1/2018 and 12/31/2018 and do not add up to 100 points. Include a field called "status"
	that will show "Under" if the points are less than 100 and "Over" if the points are more than 100.
	Also, disregard exams that don't have any questions. 
*/
		SELECT i.Name, e.ExamID, [TotalPoints] = SUM(eq.Points), [Status] = 'Under'
		FROM Instructors i
			JOIN Exams e ON i.InstructorID = e.InstructorID
			JOIN ExamsQuestions eq ON e.ExamID = eq.ExamID
		WHERE e.ExamDate BETWEEN '1/1/2018' AND '12/31/2018'
		GROUP BY i.Name, e.ExamID
		HAVING SUM(eq.Points) < 100
	UNION
		SELECT i.Name, e.ExamID, [TotalPoints] = SUM(eq.Points), [Status] = 'Over'
		FROM Instructors i
			JOIN Exams e ON i.InstructorID = e.InstructorID
			JOIN ExamsQuestions eq ON e.ExamID = eq.ExamID
		WHERE e.ExamDate BETWEEN '1/1/2018' AND '12/31/2018'
		GROUP BY i.Name, e.ExamID
		HAVING SUM(eq.Points) > 100



/*============================================================================ Q5
	Write the above query using a CASE statement
*/
	SELECT	i.Name, e.ExamID, [TotalPoints] = SUM(eq.Points), 
			[Status] =
					CASE 
						WHEN SUM(eq.Points) < 100 THEN 	'Under' 
						ELSE 							'Over' 
					END	
	FROM Instructors i, Exams e, ExamsQuestions eq
	WHERE	i.InstructorID = e.InstructorID AND e.ExamID = eq.ExamID AND
			e.ExamDate BETWEEN '1/1/2018' AND '12/31/2018'
	GROUP BY i.Name, e.ExamID
	HAVING SUM(eq.Points) <> 100


/*============================================================================ Q6
	Return a list of TA's that are listed in more than 2 courses. Sort the list by the TA's name
*/
	SELECT t.TAID, Name
	FROM TAs t, CourseTAs ct
	WHERE t.TAID = ct.TAID
	GROUP BY t.TAID, Name
	HAVING COUNT(*) > 2
	ORDER BY Name


/*============================================================================ Q7
	Return a list of the number of exams by state and the average points for the exams. Order by state
*/
	SELECT i.State, [ExamCount] = COUNT(DISTINCT e.ExamID), [AvgPoints] = AVG(eq.Points)
	FROM Instructors i, Exams e, ExamsQuestions eq
	WHERE i.InstructorID = e.InstructorID AND e.ExamID = eq.ExamID
	GROUP BY i.State
	ORDER BY i.State


/*============================================================================ Q8
	Given the fact that I want to see 20 Instructors at a time write the code that will return the
	records 46-65. Return all columns and sort the list by state and then the Instructor's name.
*/
	SELECT * FROM Instructors
	ORDER BY State, Name
		OFFSET 45 ROWS
			FETCH NEXT 20 ROWS ONLY


/*============================================================================ Q9
	Return a list of Instructors and their TA's.  If they don't have a TA then the TA's name should be "TA NEEDED". 
	Note: an Instructor's TAs are defined by Instructors and TA's having the same course ID
*/
	SELECT [InstructorName] = i.Name, [TAName] = ISNULL(t.Name, 'TA Needed')
	FROM Instructors i
		JOIN CourseInstructors ci ON i.InstructorID = ci.InstructorID
		LEFT JOIN CourseTAs cta ON ci.CourseID = cta.CourseID
		LEFT JOIN TAs t ON cta.TAID = t.TAID

/*============================================================================ Q10
	Return a list of Instructor names and the TA's that proctored the Instructor's exam BUT are not their TA.
	In other words, show the list of TA's that proctored exams that they were not the TA for.
	Return the Instructor's name, the TA's name, and the ExamID. Sort the list by the TA's name
*/
	SELECT [InstructorName] = i.Name, [TAName] = t.Name, e.ExamID
	FROM Instructors i, Exams e, TAs t
	WHERE	i.InstructorID = e.InstructorID AND 
			e.TAID = t.TAID AND 
			t.TAID NOT IN (
				SELECT TAID
				FROM CourseTAs cta, CourseInstructors ci
				WHERE  ci.InstructorID = i.InstructorID AND cta.CourseID = ci.CourseID
			)
	ORDER BY TAName
 