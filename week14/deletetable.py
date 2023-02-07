import boto3

dynamodb = boto3.resource('dynamodb')

client = boto3.client('dynamodb')
resp = client.delete_table(
        TableName="TopGrossingMovie")
        
print ("Delete Successful")
