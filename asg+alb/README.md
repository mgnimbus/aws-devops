# ASG+ALB

## can be scaled out/in based on n/w traffic (horizantal scaling)

## can be registerd to ALB automatically

## unhealthy instance can be termiated and create new instances in place of it

## ASG is free paid for underlying instances


## ASG - scaling policy

### Target tracking scalling

#### simple, i want asg cpu around 40%

### simple/step scaling

#### setup a cloudwatch alarm to trigger when cpu > 70 %, ad 2 units < 50 % remove 1

### Scheduled actions

#### base on usage patterns

### predictive scaling

#### to increase/decrease based on forcast


## Good metics to scale on

### cpu utilization, avg cpu

### Request count per target

### Avenerage n/w in/out

### custom cw merics

## ASG cooling def is 5 min, 

## use ready to use ami to reduce cong time inorder forfaster and reduce cooldown time


## ASG Instance refresh

### update launch template then crete all ec2 instances

### setting min health percentage

### how the old instance are destroyed and new ones are created