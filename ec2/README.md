


# EC2
### If you are facing a time out then its an issue with access the service,instance etc (timeout = access issue(role,sg group...)

### 3389 - RDP port to access the windows instances log in into  a window instance

### 21  for FTP uploding file to  file share 

### 22 for ssh(secure shell)/SFTP uploding files through SSH

### Checkout Ec2 purcase option


## EBS

### EBS volumes are like network USB stick that can be detached or attached if in same az

### EBS volumes are bound to azes if you want to attach it to an instance in other azes then you can create a snapshot and restore using it in other azes

### EBS devices like gp2/gp3 can be multi attached to instance if it is enabled at config level and in same az, Must use clusted file syatem(not XFS,EXT4, etc...). upto 16 instance 

### Checkout EBS volume types like gp2/gp3 for general purpose ,io1/io2 for data base used in Nitro EC2 Instances, st1/sc1 HDD for DataWatehosing or archive data

### If you want HP device then use EC2 Instane Store for better I/O Its an empheral device

### Ec2 Instace store are like phyicall conneted drive for use.You need to create  backups  and snaps for resilience 


## EFS

### EFS is like a network file system(Manged by NPS),High availability can be used in any azes can be mounted to mutliple EC2 Instances

### can be only used in Linux

### Scalable enabled as multi az and Pay as You 

### can enable lifecycle policy If a file has not been accessed with in 30 days can be tranferd to a lower class EFS-IA


## EBS vs EFS

#### EBS are locked to one instance(mostly) and one az,to Migrate we need to create a snapshots

### EFS is Netwok NFS can be shared to n devices, scalable, robust and versatile