CREATE TABLE covid_data (
    subcat INT,
    weekdate TEXT,
    count INT,
    file_id INT NOT NULL,
    decision_time timestamp with time zone NOT NULL,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    PRIMARY KEY (weekdate, subcat, valid_from, valid_to, file_id),
    FOREIGN KEY (subcat) REFERENCES subcategory(subcat),
    FOREIGN KEY (weekdate) REFERENCES week(weekdate),
    FOREIGN KEY (file_id) REFERENCES csv_file(file_id)
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

CREATE TABLE category (
    cat TEXT PRIMARY KEY,
    cat_name TEXT NOT NULL
);

CREATE TABLE subcategory (
    subcat SERIAL PRIMARY KEY,
    cat TEXT NOT NULL,
    subcat_name TEXT NOT NULL
    FOREIGN KEY (cat) REFERENCES category(cat)
);