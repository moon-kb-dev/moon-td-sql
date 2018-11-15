-- MySQL 外部ホストからアクセスする
-- http://ext.omo3.com/linux/mysql_host.html

mysql -u asfeeluser -p moon_td_db

-- export DB_HOST=localhost
-- export DB_SCHEMA=moon_td_db
-- export DB_USERNAME=asfeeluser
-- export DB_PASSWORD=asfeelp@sS2

CREATE TABLE IF NOT EXISTS db_name.tbl_name
  (col_name1 data_type1, col_name2 data_type2, ...);


select name, price,
  rank() over (order by price desc) as rank_1,
  dense_rank() over (order by price desc) as rank_2
from Products;




