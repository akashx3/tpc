set GLOBAL prefer_compute_node=1;
set GLOBAL use_compute_nodes = 2 ;
SET GLOBAL enable_scan_datacache = 0;
SET GLOBAL enable_query_cache=1;
  SET  datacache_enable=1;
SET global big_query_profile_threshold = '10ms';
SET GLOBAL   enable_profile = true;
set global enable_materialized_view_rewrite=0;
set global enable_hive_metadata_cache_with_insert=1;
set global  enable_scan_datacache=1;

set global  starlet_use_star_cache = 0;




 SHOW PROC '/backends';
SHOW PROC '/compute_nodes';

ALTER SYSTEM ADD COMPUTE NODE "10.128.0.4:9050";  

 ALTER SYSTEM drop COMPUTE NODE "10.128.0.4:9050";  
 
 SHOW TRASH;
ADMIN CLEAN TRASH;


ADMIN SET FRONTEND CONFIG ("expr_children_limit" = "100000000");
ADMIN SET FRONTEND CONFIG ("parse_tokens_limit" = "3600000");



select * from customer1 where c_nationkey =1  ;
select * from information_schema.partitions_meta;
 
select c_mktsegment ,c_nationkey, SUM(c_custkey), sum(c_nationkey), count(*) from customer1_pk 
where c_acctbal > 500 and c_phone   like '%2%'
group by 1,2;

-- tpch.customer definition

select * from test;

SELECT * from audit_log al ;
ALTER TABLE `__internal_schema`.audit_log  SET ("replication_num" = "1");
ALTER TABLE `__internal_schema`.audit_log  SET ("default.replication_num" = "1");
ALTER TABLE `__internal_schema`.audit_log SET ("replication_allocation" = "tag.location.default: 1");
ALTER TABLE `__internal_schema`.audit_log  SET ("default.replication_allocation" = "tag.location.default: 1");
ALTER TABLE `__internal_schema`.audit_log  SET ("dynamic_partition.enable" = "false");
ALTER TABLE `__internal_schema`.audit_log  SET ("dynamic_partition.replication_num" = "1");

 
SELECT `lineitem`.`l_shipmode` AS `l_shipmode`, `t0`.`n_name` AS `n_name`, `t0`.`o_orderpriority` AS `o_orderpriority`, AVG(`lineitem`.`l_extendedprice`) AS `avg_l_extendedprice_ok` FROM `lineitem` INNER JOIN ( SELECT `lineitem`.`l_orderkey` AS `l_orderkey`, `nation`.`n_name` AS `n_name`, `orders`.`o_orderpriority` AS `o_orderpriority` FROM `lineitem` LEFT JOIN `orders` ON (`lineitem`.`l_orderkey` = `orders`.`o_orderkey`) LEFT JOIN `customer` ON (`orders`.`o_custkey` = `customer`.`c_custkey`) LEFT JOIN `nation` ON (`customer`.`c_nationkey` = `nation`.`n_nationkey`) GROUP BY 1, 2, 3 ) `t0` ON (`lineitem`.`l_orderkey` <=> `t0`.`l_orderkey`) WHERE ((`lineitem`.`l_shipdate` >= DATE('1992-01-02')) AND (`lineitem`.`l_shipdate` <= DATE('1998-12-01'))) GROUP BY 1, 2, 3;

SELECT  l_shipdate ,
  AVG( l_extendedprice)  ;
 
FROM  lineitem l 
GROUP BY 1 ;

DELETE audit_log;

 -- `__internal_schema`.audit_log definition
