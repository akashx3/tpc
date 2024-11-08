-- check connection to .101.25
select count(*)
from lineitem l ;



SELECT sum(l_extendedprice) FROM lineitem
 WHERE l_receiptdate <=  '1992-05-30'
  and  l_shipmode not in ('AIR')
limit 1000





select count(*) from (
SELECT sum(l_extendedprice) FROM lineitem
 WHERE l_receiptdate <=  '1992-05-30'
  and  l_shipmode not in ('AIR')
limit 1000
) a;








-- check connection to .74.85

SHOW PROC '/backends';
ALTER SYSTEM DROP BACKEND "10.0.130.96:9050" force;
SHOW PROC '/backends';
-- run query in  window


SHOW PROC '/backends';
ALTER SYSTEM add BACKEND "10.0.130.96:9050" ;
SHOW PROC '/backends';


 

 
