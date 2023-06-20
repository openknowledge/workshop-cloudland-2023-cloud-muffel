# 4 – Lambda

In this exercise we use AWS Lambda to add additional functionality to our application without chaning any existing backend code. We want to sent an "email" whenever a new topic is added to our forum. To do this we use any DynamoDB change in our table as trigger for our Lambda function.

1. Create a new Lambda function

    - Go to the Lambda page in the AWS Management console
    - Select "Create from Scratch" and use Node.js as runtime
