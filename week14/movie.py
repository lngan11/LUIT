import boto3
dynamodb = boto3.client('dynamodb')
table = dynamodb.create_table (
    TableName ='TopGrossingMovie',
       KeySchema = [
           {
               'AttributeName': 'Movie',
               'KeyType': 'HASH'
           },
           {
               'AttributeName': 'Year',
               'KeyType': 'RANGE'
           }
           ],
           AttributeDefinitions = [
               {
                   'AttributeName': 'Movie',
                   'AttributeType': 'S'
               },
               {
                   'AttributeName':'Year',
                   'AttributeType': 'S'
               }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits':10,
                'WriteCapacityUnits':10
            }
          
    )
print(table)
