-- How to read XML data in SQL and modify a table. 


/*========================================== EXAMPLE 01 ==========================================*/
	DECLARE @people XML = '
		<data>
			<people>
				<person id="1">
					<contact phone="123-456-7890" email="tryan@gmail.com" />
					<name>Tom Ryan</name>
					<age>22</age>
				</person>
				<person id="2">
					<contact phone="555-123-4567" email="jbox@gmail.com" />
					<name>Jack Box</name>
					<age>21</age>
				</person>
			</people>
		</data>
	'
	SELECT	[id]	= parent.value('@id','int'),
			[name]	= CAST(parent.query('name/text()') AS VARCHAR(30)),
			[age]	= CAST(parent.query('age/text()') AS VARCHAR(30)),
			[phone]	= child.value('@phone','varchar(30)'),
			[email] = child.value('@email','varchar(30)')
	FROM @people.nodes('data/people/person') Parent(parent)
		CROSS APPLY parent.nodes('contact') Child(child)




/*========================================== EXAMPLE 02 ==========================================*/

DROP TABLE IF EXISTS #Users;
GO

CREATE TABLE #Users (
	userId			INT				PRIMARY KEY		IDENTITY,
	fName			VARCHAR(30),
	lName			VARCHAR(30),
	departmentId	INT,
	badgeId			INT
)

DECLARE @xml	AS XML = 
		'
			<Data>
				<Add did="5">
					<user uid = "1"		fn = "Tom"		ln = "Ryan"			bid = "224" />
					<user uid = "2"		fn = "Cindy"	ln = "Waters"		bid = "412" />
					<user uid = "3"		fn = "Woody"	ln = "Woodpecker"	bid = "118" />
				</Add>

				<Add did="6">
					<user uid = "4"		fn = "Nin"		ln = "BoBina"		bid = "312" />
					<user uid = "5"		fn = "Bob"		ln = "Evans"		bid = "643" />
					<user uid = "6"		fn = "Rick"		ln = "Finder"		bid = "285" />
				</Add>

				<Update uid = "5">
					<field did = "10" />
					<field bid = "772" />
				</Update>

				<UpdateV2 uid = "1" 	fn = "Tommy" />
				<UpdateV2 uid = "4"		fn = "Nina"		bid = "999" />

				<Delete uid = "2" />
				<Delete uid = "5" />
				<Delete uid = "6" />
			</Data>
		'			
	
--------------------------------------------------------------------- Add
	SET IDENTITY_INSERT #Users ON;
		INSERT INTO #Users (userId,fName,lName,departmentId,badgeId)
			SELECT uid,ufn,uln,did,bid
			FROM (
				SELECT	[uid] = child.value('@uid','int'),
						[ufn] = child.value('@fn','varchar(30)'),
						[uln] = child.value('@ln','varchar(30)'),
						[did] = parent.value('@did','int'),
						[bid] = child.value('@bid','int')
				FROM @xml.nodes('Data/Add') Parent(parent)
					CROSS APPLY parent.nodes('user') Child(child)
			) tbl
			WHERE  NOT EXISTS(SELECT NULL FROM #Users WHERE badgeId = tbl.bid)
	SET IDENTITY_INSERT #Users OFF;
	
	select * from #Users


--------------------------------------------------------------------- Update
	UPDATE #Users
	SET
		 fName			= ISNULL(ufn, fName)
		,lName			= ISNULL(uln,lName)
		,departmentId	= ISNULL(did,departmentId)
		,badgeId		= ISNULL(bid,badgeId)
	FROM (
		SELECT	 [uid] = parent.value('@uid','int')
				,[ufn] = child.value('@fn','varchar(30)')
				,[uln] = child.value('@ln','varchar(30)')
				,[bid] = child.value('@bid','int')
				,[did] = child.value('@did','int')
		FROM @xml.nodes('Data/Update') Parent(parent)
			CROSS APPLY parent.nodes('field') Child(child)
	) tbl
	WHERE userId = tbl.uid

	select * from #Users


--------------------------------------------------------------------- UpdateV2
	UPDATE #Users
	SET	
		fName			= ISNULL(parent.value('@fn', 'varchar(30)'),fName),
		lName			= ISNULL(parent.value('@ln', 'varchar(30)'),lName),
		departmentId	= ISNULL(parent.value('@did', 'int'),departmentId),
		badgeId			= ISNULL(parent.value('@bid', 'int'),badgeId)
	FROM 
		@xml.nodes('/Data/UpdateV2') Parent(parent)
	WHERE 
		userId = parent.value('@uid', 'int')
	
	select * from #Users


--------------------------------------------------------------------- Delete
	DELETE FROM #Users
		FROM @xml.nodes('Data/Delete') Parent(parent)
	WHERE userId = parent.value('@uid','int')
	select * from #Users

	SELECT * FROM #Users;

----------------------- Drop the table
DROP TABLE IF EXISTS #Users
