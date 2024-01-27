/* Welcome to the SQL mini project. You will carry out this project partly in the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table, columns: bookid, facid, memid, starttime, slots
    ii) the "Facilities" table, columns: facid, monthlymaintenance, name, membercost, guestcost,initialoutlay
    iii) the "Members" table, columns: memid, surname, firstname, address, zipcode, joindate, telephone, recommendedby

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
```
SELECT `name`, `facid`
FROM Facilities
WHERE `membercost` > 0 
GROUP BY `name`;
```
```
name    facid   
Massage Room 1  4   
Massage Room 2  5   
Squash Court    6   
Tennis Court 1  0   
Tennis Court 2  1   
```

/* Q2: How many facilities do not charge a fee to members? */
```
SELECT COUNT(*)
FROM `Facilities`
WHERE `membercost` = 0;
```
```
4 
```
/* Q3: Write an SQL query to show a list of facilities that charge a fee to members, where the fee is less than 20% of the facility's monthly maintenance cost. Return the facid, facility name, member cost, and monthly maintenance of the facilities in question. */

```
SELECT `facid`, `name`, `membercost`,`monthlymaintenance`
FROM Facilities
WHERE `membercost` > 0 AND `membercost` < .2 * `monthlymaintenance`;
```
```
facid   name    membercost  monthlymaintenance  
0   Tennis Court 1  5.0 200 
1   Tennis Court 2  5.0 200 
4   Massage Room 1  9.9 3000    
5   Massage Room 2  9.9 3000    
6   Squash Court    3.5 80  
```

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5. Try writing the query without using the OR operator. */
``` SELECT `facid`, `name`, `membercost` FROM `Facilities` WHERE `facid` IN (1,5);```
```
facid   name    membercost  
1   Tennis Court 2  5.0 
5   Massage Room 2  9.9 
```

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is more than $100. Return the name and monthly maintenance of the facilities
in question. */
```
SELECT `name`, `monthlymaintenance`,
CASE WHEN `monthlymaintenance` > 100 THEN 'expensive' ELSE 'cheap' END AS `category`
FROM `Facilities`
ORDER BY `monthlymaintenance` DESC;
```

