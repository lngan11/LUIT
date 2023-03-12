https://medium.com/@longngan/deploying-ec2-instance-using-terraform-8c10e2fc5b7a

Your team would like to start using Jenkins as their CI/CD tool to create pipelines for DevOps projects. They need you to create the Jenkins server using Terraform so that it can be used in other environments and so that changes to the environment are better tracked. For the Foundational project you are allowed to have all your code in a single main.tf file (known as a monolith) with hardcoded data.

#FOUNDATIONAL 

Deploy 1 EC2 Instances in your Default VPC.

Bootstrap the EC2 instance with a script that will install and start Jenkins. Review the official Jenkins Documentation for more information: 

Create and assign a Security Group to the Jenkins Security Group that allows traffic on port 22 from your ip and allows traffic from port 8080.

Create a S3 bucket for your Jenkins Artifacts that is not open to the public.

#ADVANCED

Add a variables.tf file and make sure nothing is hardcoded in your main.tf.

Create separate file for your providers.tf if you have not already.

#COMPLEX

Create an IAM Role that allows S3 write access for the Jenkins Server and assign that role to your Jenkins Server EC2 instance.
