CREATE EXTERNAL TABLE IF NOT EXISTS etab(
	EmployeeID INT, FirstName STRING, LastName STRING, Date DATE, Age INT, Gender STRING, Salary INT)
	COMMENT 'Employee External Table'
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/home/cloudera/Downloads/sample.csv' INTO TABLE etab;

CREATE TABLE IF NOT EXISTS mtab(
	EmployeeID INT, FirstName STRING, LastName STRING, Date DATE, Age INT, Gender STRING, Salary INT)
	COMMENT 'Employee Table'
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/home/cloudera/Downloads/sample.csv' INTO TABLE mtab;

CREATE EXTERNAL TABLE IF NOT EXISTS eptab(
	EmployeeID INT, FirstName STRING, LastName STRING, Age INT, Gender STRING, Salary INT)
	PARTITIONED BY (Date DATE)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ',';

INSERT INTO TABLE eptab PARTITION (Date='2017-01-03')
SELECT EmployeeID, FirstName, LastName, Age, Gender, Salary FROM etab WHERE Date='2017-01-03';

INSERT INTO TABLE eptab PARTITION (Date='2015-09-01')
SELECT EmployeeID, FirstName, LastName, Age, Gender, Salary FROM etab WHERE Date='2015-09-01';

INSERT INTO TABLE eptab PARTITION (Date='2016-12-02')
SELECT EmployeeID, FirstName, LastName, Age, Gender, Salary FROM etab WHERE Date='2016-12-02';


CREATE TABLE IF NOT EXISTS mptab(
	EmployeeID INT, FirstName STRING, LastName STRING, Age INT, Gender STRING, Salary INT)
	PARTITIONED BY (Date DATE)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ',';

INSERT INTO TABLE mptab PARTITION (Date='2017-01-03')
SELECT EmployeeID, FirstName, LastName, Age, Gender, Salary FROM etab WHERE Date='2017-01-03';

INSERT INTO TABLE mptab PARTITION (Date='2015-09-01')
SELECT EmployeeID, FirstName, LastName, Age, Gender, Salary FROM etab WHERE Date='2015-09-01';

INSERT INTO TABLE mptab PARTITION (Date='2016-12-02')
SELECT EmployeeID, FirstName, LastName, Age, Gender, Salary FROM etab WHERE Date='2016-12-02';

set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

CREATE EXTERNAL TABLE IF NOT EXISTS edptab(
	EmployeeID INT, FirstName STRING, LastName STRING, Date DATE, Age INT, Salary INT)
	PARTITIONED BY (Gender STRING)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ',';

INSERT OVERWRITE TABLE edptab PARTITION (Gender)
SELECT EmployeeID, FirstName, LastName, Date, Age, Salary, Gender FROM etab;

set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

CREATE TABLE IF NOT EXISTS mdptab(
	EmployeeID INT, FirstName STRING, LastName STRING, Date DATE, Age INT, Salary INT)
	PARTITIONED BY (Gender STRING)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ',';

INSERT OVERWRITE TABLE mdptab PARTITION (Gender)
SELECT EmployeeID, FirstName, LastName, Date, Age, Salary, Gender FROM etab;