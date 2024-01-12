import boto3
import json

def lambda_handler(event, context):
    # Extract instance ID from the CloudWatch event
    instance_id = event['detail']['instance-id']
    
    # List of whitelisted instance IDs
    whitelist = ['i-xxxxxxxxxxxxxxxxx', 'i-yyyyyyyyyyyyyyyyy']

    # Check if the launched instance is in the whitelist
    if instance_id in whitelist:
        print(f"Instance {instance_id} is whitelisted.")
        # Perform additional actions if needed
    else:
        print(f"Instance {instance_id} is NOT whitelisted. Taking action...")
        # Take appropriate action (e.g., terminate the instance)
        ec2 = boto3.client('ec2')
        ec2.terminate_instances(InstanceIds=[instance_id])

    return {
        'statusCode': 200,
        'body': json.dumps('Lambda function executed successfully!')
    }