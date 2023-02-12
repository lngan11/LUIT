
import random
import string

def generate_instance_name(dept_name, length):
    """Generates a unique EC2 instance name for the specified department."""
    random_string = ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))
    instance_name = dept_name + "-" + random_string
    return instance_name

# Input the number of EC2 instances
num_instances = int(input("Enter the number of EC2 instances: "))

# Input the name of the department
dept_name = input("Enter the name of the department: ")

# Generate unique EC2 instance names
instance_names = []
for i in range(num_instances):
    instance_name = generate_instance_name(dept_name, 8)
    instance_names.append(instance_name)

# Output the EC2 instance names
for name in instance_names:
    print(name)
