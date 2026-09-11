import json
import os
import uuid
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])


def handler(event, context):
    body = json.loads(event.get("body", "{}"))
    body["id"] = str(uuid.uuid4())

    table.put_item(Item=body)

    return {
        "statusCode": 201,
        "body": json.dumps({"id": body["id"]})
    }
