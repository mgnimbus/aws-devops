# A-record

## it can route the domain name to IPv4 address
<br>

# CNAME:

## It pints a hostname to any other host name

### app.mydomain.com --> blabla.anything.com

### Only work for non root domain (aka something.mydomain.com)

<br>

# Alias

## points a host name to aws resourece

### app.mydomain.com --> blabla.awsamazon.com

### work for both root(aka mydomain.com) and non root domain

<br>

# Alias Records

## Extension to DNS fucntionality

## Can be A/AAAA IPv4 or IPv6

### You cant set TTL

### Targers - ELB, CloudFront, API Gateway, Elastic Beanstalk,s3 websites,VPC Interface Endpoints,Global Accelerator,Route 53 Record

#### You cant ser ALIAS Record for EC2 DNS Name
<br>

# Routing policies- Route 53

## Its not same as Load balancer routing which routes traffics

## DNS doesnt route any traffic,it only responf to DNS quire

<br>

# Routing Policy 

## simple
## weighted
## Latency based
## Health checks 
## Failover
## Geolocation
## Multi-value Answer
## Geoproximity
<br>

## Simple

### Just points to single resource

### If there are multiple A records the clinet randomly chosen one

### Whend ALIAS is enabled, specify onle one AWS resource

### cant be associated with Health Checks

<br>

## weighted

### contrl the % of the requests that go to each specif resource

### Assgin each record a relative weight 

### traffic % = weight of a specific record/sum of all record weighted

### DNS record must have same name and type

### can be asscoiated with health checks

### use cases: load balancing b/w regions, testing new applicaiton versions


<br>


## Latency based 

### Redirect to the resource that has least latency close to us

### helpful when leatency for user is a priority

### Latency is based on traffic b/w users and AWS regions 

### can be asscoiated with health checks

<br>

## Health checks 

### Health are only for public resources

### Health check that monitor over an EndPoint
### Health check that monitor other healt checks (calculate heatlh checks)
### Health check that monitor cloudwatch Alarms 

## Health checks are integrated with CW metrics
<br>

## Failover
### If the primary  record with health check(mandatory) is failed then it switches to secondary record 


<br>

## Geolocation

### Specific location by contient,country,

### should create a default in case no match is nofound

### use cases website localization, restrict content distrubution,load balencing

### can be asscoiated with health checks


<br>

## Geoproximity

### route trafic your resources based on geografic loaction of users and resoures

### Ability to shioft more trafiic to resourdces based on defined bias

### To change the size of geografic  region,speocifc bias values
#### To exapande (1-99) -more trafic to the resources
#### To shrink (-1 to -99) -less trafic to the resources

## reosurces can be AWS spicif awsw reion, non aws resources (specify latti and long)


<br>

# Traffic flow

## simplify the process of creating and maintaining records in large and complex configurations 

## visual editior to manage complex routing decisions trees
## Traffic policy 


<br>

# Ip based Routing

## routing based on clinet IP address

### you provide a list of CIDs of your clinets and correspondong endpoints/locations

### use cases optimise perfomance, reduce n/w cossts

<br>

# Multi-value

## routing traffic to multiple resouces

## Route 53 return multiple values/resources

##  can be assoc with helth checks

## upto 8 healthy records are returned for each multi vallue query

## multi value is not a sunstitute for ELB