CREATE TABLE `audit_log` (
  `query_id` VARCHAR(48) NULL,
  `time` DATETIME(3) NULL,
  `client_ip` VARCHAR(128) NULL,
  `user` VARCHAR(128) NULL,
  `catalog` VARCHAR(128) NULL,
  `db` VARCHAR(128) NULL,
  `state` VARCHAR(128) NULL,
  `error_code` INT NULL,
  `error_message` TEXT NULL,
  `query_time` BIGINT NULL,
  `scan_bytes` BIGINT NULL,
  `scan_rows` BIGINT NULL,
  `return_rows` BIGINT NULL,
  `stmt_id` BIGINT NULL,
  `is_query` TINYINT NULL,
  `frontend_ip` VARCHAR(128) NULL,
  `cpu_time_ms` BIGINT NULL,
  `sql_hash` VARCHAR(128) NULL,
  `sql_digest` VARCHAR(128) NULL,
  `peak_memory_bytes` BIGINT NULL,
  `workload_group` TEXT NULL,
  `stmt` TEXT NULL
) ENGINE=OLAP
DUPLICATE KEY(`query_id`, `time`, `client_ip`)
COMMENT 'Doris internal audit table, DO NOT MODIFY IT'
DISTRIBUTED BY HASH(`query_id`) BUCKETS 2
PROPERTIES (
"replication_allocation" = "tag.location.default: 1",
"min_load_replica_num" = "-1",
"is_being_synced" = "false",
"storage_medium" = "hdd",
"storage_format" = "V2",
"inverted_index_storage_format" = "V1",
"light_schema_change" = "true",
"disable_auto_compaction" = "false",
"enable_single_replica_compaction" = "false",
"group_commit_interval_ms" = "10000",
"group_commit_data_bytes" = "134217728"
);

SELECT count(*) FROM lineitem
WHERE l_shipdate <=  '1993-04-30' limit 1000;

SELECT count(*) FROM lineitem
WHERE l_receiptdate <=  '1992-05-30' and
l_shipmode in ('AIR') limit 1000;

SELECT  sum(l_extendedprice) FROM lineitem
WHERE l_receiptdate >=  '1992-05-30' and
l_shipmode   in ('AIR')
limit 1000;

SELECT  sum(l_extendedprice) FROM lineitem
WHERE l_receiptdate >=  '1992-05-30' and
l_shipmode not in ('AIR')
limit 1000;

SELECT sum(l_extendedprice) FROM lineitem
WHERE l_receiptdate <=  '1992-05-30' and
l_shipmode not in ('AIR')
limit 1000;

SELECT sum(l_extendedprice) FROM lineitem
WHERE l_receiptdate <=  '1992-05-30' 
and l_shipmode  in ('AIR')
limit 1000 ;
------------------------------------
SELECT sum(l_extendedprice) FROM lineitem
WHERE l_shipmode  in ('AIR')
limit 1000;

SELECT sum(l_extendedprice) FROM lineitem
WHERE l_shipmode not in ('AIR')
limit 1000;


