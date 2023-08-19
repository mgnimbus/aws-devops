# DATABASES

##






## Install sql electron to connect to the database

CREATE TABLE mytable (name VARCHAR(20), first_name VARCHAR(20)):

## Once table is created Insert table 

INSERT INTO 'mytable' ('name', 'first_name')
VALUES ('Gowtham', 'Meda')


# Aurora

## Aurora is propritary technology from AWS

### postgres and mysql are supported for Aurora 

### Aurora storage automaticaly groe in increments of 10GB upto 123TB, can have upto 15 replicas

### Failover in aurora is instantaneous, HA native 

## Aurora is AWS cloud optimizes and claims 5x performance

## costs more than normal db's as its efficient and has high peformance

## HA and Read Scaling

## 6 copies of data across 3AZ

### 4 copies out of 6 needed for writes

### 3 copies out of 6 need for reads

### self healling with peer-to-peer replicaiton

### storage is striped across 100s of volumes

## one aurora instnaces take writes(master)

## Autimated failover for master lesthan 30 sec

### Master can create max of 15 read replicas 

### support for cross region replication

# Aurora has Shared storage volume with replication ,self healing and auto expanding by little blocks with zero downtime and global

## Aurora DB cluster has 

### Writer Endpoint - pointing to the master

### Reader Endpoint - connection Load balancing (Helps in connection to replicas that have a lot of replicas)

### shared memory

### Backtrack:restore date at any point without need of backups


## RDS and Aurora sec

## Both have At-rest(KMS) and In-flight(tls) to secure the data

## only if the master has encryption enabled can the replicas also be encrypted

## If you want to encypt a un-encypted db the ypu can do so by create a snapshot and enable encypt while restoring

## IAM authentication

## SG's to contrl n/w access to you DB's

## No SSH available except on RDS custom

## Audit logs can be enabled and sent to Cloudwatch Logs forlonger retention

## RDS Proxy ( Acts as Buffer for RDS  DB instances, to mimizse the traffic going to DB Master)

### Allows apps to ppol and share DB connectionsestalblished with the database

### Improve database efficieny by reducing the steee on db resources

### severles, autoscalling,HA 

### Reduces RDS and Aurora failover time

### Enforce IAM auth for DB and scure store cred in AWS secrets MAnagesr

### RDS proxy is never publicly accessibl


## Amazon Elastic Cache

### The same way RDS is to get  managed Relational Databases

### ElasticCache is to get managed Redis or Mencached

### Elastic cache are in-memory dbes with hp, low latencey

### To read the cache date to see if the query date is available in cache before queying the data in DB instance

### Helps reduce load off databases for read intensive workload, make you app state less

### uisng elasticcache involve heavy app code changes

## Application - AWS ElacticCache - AWS RDS


### REDIS is an Multi AZ with auto failover, Read replcias and sclaed with HA,backup and resotore, supports Sets and Sorted Sets

### Memcached is a multo node for partioing of data(sharding), muti threated archetecture with no redunceny whatsoever

### Redis is mutli-az, HA and sacalabily with restore and Memcached is purely distubuted cache for loose data that is not imp


## Elastic cached strategies

### Lazy loading/lazy population?Cachc-Aside

### when the query is done it first seatched through the cached , if it dint find it connects to the instance and writes to the cache and update the user

#### Pros

##### Only requested data is cached

##### node failures are not fatal

#### cons

##### Needed 3 round trips calls if data is not avilable in the caches

##### Stale data - data update in db will be outdated in the cache

### write through 

### when ever the date is written to the DB it will also updates the caches 

#### Pros

##### Data in cache is never stale, reads are quick

##### Need only  2 write calls to update the cache 

#### cons

##### Missing data untill it is added / updated in the DB.Mitigatio is to implement Lazy loading 

##### Cache churns - Has a lot of data while will be never be read

### CacheEvictions and Time-to-live(TTL)

#### You delete teh item explicitly in cache

#### Item is evicted because the memory is full and its nor recently used(LRU)

#### You set an item time-to-live 

### TTL are helpful for any kind of data especially if using write through

#### Leader boars
#### Comments
#### Activity streams

### TTL can reange from few sec to hours or days

### If too many evicitons are happening then its better to scale up


## Amazon memory for Redis

### Redis compatable, durable,in-memory database service

### ulta-dast perfomance with 160 mill request per sec

### mutli az transactional log, scales seamlessly fro m10s GiBs to 100s TiBs of storage

### use case:web and mobile apps,online gaming