import boto3

dynamodb = boto3.client('dynamodb')

table = dynamodb.Table('TopGrossingMovie')

with table.batch_writer() as batch:
        batch.put_item(Item={"Movie": "Avatar", "Year": "2009"})
        batch.put_item(Item={"Movie": "Avenger:Endgame", "Year":"2019"})
        batch.put_item(Item={"Movie": "Titanic", "Year": "1997"})
        batch.put_item(Item={"Movie": "Star Wars: The Force Awakens", "Year": "2015"})
        batch.put_item(Item={"Movie": "Avenger: Infinity War", "Year": "2018"})
        batch.put_item(Item={"Movie": "Avatar: The Way of Water", "Year": "2022"})
        batch.put_item(Item={"Movie": "Spider-Man: No Way Home", "Year": "2021"})
        batch.put_item(Item={"Movie": "Jurassic World", "Year": "2015"})
        batch.put_item(Item={"Movie": "The Lion King", "Year": "2019"})
        batch.put_item(Item={"Movie": "The Avengers", "Year": "2012"})
    
print (batch)
