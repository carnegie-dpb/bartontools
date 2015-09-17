The database connection in these tools is set by a file called **db.properties** in your current working path
consisting of the following lines:

# DB connection properties for default database
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://PG_HOST:PG_PORT/PG_DATABASE
db.user=USERNAME
db.password=PASSWORD

(:PG_PORT may be omitted if you're using the default port 5432.)
