# Installation

First, install Links using *[opam](https://opam.ocaml.org)*. This requires the OCaml 4.08.0 compiler - see **[here](https://opam.ocaml.org/doc/Usage.html#opam-switch)** for more information on how to specifiy compiler version in opam.
Since the prototype requires a *[PostgreSQL](https://www.postgresql.org)* installation, the following command is used.
```
$ opam install links-postgresql
```
For MacOS users, both opam and PostgreSQL can be installed via *[HomeBrew](https://brew.sh)*. For other installation instructions, see **[here](https://github.com/links-lang/links/blob/master/INSTALL.md)**

Second, a PostgreSQL database is created with the commands
<!-- $ psql -c "CREATE DATABASE covid-curation;" -->
```
$ createdb covid_curation
$ psql -d covid-curation -f ccSetup.sql 
```
Next, the file `config.0.9.7` is edited to replace `<username>` and `<password>` with the appropriate PostgreSQL username and password respectively. It may also be necessary to modify the PostgreSQL port from 5432, depending on the setup.
For more information about database setup, see **[points 4 to 6 here](https://github.com/links-lang/links/wiki/Database-setup)**

Once these steps are completed, the application can be run using
```
$ linx --config=config.0.9.7 ccMain.links
```
and should be accessible in a browser at http://localhost:8080/

# Use

#### Overview

This provides information about the CSV files that have been uploaded.

#### Upload

This allows for the uploading of CSV files containing the data. 
A complete path for each file is required and
files should be uploaded in release order.

During upload, values for new weeks will be automatically added to the database.
If values are found for an existing week that differs from those already stored in the database,
there will be an option to accept them, reject them or add them to a pending list

#### Pending

This will display all pending decision with the option to accept or reject.

#### Query

This provides options for displaying the data or information about changes to the data.

#### Other: Reset

This removes all uploaded data from the database.

#### Other: About

This displays some (slightly dated) information relevant to the prototype, including an overview of the translation process, an example CSV file, the database schema, example temporal queries in Links, and an outline of the MVU paradigm as used in the prototype.