```

```

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
```SELECT `surname`, `firstname` 
    FROM `Members` 
    WHERE `joindate` = (SELECT MAX(`joindate`) 
        FROM `Members`);
```
```
Smith   Darren  
```

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
```
SELECT DISTINCT CONCAT(m.`firstname`, ' ', m.`surname`) AS member_name, f.`name` AS `court_name`
FROM `Bookings` b
INNER JOIN `Facilities` f ON b.`facid` = f.`facid`
INNER JOIN `Members` m ON b.`memid` = m.`memid`
WHERE f.`name` LIKE '%tennis%' AND f.`name` NOT LIKE '%table%';
```
```
member_name court_name  
Tracy Smith Tennis Court 1  
GUEST GUEST Tennis Court 2  
GUEST GUEST Tennis Court 1  
Tim Rownam  Tennis Court 2  
Tim Rownam  Tennis Court 1  
Darren Smith    Tennis Court 2  
Janice Joplette Tennis Court 1  
Gerald Butters  Tennis Court 1  
Janice Joplette Tennis Court 2  
Tracy Smith Tennis Court 2  
Gerald Butters  Tennis Court 2  
Tim Boothe  Tennis Court 2  
Burton Tracy    Tennis Court 2  
Burton Tracy    Tennis Court 1  
Nancy Dare  Tennis Court 2  
Nancy Dare  Tennis Court 1  
Tim Boothe  Tennis Court 1  
Ponder Stibbons Tennis Court 2  
Charles Owen    Tennis Court 1  
Charles Owen    Tennis Court 2  
Anne Baker  Tennis Court 1  
David Jones Tennis Court 2  
Jack Smith  Tennis Court 1  
Anne Baker  Tennis Court 2  
David Jones Tennis Court 1  
Timothy Baker   Tennis Court 2  
Florence Bader  Tennis Court 2  
Timothy Baker   Tennis Court 1  
David Pinker    Tennis Court 1  
Jemima Farrell  Tennis Court 2  
Ponder Stibbons Tennis Court 1  
Ramnaresh Sarwin    Tennis Court 2  
Joan Coplin Tennis Court 1  
Douglas Jones   Tennis Court 1  
Ramnaresh Sarwin    Tennis Court 1  
Jack Smith  Tennis Court 2  
Jemima Farrell  Tennis Court 1  
David Farrell   Tennis Court 1  
Millicent Purview   Tennis Court 2  
Henrietta Rumney    Tennis Court 2  
Florence Bader  Tennis Court 1  
John Hunt   Tennis Court 1  
John Hunt   Tennis Court 2  
David Farrell   Tennis Court 2  
Matthew Genting Tennis Court 1  
Erica Crumpet   Tennis Court 1  
```

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
```
SELECT f.`name` AS facility_name,
       CONCAT(m.`surname`, ', ', m.`firstname`) AS member_name,
       CASE
           WHEN b.`memid` = 0 THEN `slots` * f.`guestcost`
           ELSE `slots` * f.`membercost`
       END AS cost
FROM Bookings b
INNER JOIN Facilities f ON b.`facid` = f.`facid`
LEFT JOIN Members m ON b.`memid` = m.`memid`
WHERE b.`starttime` >= '2012-09-14'
AND b.`starttime` < '2012-09-15'
      AND 
      CASE WHEN b.`memid` = 0 THEN `slots` * f.`guestcost`
      ELSE `slots` * f.`membercost`
          END > 30
ORDER BY `cost` DESC;
```
```
facility_name   member_name cost    
Massage Room 2  GUEST, GUEST    320.0   
Massage Room 1  GUEST, GUEST    160.0   
Massage Room 1  GUEST, GUEST    160.0   
Massage Room 1  GUEST, GUEST    160.0   
Tennis Court 2  GUEST, GUEST    150.0   
Tennis Court 1  GUEST, GUEST    75.0    
Tennis Court 2  GUEST, GUEST    75.0    
Tennis Court 1  GUEST, GUEST    75.0    
Squash Court    GUEST, GUEST    70.0    
Massage Room 1  Farrell, Jemima 39.6    
Squash Court    GUEST, GUEST    35.0    
Squash Court    GUEST, GUEST    35.0    
```
/* Q9: This time, produce the same result as in Q8, but using a subquery. */
```SELECT *
FROM (
    SELECT f.`name` AS facility_name,
           CONCAT(m.`surname`, ', ', m.`firstname`) AS member_name,
           CASE WHEN b.`memid` = 0 THEN f.`guestcost` * b.`slots`
            ELSE f.`membercost` * b.`slots`
           END AS cost
    FROM Bookings b
    INNER JOIN `Facilities` f ON b.`facid` = f.`facid`
    LEFT JOIN `Members` m ON b.`memid` = m.`memid`
    WHERE b.`starttime` >= '2012-09-14'
    AND b.`starttime` < '2012-09-15') AS bookings
WHERE `cost` > 30
ORDER BY `cost` DESC;
```
```
facility_name   member_name cost    
Massage Room 2  GUEST, GUEST    320.0   
Massage Room 1  GUEST, GUEST    160.0   
Massage Room 1  GUEST, GUEST    160.0   
Massage Room 1  GUEST, GUEST    160.0   
Tennis Court 2  GUEST, GUEST    150.0   
Tennis Court 2  GUEST, GUEST    75.0    
Tennis Court 1  GUEST, GUEST    75.0    
Tennis Court 1  GUEST, GUEST    75.0    
Squash Court    GUEST, GUEST    70.0    
Massage Room 1  Farrell, Jemima 39.6    
Squash Court    GUEST, GUEST    35.0    
Squash Court    GUEST, GUEST    35.0    
```

/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 
Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

