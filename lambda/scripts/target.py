import json


def lambda_handler(event, context):
    # return {
    #     'status code': 200,
    #     'body': json.dumps('Hello form Lambda!')
    # }

    return {
        "statusCode": 200,
        "statusDescription": "200 OK",
        "isBase64Encoded": False,
        "headers": {
            "Content-Type": "text/html"
        },
        "body": "<h1>Hello from Lambda!</h1>"
    }
