#RSQLite Tutorial 
#https://www.datacamp.com/community/tutorials/sqlite-in-r
#CONTINBUE IN Statements That Do Not Return Tabular Results
#then see https://www.sqlitetutorial.net/ while you apply it on WES expression data

#Why use SQL (Structured Query Language)?
#SQL has some advantages over R and is compatible. Mainly, With SQL (for instance with RSQLite) you can manipulate databases, and all objects will be updated in real time. 
#Moreover, other users can work simultaneoulsy.
#It can also be faster than R

#Fernando Bueno Gutierrez

# Load the RSQLite Library
library(RSQLite)




##############################
#### Connect to a database ###
##############################
# Load the mtcars as an R data frame put the row names as a column, and print the header.
data("mtcars")
mtcars$car_names <- rownames(mtcars)
rownames(mtcars) <- c()
head(mtcars)
# Create a connection to our new database, CarsDB.db
# you can check that the .db file has been created on your working directory
conn <- dbConnect(RSQLite::SQLite(), "CarsDB.db")#where RSQLite::SQLite() is an existing DBIConnection and CarsDB.db is a database
#mtcars object is called: df_cars_32_12





#############################
### Add tables to database ##
#############################

#create a table inside the database
# Write the mtcars dataset into a table nameD mtcars_data
dbWriteTable(conn, "cars_data", mtcars)

  #CarsDB.db: database
  #mtcars: dataset
  #cars_data: a table inserted in the CarsDB.db database. In the SQL language if you want to call mtcars now you can use cars_data

# List all the tables available in the database
dbListTables(conn)

# Create toy data frames
car <- c('Camaro', 'California', 'Mustang', 'Explorer')
make <- c('Chevrolet','Ferrari','Ford','Ford')
df1 <- data.frame(car,make)
car <- c('Corolla', 'Lancer', 'Sportage', 'XE')
make <- c('Toyota','Mitsubishi','Kia','Jaguar')
df2 <- data.frame(car,make)
# Add them to a list
dfList <- list(df1,df2)
# Write a table by appending the data frames inside the list
for(k in 1:length(dfList)){
  dbWriteTable(conn,"Cars_and_Makes", dfList[[k]], append = TRUE)
}
# List all the Tables
dbListTables(conn)




##################################
#####  launch simple queries #####
##################################

### SELECT, FROM, LIMIT, WHERE, LIKE, AND, IN, AVG(), AS, GROUP BY, ORDER BY
  #SELECT: followed by colname or *. After, FROM should follow
  #FROM: followed by name of object (generally a table) within conn
  #LIMIT: followed by number of rows you want to grasp
  #WHERE: followed by column. After this, a condition should follow (i.e. LIKE) 
  #LIKE: followed by pattern in a column (M% means "starts with M"
  #AND, IN: as in R
  #AVG(): average
  #AS: followed by character, rename
  #GROUP BY: followed by column name. Divide observations based on value in variable (i.e. if AVG() is used in the same statemnet)
  #ORDER BY: followed by column name

