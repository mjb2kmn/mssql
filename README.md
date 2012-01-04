# mssql

Command line tool for connecting to Microsoft Sql Server from Mac or Linux.

Based on [tiny_tds](https://github.com/rails-sqlserver/tiny_tds) and [freetds](http://www.freetds.org/)

## Installation

    gem install mssql

## Usage
Connect to database:

    $ mssql.rb -h host -u user -p password -d database


In the following examples I will use pubs database which is often installed by Sql Server

#### query

    pubs> use pubs
    pubs> select top 5 * from authors
    pubs> go
    
    +-------------+----------+----------+--------------+----------------------+------------+-------+-------+----------+
    | au_id       | au_lname | au_fname | phone        | address              | city       | state | zip   | contract |
    +-------------+----------+----------+--------------+----------------------+------------+-------+-------+----------+
    | 172-32-1176 | White    | Johnson  | 408 496-7223 | 10932 Bigge Rd.      | Menlo Park | CA    | 94025 | true     |
    | 213-46-8915 | Green    | Marjorie | 415 986-7020 | 309 63rd St. #411    | Oakland    | CA    | 94618 | true     |
    | 238-95-7766 | Carson   | Cheryl   | 415 548-7723 | 589 Darwin Ln.       | Berkeley   | CA    | 94705 | true     |
    | 267-41-2394 | O'Leary  | Michael  | 408 286-2428 | 22 Cleveland Av. #14 | San Jose   | CA    | 95128 | true     |
    | 274-80-9391 | Straight | Dean     | 415 834-2919 | 5420 College Av.     | Oakland    | CA    | 94609 | true     |
    +-------------+----------+----------+--------------+----------------------+------------+-------+-------+----------+
    5 rows affected
    
#### .find

 .find will list all database objects:
 
    pubs> .find
    +-----------+--------+--------------------------+
    | type      | schema | name                     |
    +-----------+--------+--------------------------+
    | table     | dbo    | authors                  |
    | table     | dbo    | discounts                |
    | table     | dbo    | employee                 |
    | table     | dbo    | jobs                     |
    | table     | dbo    | pub_info                 |
    | table     | dbo    | publishers               |
    | table     | dbo    | roysched                 |
    | table     | dbo    | sales                    |
    | table     | dbo    | stores                   |
    | table     | dbo    | sysdiagrams              |
    | table     | dbo    | titleauthor              |
    | table     | dbo    | titles                   |
    | view      | dbo    | titleview                |
    | procedure | dbo    | byroyalty                |
    | procedure | dbo    | reptq1                   |
    | procedure | dbo    | reptq2                   |
    | procedure | dbo    | reptq3                   |
    | procedure | dbo    | sp_alterdiagram          |
    | procedure | dbo    | sp_creatediagram         |
    | procedure | dbo    | sp_dropdiagram           |
    | procedure | dbo    | sp_helpdiagramdefinition |
    | procedure | dbo    | sp_helpdiagrams          |
    | procedure | dbo    | sp_renamediagram         |
    | procedure | dbo    | sp_upgraddiagrams        |
    | function  | dbo    | fn_diagramobjects        |
    +-----------+--------+--------------------------+
    25 rows affected
    
  or objects by type (tables/views/procedures/functions):
  
    pubs> .find tables
    +-------+--------+-------------+
    | type  | schema | name        |
    +-------+--------+-------------+
    | table | dbo    | authors     |
    | table | dbo    | discounts   |
    | table | dbo    | employee    |
    | table | dbo    | jobs        |
    | table | dbo    | pub_info    |
    | table | dbo    | publishers  |
    | table | dbo    | roysched    |
    | table | dbo    | sales       |
    | table | dbo    | stores      |
    | table | dbo    | sysdiagrams |
    | table | dbo    | titleauthor |
    | table | dbo    | titles      |
    +-------+--------+-------------+
    12 rows affected    
    
  
#### .explain 

  .expalin for procedures/functions/views return sql body, for tables executes sp_help [table name]

    iow> .explain reptq1
    CREATE PROCEDURE reptq1 AS
    select 
    	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
    	avg(price) as avg_price
    from titles
    where price is NOT NULL
    group by pub_id with rollup
    order by pub_id

#### .exit

  Use it to close mssql.

## ~/.mssql

 Mssql tries to read ~/.mssql config file on start up. 
 Config file is in yaml format.
 
 Example config file:
 
    alfa: &alfa
      host: alfa_host
      username: my_username
      password: my_password
      database: pubs
    beta: 
      host: beta_host
      username: domain\domain_user
      password: password
      database: Northwind
      
    default_connection:
       <<: *alfa
     
  With config file you can start mssql.rb using -c argument to specify connection:
  
    mssql.rb -c alfa
    
  If default connnection exists it will used if no arguments specified:
  
    massql.rb
    alfa> _
    

## Emacs usage
 
  I build this for use with Emacs sql-mode. Add /emacs/sql_ms.el to your init.el:
  
    (add-to-list 'load-path "~/Work/mssql/emacs/")
    (require 'sql-ms)

  Create ~/.mssql file with connections you want to use. 
  In Emacs press F12 or M-x enter-db-mode to open two buffers: \*queries\* and \*SQL\*. Write your queries in queries buffer and watch results in SQL buffer.
  
  Keybindings:
  
  * Ctrl-c c - sends region from queries to SQL buffer
  * Ctrl-c b - sends whole buffer
