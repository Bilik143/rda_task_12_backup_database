CREATE USER 'backup'@'%' IDENTIFIED BY 'P@ssw0rd';

-- configure minimum required permissions for performing a db backup using mysqldump: 
GRANT SELECT, LOCK TABLES, SHOW VIEW, PROCESS ON *.* TO 'backup'@'%';
GRANT EVENT ON ShopDB.* TO 'backup'@'%';

-- configure required permissions to restore a database 
GRANT ALL ON ShopDBReserve.* TO 'backup'@'%';

-- configure required permissions to restore only data
GRANT INSERT, LOCK TABLES, ALTER ON ShopDBDevelopment.* TO 'backup'@'%';

FLUSH PRIVILEGES;