SELECT `lineitem`.`l_shipmode` AS `l_shipmode`, `t0`.`n_name` AS `n_name`, `t0`.`o_orderpriority` AS `o_orderpriority`,
SUM(`lineitem`.`l_extendedprice`) AS `sum_l_extendedprice_ok` FROM `lineitem`
INNER JOIN ( SELECT `lineitem`.`l_orderkey` AS `l_orderkey`, `nation`.`n_name` AS `n_name`, `orders`.
`o_orderpriority` AS `o_orderpriority` 
FROM `lineitem` LEFT JOIN `orders` ON (`lineitem`.`l_orderkey` = `orders`.`o_orderkey`) 
LEFT JOIN `customer` ON (`orders`.`o_custkey` = `customer`.`c_custkey`)
LEFT JOIN `nation` ON (`customer`.`c_nationkey` = `nation`.`n_nationkey`) 
GROUP BY 1, 2, 3 ) `t0` ON (`lineitem`.`l_orderkey` <=> `t0`.`l_orderkey`) 
-- WHERE ((`lineitem`.`l_shipdate` >= DATE('1992-01-02')) AND (`lineitem`.`l_shipdate` <= DATE('1998-12-01'))
 GROUP BY 1, 2, 3


EXPORT TABLE tpch.nation
TO "/root"
PROPERTIES
(
    "column_separator"=",",
    "load_mem_limit"="2147483648",
    "timeout" = "300"
)
;

CREATE ROLE public_sales;
GRANT SELECT ON ALL TABLES IN DATABASE tpch TO ROLE public_sales;
CREATE USER fabi IDENTIFIED BY 'tester' DEFAULT ROLE 'public_sales';

--Q21
select count(*) from (
select s_name, count(*) as numwait
from  supplier,  lineitem l1,  orders,  nation
where
  s_suppkey = l1.l_suppkey
  and o_orderkey = l1.l_orderkey
  and o_orderstatus = 'F'
  and l1.l_receiptdate > l1.l_commitdate
  and exists (
    select * from  lineitem l2
    where
      l2.l_orderkey = l1.l_orderkey
      and l2.l_suppkey <> l1.l_suppkey
  )
  and not exists (
    select * from  lineitem l3
    where
      l3.l_orderkey = l1.l_orderkey
      and l3.l_suppkey <> l1.l_suppkey
      and l3.l_receiptdate > l3.l_commitdate
  )
  and s_nationkey = n_nationkey
  and n_name = 'SAUDI ARABIA'
group by s_name
order by  numwait desc, s_name
) as t1
--Q21 tpch
;




--Q21
select count(*) from (
select s_name, count(*) as numwait
from  supplier,  lineitem l1,  orders,  nation
where
  s_suppkey = l1.l_suppkey
  and o_orderkey = l1.l_orderkey
  and o_orderstatus = 'F'
  and l1.l_receiptdate > l1.l_commitdate
  and exists (
    select * from  lineitem l2
    where
      l2.l_orderkey = l1.l_orderkey
      and l2.l_suppkey <> l1.l_suppkey
  )
  and not exists (
    select * from  lineitem l3
    where
      l3.l_orderkey = l1.l_orderkey
      and l3.l_suppkey <> l1.l_suppkey
      and l3.l_receiptdate > l3.l_commitdate
  )
  and s_nationkey = n_nationkey
  and n_name != 'SAUDI ARABIA'
group by s_name
order by  numwait desc, s_name
) as t1
--Q21 tpch
;


ANALYZE FULL TABLE customer;
ANALYZE FULL TABLE lineitem;
ANALYZE FULL TABLE nation;
ANALYZE FULL TABLE orders;
ANALYZE FULL TABLE part;
ANALYZE FULL TABLE partsupp;
ANALYZE FULL TABLE region;
ANALYZE FULL TABLE supplier;
 
SHOW CATALOGS;
set CATALOG default_catalog;
SET catalog iceberg;
show databases;
use tpch3tb;
use tpch1tb;
use tpch;
use default_catalog.tpch3tb;
show tables;

describe sample;

 

select l_orderkey ,l_linenumber , l_partkey ,
ROW_NUMBER() over 
	(partition by l_linenumber ) as nm
from lineitem l 
 where l_shipdate = date '1998-12-01'
-- and l_quantity < 10
-- and l_commitdate > '1992-02-18'
-- and l_returnflag not in ('A', 'N') -- R A
-- and l_shipmode not in ('TRUCK', 'RAIL') -- SHIP FOB 
 ;
 
select
  l_returnflag,
  l_linestatus,
  sum(l_quantity) as sum_qty,
  sum(l_extendedprice) as sum_base_price,
  sum(l_extendedprice * (1 - l_discount )) as sum_disc_price,
  sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
  avg(l_quantity) as avg_qty,
  avg(l_extendedprice) as avg_price
 , avg(l_discount) as avg_disc
 , count(*) as count_order
from lineitem
where 1=1
-- and l_shipdate <= date '1998-12-01'
 and l_quantity > 10
 and l_commitdate > '1992-02-18'
 and l_returnflag not  in ('A', 'N') -- R A
 and l_shipmode    in ('TRUCK', 'RAIL') -- SHIP FOB
 group by  l_returnflag  ,  l_linestatus
 order by  l_returnflag  ,  l_linestatus;

select count(*) from iceberg.tpch3tb.lineitem 
where l_quantity >= 46 and l_quantity <= 50
;

delete from iceberg.tpch3tb.lineitem 
where l_quantity between 46 and 50;

create table iceberg.tpch.customer 
as (select * from default_catalog.tpch.customer );

insert INTO iceberg.tpch3tb.orders  (select *
from default_catalog.tpch3tb.orders
where o_orderpriority in ('5-LOW') );



SELECT  o_orderpriority ,COUNT(*) 
from orders o 
group by o_orderpriority ;

--Q7
select supp_nation, cust_nation, l_year, sum(volume) as revenue
from (
    select
      n1.n_name as supp_nation,
      n2.n_name as cust_nation,
      extract(year from l_shipdate) as l_year,
      l_extendedprice * (
1
 - l_discount) as volume
    from supplier, lineitem, 
    	orders, 
    	customer, 
    		nation n1, nation n2
    where
      s_suppkey = l_suppkey
      and o_orderkey = l_orderkey
      and c_custkey = o_custkey
      and s_nationkey = n1.n_nationkey
      and c_nationkey = n2.n_nationkey
 
  ) as shipping
group by supp_nation, cust_nation, l_year
order by supp_nation, cust_nation, l_year
--Q7 tpch
;

select * from partsupp p ;

--Q11
 
--Q11
select count(*) from (
select ps_partkey, sum(ps_supplycost * ps_availqty) as value
from partsupp, supplier, nation
where
  ps_suppkey = s_suppkey
  and s_nationkey = n_nationkey
   and n_name = 'GERMANY'
 --  and ps_availqty > 2000
 --   and ps_supplycost > 200
group by ps_partkey 
order by value desc
) as t1
--Q11 tpch
;
;

set CATALOG default_catalog;
use iceberg.tpch3tb;
use default_catalog.tpch3tb;

SELECT distinct(o_comment) from orders o ;

select year(o_orderdate) ,  o_orderpriority, -- ,o_orderstatus
SUM(o_orderkey), sum(o_custkey),sum(o_totalprice)
from orders o 
where 1=1
-- and o_orderpriority  in ('1-URGENT')
 and o_orderstatus in ('F')
group by 1,2  ;

select year(o_orderdate) ,  o_orderpriority, -- ,o_orderstatus
SUM(o_orderkey), sum(o_custkey),sum(o_totalprice)
from orders o 
where 1=1
-- and o_orderpriority  in ('2-HIGH')
 and o_orderstatus in ( 'O')
group by 1,2  ;


-- ------------------------------------------------------------

select * from(
 SELECT 'lineitem' as table_name, count(*) as count_of_rows from lineitem 
 UNION
 SELECT 'customer' as table_name, count(*) as count_of_rows
 from customer  UNION
SELECT 'nation' as table_name, count(*) as count_of_rows
from nation 
UNION
SELECT 'orders ' as table_name, count(*) as count_of_rows
from orders  UNION
SELECT 'part ' as table_name, count(*) as count_of_rows
from part  
UNION
SELECT 'partsupp ' as table_name, count(*) as count_of_rows
from partsupp  UNION
SELECT 'region  ' as table_name, count(*) as count_of_rows
from region  
union
SELECT 'supplier  ' as table_name, count(*) as count_of_rows
from supplier s  ) as t
ORDER BY count_of_rows desc;

ANALYZE FULL TABLE customer;
ANALYZE FULL TABLE lineitem;
ANALYZE FULL TABLE nation;
ANALYZE FULL TABLE orders;
ANALYZE FULL TABLE part;
ANALYZE FULL TABLE partsupp;
ANALYZE FULL TABLE region;
ANALYZE FULL TABLE supplier;

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

 SELECT * FROM information_schema.COLUMNS 
WHERE TABLE_SCHEMA='_statistics_' ORDER BY ORDINAL_POSITION;

SET catalog hive_catalog_hms;
use tpcds100gb;
set catalog default_catalog;
use tpch;
DESCRIBE lineitem2 ;

CREATE TABLE lineitem7 (
                             l_linenumber  int not null,
                             l_partkey     int NOT NULL,
                             l_suppkey     int not null,
                             l_quantity    decimal(15, 2) NOT NULL,
                             l_extendedprice  decimal(15, 2) NOT NULL,
                             l_discount    decimal(15, 2) NOT NULL,
                             l_tax         decimal(15, 2) NOT NULL,
                             l_returnflag  VARCHAR(1) NOT NULL,
                             l_linestatus  VARCHAR(1) NOT NULL,
                             l_commitdate  DATE NOT NULL,
                             l_receiptdate DATE NOT NULL,
                             l_shipinstruct VARCHAR(25) NOT NULL,
                             l_shipmode     VARCHAR(10) NOT NULL,
                             l_comment      VARCHAR(44) NOT NULL,
                               l_shipdate    DATE NOT NULL ,l_orderkey    int NOT NULL 
                              )
ENGINE=hive 
-- DUPLICATE KEY(`l_shipdate`, `l_orderkey`)
PARTITION  BY (l_orderkey);


INSERT INTO hive_catalog_hms.tpcds100gb.lineitem7
SELECT * FROM default_catalog.tpch.lineitem   limit 1;

SWITCH iceberg_s3;
SHOW DATABASES from iceberg_s3;
use tpch;

-- explain analyze
select sum(l_orderkey), count(*) from lineitem where
l_comment like 'slyly %' or
l_comment like 'plant %' or
l_comment like 'fina %' or
l_comment like 'quick %' or
l_comment like 'slyly %' or
l_comment like 'quickly %' or
l_comment like ' %about%' or
l_comment like ' final%' or
l_comment like ' %final%' or
l_comment like ' breach%' or
l_comment like ' egular%' or
l_comment like ' %closely%' or
l_comment like ' closely%' or
l_comment like ' %idea%' or
l_comment like ' idea%' ; 

CREATE table tpch_100gb.nation as select * from tpch.nation;

drop table nation;
--Q1
select
  l_returnflag,
  l_linestatus,
  sum(l_quantity) as sum_qty,
  sum(l_extendedprice) as sum_base_price,
  sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
  sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
  avg(l_quantity) as avg_qty,
  avg(l_extendedprice) as avg_price,
  avg(l_discount) as avg_disc,
  count(*) as count_order
from lineitem
where  l_shipdate <= date '1998-12-01'
group by  l_returnflag,  l_linestatus
order by  l_returnflag,  l_linestatus
--Q1 tpch
;

-- Q2 

select count(*) from (
select  s_acctbal, s_name,  n_name,  p_partkey,  p_mfgr,  s_address,  s_phone,  s_comment
from  part,  partsupp,  supplier,  nation,  region
where
  p_partkey = ps_partkey
  and s_suppkey = ps_suppkey
  and p_size = 15	
  and p_type like '%BRASS'
  and s_nationkey = n_nationkey
  and n_regionkey = r_regionkey
  and r_name = 'EUROPE'
  and ps_supplycost = (
    select  min(ps_supplycost)
    from  partsupp,  supplier,  nation,  region
    where
      p_partkey = ps_partkey
      and s_suppkey = ps_suppkey
      and s_nationkey = n_nationkey
      and n_regionkey = r_regionkey
      and r_name = 'EUROPE'
  )
order by  s_acctbal desc, n_name,  s_name,  p_partkey
) as t1
--Q2 tpch
;

--Q3 
select count(*) 
from (
    select
      l_orderkey, sum(l_extendedprice * ( 1  - l_discount)) as revenue, o_orderdate, o_shippriority
    from customer, orders, lineitem
    where c_mktsegment = 'BUILDING'
      and c_custkey = o_custkey
      and l_orderkey = o_orderkey
      and o_orderdate < date '1995-03-15'
      and l_shipdate > date '1995-03-15'
    group by l_orderkey, o_orderdate, o_shippriority
    order by revenue desc, o_orderdate
    ) as t1
   --Q3 tpch; 
    ;

--Q4
select  o_orderpriority,  count(*) as order_count
from  orders
where
  o_orderdate >= date '1993-07-01'
  and o_orderdate < date '1993-10-01' -- + interval '3' month
  and exists (
    select  * from  lineitem
    where  l_orderkey = o_orderkey and l_commitdate < l_receiptdate
  )
group by o_orderpriority
order by o_orderpriority
--Q4 tpch
;

--Q5 
   
select n_name, sum(l_extendedprice * (
1
 - l_discount)) as revenue
from customer, orders, lineitem, supplier, nation, region
where
  c_custkey = o_custkey
  and l_orderkey = o_orderkey
  and l_suppkey = s_suppkey
  and c_nationkey = s_nationkey
  and s_nationkey = n_nationkey
  and n_regionkey = r_regionkey
  and r_name = 'ASIA'
  and o_orderdate >= date '1994-01-01'
  and o_orderdate < date '1995-01-01' -- + interval '1' year
group by n_name
order by revenue desc
--Q5 tpch
;


select
  sum(l_extendedprice * l_discount) as revenue
from   lineitem
where
  l_shipdate >= date '1994-01-01'
  and l_shipdate < date '1995-01-01' -- + interval '1' year
  and l_discount between .06 - 0.01 and .06 + 0.01
  and l_quantity < 24
--Q6 tpch
;

--Q7
select supp_nation, cust_nation, l_year, sum(volume) as revenue
from (
    select
      n1.n_name as supp_nation,
      n2.n_name as cust_nation,
      extract(year from l_shipdate) as l_year,
      l_extendedprice * (1 - l_discount) as volume
    from supplier, lineitem, orders, customer, nation n1, nation n2
    where
      s_suppkey = l_suppkey
      and o_orderkey = l_orderkey
      and c_custkey = o_custkey
      and s_nationkey = n1.n_nationkey
      and c_nationkey = n2.n_nationkey
      and (
        (n1.n_name = 'FRANCE' and n2.n_name = 'GERMANY')
        or (n1.n_name = 'GERMANY' and n2.n_name = 'FRANCE')
      )
      and l_shipdate between date '1995-01-01' and date '1996-12-31'
  ) as shipping
group by supp_nation, cust_nation, l_year
order by supp_nation, cust_nation, l_year
--Q7 tpch
;

--Q8
select
  o_year, sum(case when nation = 'BRAZIL' then volume else 0 end) / sum(volume) as mkt_share
from
  (
    select
      extract(year from o_orderdate) as o_year,
      l_extendedprice * (1 - l_discount) as volume,
      n2.n_name as nation
    from part, supplier, lineitem, orders, customer, nation n1, nation n2, region
    where
      p_partkey = l_partkey
      and s_suppkey = l_suppkey
      and l_orderkey = o_orderkey
      and o_custkey = c_custkey
      and c_nationkey = n1.n_nationkey
      and n1.n_regionkey = r_regionkey
      and r_name = 'AMERICA'
      and s_nationkey = n2.n_nationkey
      and o_orderdate between date '1995-01-01' and date '1996-12-31'
      and p_type = 'ECONOMY ANODIZED STEEL'
  ) as all_nations
group by o_year
order by o_year
--Q8 tpch
;

--Q9
select count(*) from (
select nation, o_year, sum(amount) as sum_profit
from
  (   select
      n_name as nation,
      extract(year from o_orderdate) as o_year,
      l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount
    from part, supplier, lineitem, partsupp, orders, nation
    where
      s_suppkey = l_suppkey
      and ps_suppkey = l_suppkey
      and ps_partkey = l_partkey
      and p_partkey = l_partkey
      and o_orderkey = l_orderkey
      and s_nationkey = n_nationkey
      and p_name like '%green%'
  ) as profit
group by nation, o_year
order by nation, o_year desc
) as t1
--Q9 tpch
;

--Q10
select count(*) 
from (
select c_custkey, c_name, sum(l_extendedprice * (1 - l_discount)) as revenue,
 c_acctbal, n_name, c_address, c_phone, c_comment
    from customer, orders, lineitem, nation
    where       c_custkey = o_custkey
      and l_orderkey = o_orderkey
      and o_orderdate >= date '1993-10-01'
      and o_orderdate < date '1993-12-01'
      and l_returnflag = 'R'
      and c_nationkey = n_nationkey
    group by c_custkey, c_name, c_acctbal, c_phone, n_name, c_address, c_comment
    order by revenue desc
) as t1
--Q10 tpch
;

--Q11
select count(*) from (
select ps_partkey, sum(ps_supplycost * ps_availqty) as value
from partsupp, supplier, nation
where
  ps_suppkey = s_suppkey
  and s_nationkey = n_nationkey
  and n_name = 'GERMANY'
group by ps_partkey having
    sum(ps_supplycost * ps_availqty) > (
      select sum(ps_supplycost * ps_availqty) * 0.0001000000 / 100
      from partsupp, supplier, nation
      where ps_suppkey = s_suppkey
        and s_nationkey = n_nationkey
        and n_name = 'GERMANY'
    )
order by value desc
) as t1
--Q11 tpch
;

--Q12
select   l_shipmode,   sum(case when o_orderpriority = '1-URGENT' or o_orderpriority = '2-HIGH' then 1 else 0
 end) as high_line_count,
  sum(case when o_orderpriority <> '1-URGENT' and o_orderpriority <> '2-HIGH' then 1 else 0  end) as low_line_count
from orders, lineitem
where   o_orderkey = l_orderkey
  and l_shipmode in ('MAIL', 'SHIP')
  and l_commitdate < l_receiptdate
  and l_shipdate < l_commitdate
  and l_receiptdate >= date '1994-01-01'
  and l_receiptdate < date '1995-01-01' -- +  interval '1' year
group by l_shipmode
order by l_shipmode
--Q12 tpch
;

--Q13
select  c_count,  count(*) as custdist
from (select c_custkey,count(o_orderkey) as c_count
    from customer left outer join orders on c_custkey = o_custkey and o_comment not like '%special%requests%'
    group by  c_custkey
) as c_orders
group by  c_count
order by custdist desc, c_count desc
--Q13 tpch
;

--Q14
select 100.00 * sum(case when p_type like 'PROMO%' then l_extendedprice * (1 - l_discount) else 0 end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from lineitem, part
where
  l_partkey = p_partkey
  and l_shipdate >= date '1995-09-01'
  and l_shipdate < date '1995-10-01' -- + interval '1' month
--Q14 tpch  
  ;

--Q15 
-- select s_suppkey, s_name, s_address, s_phone, total_revenue from supplier, revenue0
-- where s_suppkey = supplier_no and total_revenue = (  select max(total_revenue) from revenue0   )order by s_suppkey;

--Q16
select count(*) from (
select p_brand, p_type, p_size, count(distinct ps_suppkey) as supplier_cnt
from partsupp, part
where   p_partkey = ps_partkey
  and p_brand <> 'Brand#45'
  and p_type not like 'MEDIUM POLISHED%'
  and p_size in (49, 14, 23, 45, 19, 3, 36, 9)
  and ps_suppkey not in (    select s_suppkey from supplier where s_comment like '%Customer%Complaints%'   )
group by p_brand, p_type, p_size
order by supplier_cnt desc, p_brand, p_type, p_size
) as t1
--Q16 tpch
;

--Q17
select sum(l_extendedprice) / 7.0  as avg_yearly
from lineitem, part
where   p_partkey = l_partkey
  and p_brand = 'Brand#23'
  and p_container = 'MED BOX'
  and l_quantity < (     select 0.2 * avg(l_quantity) from lineitem where l_partkey = p_partkey  )
  --Q17 tpch
  ;

--Q18
select count(*) from (
select c_name, c_custkey, o_orderkey, o_orderdate, o_totalprice, sum(l_quantity)
from customer, orders, lineitem
where
  o_orderkey in (
    select l_orderkey from lineitem
    group by l_orderkey having
        sum(l_quantity) > 
300
  )
  and c_custkey = o_custkey
  and o_orderkey = l_orderkey
group by c_name, c_custkey, o_orderkey, o_orderdate, o_totalprice
order by o_totalprice desc, o_orderdate
) as t1
--Q18 tpch
;

--Q19
select sum(l_extendedprice* (
1
 - l_discount)) as revenue
from lineitem, part
where
  (
    p_partkey = l_partkey
    and p_brand = 'Brand#12'
    and p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
    and l_quantity >= 1
 and l_quantity <= 1 + 10
    and p_size between 1 and 5
    and l_shipmode in ('AIR', 'AIR REG')
    and l_shipinstruct = 'DELIVER IN PERSON'
  )
  or
  (
    p_partkey = l_partkey
    and p_brand = 'Brand#23'
    and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
    and l_quantity >= 10
 and l_quantity <= 10 + 10
    and p_size between 1 and 10
    and l_shipmode in ('AIR', 'AIR REG')
    and l_shipinstruct = 'DELIVER IN PERSON'
  )
  or
  (
    p_partkey = l_partkey
    and p_brand = 'Brand#34'
    and p_container in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
    and l_quantity >= 20 and l_quantity <= 20 + 10
    and p_size between 1 and 15
    and l_shipmode in ('AIR', 'AIR REG')
    and l_shipinstruct = 'DELIVER IN PERSON'
  )
 --Q19 tpch 
  ;

--Q20
select s_name, s_address
from supplier, nation
where
  s_suppkey in (
    select ps_suppkey
    from partsupp
    where
      ps_partkey in (
        select p_partkey from part
        where p_name like 'forest%'
      )
      and ps_availqty > (
        select 
0.5
 * sum(l_quantity)
        from lineitem
        where
          l_partkey = ps_partkey
          and l_suppkey = ps_suppkey
          and l_shipdate >= date '1994-01-01'
          and l_shipdate < date '1995-01-01' --  + interval '1' year
      )
  )
  and s_nationkey = n_nationkey
  and n_name = 'CANADA'
order by s_name
--Q20 tpch
;

 
--Q21
select count(*) from (
select s_name, count(*) as numwait
from  supplier,  lineitem l1,  orders,  nation
where
  s_suppkey = l1.l_suppkey
  and o_orderkey = l1.l_orderkey
  and o_orderstatus = 'F'
  and l1.l_receiptdate > l1.l_commitdate
  and exists (
    select * from  lineitem l2
    where
      l2.l_orderkey = l1.l_orderkey
      and l2.l_suppkey <> l1.l_suppkey
  )
  and not exists (
    select * from  lineitem l3
    where
      l3.l_orderkey = l1.l_orderkey
      and l3.l_suppkey <> l1.l_suppkey
      and l3.l_receiptdate > l3.l_commitdate
  )
  and s_nationkey = n_nationkey
  and n_name = 'SAUDI ARABIA'
group by s_name
order by  numwait desc, s_name
) as t1
--Q21 tpch
;


--Q22
select
  cntrycode,
  count(*) as numcust,
  sum(c_acctbal) as totacctbal
from
  (
    select substr(c_phone, 1, 2) as cntrycode,
      c_acctbal
    from customer
    where
      substr(c_phone, 1, 2) in ('13', '31', '23', '29', '30', '18', '17')
      and c_acctbal > (
        select avg(c_acctbal)
        from customer
        where c_acctbal > 0.00
          and substr(c_phone, 1, 2) in
            ('13', '31', '23', '29', '30', '18', '17')
      )
      and not exists (
        select   *
        from  orders
        where
          o_custkey = c_custkey
      )
  ) as custsale
group by
  cntrycode
order by
  cntrycode
 --Q22 tpch 
  ;
  

--        select ''

--        select ''