# 1. Create an empty list initially.
aws_services = []

# 2.1 Populate the list using append
aws_services.append('EC2')
aws_services.append('S3')
aws_services.append('Lambda')

# 2.2 Populate the list using insert.
aws_services.insert(3, 'CodeCommit')

# 2.3 add mutiple AWS services to the list at once
aws_services.extend(['IAM', 'CloudWatch', 'SQS', 'SNS', 'Cloud9', 'VPC'])

# 3. Print the list and the length of the list.
print("AWS Services: ")
print(aws_services)
print("Total Number of services: ", len(aws_services))

# 4. Remove two specific services from the list by name or by index.
aws_services[6:] = []
del aws_services[5]

# 5. Print the new list and the new length of the list.
print("Top 5 Used AWS Service: ")
print(aws_services)
print("Total Number services: ", len(aws_services))
