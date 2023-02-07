import boto3

# create an SQS client
sqs = boto3.client('sqs')

# create a new SQS queue
response = sqs.create_queue(
    QueueName='week15',
    Attributes={
        'DelaySeconds': '5',
        'MessageRetentionPeriod': '86400'
    }
)

# print the SQS queue URL
print(response['QueueUrl'])
