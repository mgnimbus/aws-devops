# Serverless 
You dont need to manage any server, ready to use functions, like AWS LAMBA

- Initially it was called Funciton as a service FaaS
-  AWS Lambda was the pioneer for serverless
-  They just deploy functions
-  Ability to scale up/down based on traffic

# Serverless in AWS

- AWS Lambda
- DynamoDB
- AWS Cognito
- AWS API Gateway
- Amazon S3
- AWS SNS & SQS
- AWS Kinesis Data Firehose
- Aurora Servedess
- Step Functions
- Fargate

# Why Lambda

- Integrated with the whole AWS suite of services
- Integrated with many programming languages
- Easy monitoring through AWS CloudWatch
- Easy to get more resources per functions (up to I OGB of RAM!)
- Increasing RAM will also improve CPU and network!

![Why Lambda?](images/why_lamba.jpg)

## Lambda Container Image

- The container image must implement the Lambda Runtime API
- ECS / Fargate is preferred for running arbitrary Docker images


## Lambda Integraion

![Integraions](images/lambda_integrations.jpg)

![example](images/example_integraions.jpg)

- To preform severless CRON job using event scheduler

## Synchronous Invocaitons

- Synchronous: CLI,SDK, API Gateway, Applicaion Load Balancer
  - Results are returned right aws
  - Error handeling must happem clinet side (retries, exponential backoff, etc)

![synchronous example](images/sync_app.jpg)

- User invoked:
 -  Elastic Load Balancing (Application Load Balancer)
 -  Amazon API Gateway
 -  Amazon CloudFront (Lambda@Edge)
 -  Amazon S3 Batch
  
- service Invoked:
  - Amazon Cognito
  - AWS Step Functions
  
- Other Services:
  - Amazon Lex
  - Amazon Alexa 
  - Amazon Kinesis Data Firehose


```py
def lambda_handler(event, context):
    return {
        'status code': 200,
        'body': json.dumps('Hello form Lambda!')
    }
```

```
{
  'requestContext': 
          {'elb': {'targetGroupArn': 'arn:aws:elasticloadbalancing:us-east-1:328268088738:targetgroup/alb-lambda-mule/bcc69a614ccfa457'}},
          'httpMethod': 'GET',
          'path': '/',
          'queryStringParameters': {},
          'headers': {'user-agent': 'ELB-HealthChecker/2.0'},
          'body': '', 
          'isBase64Encoded': False
}

```

```py
import json

def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "statusDescription": "200 OK",
        "isBase64Encoded": False,
        "headers": {
            "Content-Type": "text/html"
        },
        "body": "<h1>Hello from Lambda!</h1>"
    }

```

```json
return {
        "statusCode": 200,
        "statusDescription": "200 OK",
        "isBase64Encoded": False,
        "headers": {
            "Content-Type": "text/html"
        },
        "body": "<h1>Hello from Lambda!</h1>"
    }
```

### If you want read multi hearders response from get request you need to enable Multi value headers in Target group, attributes in load balancer and change the lambda code return accordingly 


```json
"headers": {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
        "accept-encoding": "gzip",
        "accept-language": "en-US,en;q=0.9",
        "connection": "keep-alive",
        "host": "lambda-alb-123578498.us-east-1.elb.amazonaws.com",
        "upgrade-insecure-requests": "1",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36",
        "x-amzn-trace-id": "Root=1-5c536348-3d683b8b04734faae651f476",
        "x-forwarded-for": "72.12.164.125",
        "x-forwarded-port": "80",
        "x-forwarded-proto": "http",
        "x-imforwards": "20"
    },
```