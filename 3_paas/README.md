# 3 – PaaS

In this exercise we want to create a DynamoDB table in and deploy a new version of our backend that that table.

1. In the AWS management console open the DynamoDB page

    - Create a new DynamoDB table with the default configuration
    - Name it after your user

2. Build a new version of the backend

    - Run `mvn clean package`

3. Build Docker image and push to our new ECR repository (same step as in exercise `03_paas`)

    - Open the new ECR repository and click on "View push commands"
    - Follow the instructions there (login, build, tag and push)

4. Change the configuration of your app runner service

    - Add a new environment variable called `CLOUD_MUFFEL_DYNAMODB_TABLE`
    - The value of the variable should be the name of your DynamoDB table (see 1.)

5. Wait until the new version of the backend is deployed (or do it manually)

6. Connect the frontend to AppRunner service

    - Adjust the showcase "3 – PaaS" in showcases.ts
    - Set the base URL using the default of your app runner service
    - Select showcase "2 – Managed Services" and check if the app works properly

7. Connect the frontend to AppRunner service

    - Adjust the showcase "3 – PaaS" in showcases.ts
    - Set the base URL using the default domain of your app runner service
    - Select showcase "3 – PaaS" and check if the app works properly

8. Check the DynamoDB table in the AWS Management Console

    - You should see some test data that was inserted automatically

9. Use the frontend to add few more topics
    - Check if you can see them in DynamoDB table
    - Feel free to change the data of a few items