#check that all 8 obsevations are in new table: 
dbGetQuery(conn, "SELECT * FROM Cars_and_Makes")
# Gather the first 10 rows in the cars_data table
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")
# Get the car names and horsepower of the cars with 8 cylinders
dbGetQuery(conn,"SELECT car_names, hp, cyl FROM cars_data
                 WHERE cyl = 8")
# Get the car names and horsepower starting with M that have 6 or 8 cylinders
dbGetQuery(conn,"SELECT car_names, hp, cyl FROM cars_data
                 WHERE car_names LIKE 'M%' AND cyl IN (6,8)")
# Get the average horsepower and mpg by number of cylinder groups
dbGetQuery(conn,"SELECT cyl, AVG(hp) AS 'average_hp', AVG(mpg) AS 'average_mpg' FROM cars_data
                 GROUP BY cyl
                 ORDER BY average_hp")
#Store query to do further operations with R
avg_HpCyl <- dbGetQuery(conn,"SELECT cyl, AVG(hp) AS 'average_hp'FROM cars_data
                 GROUP BY cyl
                 ORDER BY average_hp")
avg_HpCyl
class(avg_HpCyl)

### filtering with parameterized query
#select cars that have over 18 miles per gallon (mpg) and more than 6 cylinders
mpg <-  18 #Note that you could use any value previously computed with R 
cyl <- 6
Result <- dbGetQuery(conn, 'SELECT car_names, mpg, cyl FROM cars_data WHERE mpg >= ? AND cyl >= ?', params = c(mpg,cyl))
Result




########################
### Assemble queries ###
########################
# Assemble an example function that takes the SQLite database connection, a base query,
# and the parameters you want to use in the WHERE clause as a list

assembleQuery <- function(conn, mobject, search_parameters){
  
  #launches a query given a df and a list of requirements. 
  #querys of the type: "SELECT mpg,hp,wt FROM cars_data  WHERE  mpg  >= ?  AND  hp  >= ? AND  wt  >= ?"
  
  #IN: 
  #conn: SQLiteConnection, connection to data.base where mobject is located
  #mobject: object (typically a df) within conn
  #search_parameters: list, each element is one element from of the object called in base after the FROM statement
  
  #OUT: 
  #result: df, result from the query, for instance, a subset of the data
  
  mvariables=paste(names(search_parameters),collapse = ",")
  base <- paste("SELECT",mvariables,"FROM", mobject, sep=" ")
  
  parameter_names <- names(search_parameters)
  partial_queries <- ""
  # Iterate over all the parameters to assemble the query
  for(k in 1:length(parameter_names)){
    filter_k <- paste(parameter_names[k], " >= ? ")
    # If there is more than 1 parameter, add an AND statement before the parameter name and placeholder
    if(k > 1){
      filter_k <- paste("AND ", parameter_names[k], " >= ?")
    }
    partial_queries <- paste(partial_queries, filter_k)
  }
  # Paste all together into a single query using a WHERE statement
  final_paste <- paste(base, " WHERE", partial_queries)
  # Print the assembled query to show how it looks like
  print(final_paste)
  # Run the final query. I unlist the values from the search_parameters list into a vector since it is needed
  # when using various anonymous placeholders (i.e. >= ?)
  values <- unlist(search_parameters, use.names = FALSE)
  result <- dbGetQuery(conn, final_paste, params = values)
  # return the executed query
  return(result)
}

search_parameters <- list("mpg" = 16, "hp" = 150, "wt" = 2.1)
result <- assembleQuery(conn, "cars_data", search_parameters)
result



########################################################
### Statements That Do Not Return Tabular Results   ####
########################################################
#dbExecute, DELETE, INSERT INTO, VALUES

# Visualize the table before deletion
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")
# Delete the column belonging to the Mazda RX4. You will see a 1 as the output.
dbExecute(conn, "DELETE FROM cars_data WHERE car_names = 'Mazda RX4'")
# Visualize the new table after deletion
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")


# Insert the data for the Mazda RX4. This will also ouput a 1
dbExecute(conn, "INSERT INTO cars_data VALUES (21.0,6,160.0,110,3.90,2.620,16.46,0,1,4,4,'Mazda RX4')")
# See that we re-introduced the Mazda RX4 succesfully at the end
dbGetQuery(conn, "SELECT * FROM cars_data")

# Close the database connection to CarsDB
dbDisconnect(conn)





###################################
##   #dbFetch and dbHasCompleted ##
###################################
#https://db.rstudio.com/databases/sqlite/

library(DBI)
# Create an ephemeral in-memory RSQLite database
con <- dbConnect(RSQLite::SQLite(), ":memory:")

dbListTables(con)
dbWriteTable(con, "mtcars", mtcars)
dbListTables(con)
dbListFields(con, "mtcars")
dbReadTable(con, "mtcars")

# You can fetch all results:
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)

dbClearResult(res)

res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)

while(!dbHasCompleted(res)){#This method returns if the operation has completed. 
  #A SELECT query is completed if all rows have been fetched
  chunk <- dbFetch(res, n = 5)#grab only the first 5 rows
  print(nrow(chunk))
}



#################################################
### Multiple parameterised queries with dbBind###
#################################################
#https://cran.r-project.org/web/packages/RSQLite/vignettes/RSQLite.html

library(DBI)
mydb <- dbConnect(RSQLite::SQLite(), "")
dbWriteTable(mydb, "iris", iris)
rs <- dbSendQuery(mydb, 'SELECT * FROM iris WHERE "Sepal.Length" < :x')
dbBind(rs, params = list(x = 4.5))
nrow(dbFetch(rs))
dbBind(rs, params = list(x = 4))
nrow(dbFetch(rs))
dbClearResult(rs)

rs <- dbSendQuery(mydb, 'SELECT * FROM iris WHERE "Sepal.Length" = :x')
dbBind(rs, params = list(x = seq(4, 6, by = 0.1)))#dbBind: binding multiple arguments. Use always after dbSendQuery and before dfFetch
nrow(dbFetch(rs))
dbClearResult(rs)



#####################
#### statements #####
#####################
# dbSendStatement() and dbExecute() are the counterparts of dbSendQuery() and dbGetQuery() for SQL statements that do not return a tabular result
# while dbGetQuery gets the selected subste and dbSendQuery does the same but saving it into an object, dbSendStatement saves into an object the REMAINING PART of the table, and dbExecute changes directly the datatable 
dbExecute(mydb, 'DELETE FROM iris WHERE "Sepal.Length" < 8')#changes take place in the data
rs <- dbSendStatement(mydb, 'DELETE FROM iris WHERE "Sepal.Length" < :x')#save changes in an object
dbBind(rs, params = list(x = 4.5))
dbGetRowsAffected(rs)
dbClearResult(rs)



#########################
#### more on SQLite #####
#########################
#https://www.sqlitetutorial.net/
library(RSQLite)

data("mtcars")
mtcars$car_names <- rownames(mtcars)
rownames(mtcars) <- c()
head(mtcars)

conn <- dbConnect(RSQLite::SQLite(), "CarsDB.db")#where RSQLite::SQLite() is an existing DBIConnection and CarsDB.db is a database

dbGetQuery(conn, "SELECT * FROM Cars_and_Makes")

#simple operations
dbGetQuery(conn, "SELECT 10 / 5, 6 / 3")
#from this moment on, I started to work on SQLite directly (no R), to do this https://www.sqlitetutorial.net/

