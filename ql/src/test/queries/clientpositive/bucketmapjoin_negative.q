set hive.strict.checks.bucketing=false;

CREATE TABLE srcbucket_mapjoin(key int, value string) CLUSTERED BY (key) INTO 2 BUCKETS STORED AS TEXTFILE;
load data local inpath '../../data/files/bmj/000000_0' INTO TABLE srcbucket_mapjoin;
load data local inpath '../../data/files/bmj/000001_0' INTO TABLE srcbucket_mapjoin;

CREATE TABLE srcbucket_mapjoin_part (key int, value string) partitioned by (ds string) CLUSTERED BY (key) INTO 3 BUCKETS STORED AS TEXTFILE;
load data local inpath '../../data/files/bmj/000000_0' INTO TABLE srcbucket_mapjoin_part partition(ds='2008-04-08');
load data local inpath '../../data/files/bmj/000001_0' INTO TABLE srcbucket_mapjoin_part partition(ds='2008-04-08');
load data local inpath '../../data/files/bmj/000002_0' INTO TABLE srcbucket_mapjoin_part partition(ds='2008-04-08');



set hive.cbo.enable=false;
set hive.optimize.bucketmapjoin = true;
create table bucketmapjoin_tmp_result (key string , value1 string, value2 string);

explain extended
insert overwrite table bucketmapjoin_tmp_result 
select /*+mapjoin(b)*/ a.key, a.value, b.value 
from srcbucket_mapjoin a join srcbucket_mapjoin_part b 
on a.key=b.key where b.ds="2008-04-08";




