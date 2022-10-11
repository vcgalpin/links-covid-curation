CREATE TABLE covid_data (
    subcat INT,
    weekdate TEXT,
    count INT,
    file_id INT NOT NULL,
    decision_time timestamp with time zone NOT NULL,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    PRIMARY KEY (weekdate, subcat, valid_from, valid_to, file_id)
);

CREATE TABLE csv_file (
        file_id SERIAL PRIMARY KEY,
	file_name TEXT,
	first_weekdate TEXT,
        last_weekdate TEXT,
        upload_time timestamp with time zone NOT NULL
);

CREATE TABLE week (
   "weekdate" TEXT NOT NULL,
   "file_id" INT NOT NULL,
   "all_zero" BOOL NOT NULL,
   "accepted_updates" INT NOT NULL,
   "rejected_updates" INT NOT NULL,
   "data_items" INT NOT NULL,
   "time_from" timestamp with time zone NOT NULL,
   "time_to" timestamp with time zone NOT NULL,
   PRIMARY KEY (weekdate,time_from,time_to)
);

CREATE TABLE decision (
    subcat INT,
    weekdate TEXT,
    old_value INT,
    old_file INT,
    new_value INT,
    new_file INT,
    time_uploaded timestamp with time zone NOT NULL,
    time_resolved timestamp with time zone NOT NULL,
    resolution TEXT,
    res_value INT
);

CREATE TABLE rawdata (
	data TEXT
);

CREATE TABLE category (
    cat TEXT PRIMARY KEY,
    cat_name TEXT NOT NULL
);

CREATE TABLE subcategory (
    subcat SERIAL PRIMARY KEY,
    cat TEXT NOT NULL,
    subcat_name TEXT NOT NULL
);

INSERT INTO category (cat, cat_name)
VALUES ('All','All'),
       ('Sex','Sex'),
       ('Age','Age'),
       ('AgeF','Female by age'),
       ('AgeM','Male by age'),
       ('HB','Health Board of usual residence'),
       ('CA','Council Area of usual residence'),
       ('Loc','Location of death'); 


INSERT INTO subcategory (cat, subcat_name)
VALUES ('All','All'),
       ('Sex','Female'),
       ('Sex','Male');

INSERT INTO subcategory (cat, subcat_name)
VALUES ('Age','Under 1 year'),
       ('Age','01-14'),
       ('Age','15-44'),
       ('Age','45-64'),
       ('Age','65-74'),
       ('Age','75-84'),
       ('Age','85+');

INSERT INTO subcategory (cat, subcat_name)
VALUES ('AgeF','F: Under 1 year'),
       ('AgeF','F: 01-14'),
       ('AgeF','F: 15-44'),
       ('AgeF','F: 45-64'),
       ('AgeF','F: 65-74'),
       ('AgeF','F: 75-84'),
       ('AgeF','F: 85+');

INSERT INTO subcategory (cat, subcat_name)
VALUES ('AgeM','M: Under 1 year'),
       ('AgeM','M: 01-14'),
       ('AgeM','M: 15-44'),
       ('AgeM','M: 45-64'),
       ('AgeM','M: 65-74'),
       ('AgeM','M: 75-84'),
       ('AgeM','M: 85+');

INSERT INTO subcategory (cat, subcat_name)
VALUES ('HB','Ayrshire and Arran'),
       ('HB','Borders'),
       ('HB','Dumfries and Galloway'),
       ('HB','Fife'),
       ('HB','Forth Valley'),
       ('HB','Grampian'),
       ('HB','Greater Glasgow and Clyde'),
       ('HB','Highland'),
       ('HB','Lanarkshire'),
       ('HB','Lothian'),
       ('HB','Orkney'),
       ('HB','Shetland'),
       ('HB','Tayside'),
       ('HB','Western Isles');


INSERT INTO subcategory (cat, subcat_name)
VALUES ('CA','Aberdeen City'),
       ('CA','Aberdeenshire'),
       ('CA','Angus'),
       ('CA','Argyll and Bute'),
       ('CA','City of Edinburgh'),
       ('CA','Clackmannanshire'),
       ('CA','Dumfries and Galloway'),
       ('CA','Dundee City'),
       ('CA','East Ayrshire'),
       ('CA','East Dunbartonshire'),
       ('CA','East Lothian'),
       ('CA','East Renfrewshire'),
       ('CA','Falkirk'),
       ('CA','Fife'),
       ('CA','Glasgow City'),
       ('CA','Highland'),
       ('CA','Inverclyde'),
       ('CA','Midlothian'),
       ('CA','Moray'),
       ('CA','Na h-Eileanan Siar'),
       ('CA','North Ayrshire'),
       ('CA','North Lanarkshire'),
       ('CA','Orkney Islands'),
       ('CA','Perth and Kinross'),
       ('CA','Renfrewshire'),
       ('CA','Scottish Borders'),
       ('CA','Shetland Islands'),
       ('CA','South Ayrshire'),
       ('CA','South Lanarkshire'),
       ('CA','Stirling'),
       ('CA','West Dunbartonshire'),
       ('CA','West Lothian');


INSERT INTO subcategory (cat, subcat_name)
VALUES ('Loc','Care home'),
       ('Loc','Home / Non-institution'),
       ('Loc','Hospital'),
       ('Loc','Other institution');

-- trigger: to read data from a csv file when
-- the name is entered into the cvs_file table

CREATE OR REPLACE FUNCTION read_data()
  RETURNS trigger AS
$$
BEGIN
        EXECUTE format('
         	COPY rawdata( data )
         	FROM %L ENCODING ''WIN1252'';
	',NEW.file_name);
 
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER get_data BEFORE INSERT on csv_file
	FOR EACH ROW
	EXECUTE PROCEDURE read_data();

-- trigger: to empty the week transaction time table
-- when covid_data is empty (since week is a transaction
-- time table, a delete within Links code will just add 
-- rows to the table)

CREATE OR REPLACE FUNCTION clear_weeks()
  RETURNS trigger AS
$$
BEGIN
DELETE FROM week WHERE TRUE;
RETURN OLD;
END;
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER empty_weeks BEFORE DELETE on covid_data
	FOR EACH STATEMENT
	EXECUTE PROCEDURE clear_weeks ();



