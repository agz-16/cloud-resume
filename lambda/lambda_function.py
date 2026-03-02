import json
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("cloud-resume-test")

ALLOWED_ORIGINS = {
    "https://www.agz-cloud.com",
    "https://agz-cloud.com",
}

def lambda_handler(event, context):
    origin = (event.get("headers") or {}).get("origin") or (event.get("headers") or {}).get("Origin")

    # If request Origin is one of your allowed sites, echo it back
    allow_origin = origin if origin in ALLOWED_ORIGINS else "https://www.agz-cloud.com"

    response = table.get_item(Key={"id": "1"})
    views = int(response["Item"]["views"]) + 1
    table.put_item(Item={"id": "1", "views": views})

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": allow_origin,
            "Access-Control-Allow-Methods": "GET,OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type",
            "Content-Type": "application/json",
            "Cache-Control": "no-store",
            "Vary": "Origin",  # helps caching behave correctly
        },
        "body": json.dumps(views),
    }