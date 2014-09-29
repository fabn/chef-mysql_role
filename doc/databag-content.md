## Databag format for users

This is the JSON structure used in databag for defining users

```json
{
   "id": "uniq_id", # not used in recipe but required for databag semantic
   "server": "db.example.org", // Single or multiple elements allowed
   "server": ["db1.example.org", "db2.example.org"], // if array the user will be created on all matching servers
   "username": "db_username", // mandatory parameter
   "password": "db_password", // mandatory, plain or hashed password
   "host": "%.example.org", // optional, default localhost
   "privileges": ["SELECT, UPDATE"], // optional, default :all
   "database_name": "db", // optional, default *, i.e. all databases
   // if given the previous grants will be given for all of these database and database parameter is ignored
   "databases": [
       "db1",
       "db2",
       "db3"
   ]
}
```