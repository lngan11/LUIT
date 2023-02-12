import boto3

dynamodb = boto3.resource('dynamodb')

table = dynamodb.Table('TopGrossingMovie')

response = table.delete_item(Key = {'Movie': 'Avatar', 'Year': '2009'})

print(response)
