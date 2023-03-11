# Week 3 — Decentralized Authentication

For week 3 coverage i learnt how to setup decentralized authentication

**1. Provision AWS Cognito User Pool via ClickOps**

For us to use AWS Cognito we will first setup my creating a user pool in the management console

![userpool](https://user-images.githubusercontent.com/60808086/224468835-50062e71-a5eb-4064-94b9-38c5f06e25e8.png)

we will take note of our client ID ```5a9vnlocco0e8pd9d6ghcpr0pq``` and user pool ID ```us-east-1_c6aZQLgwn``` which we will integrate with our cruddur app

![client id](https://user-images.githubusercontent.com/60808086/224468855-bb18134a-c0ea-45af-ad92-13d6873d820a.png)

we can manually confirm the aws cognito user in our user pool using the aws cli

```aws cognito-idp admin-set-user-password --user-pool-id us-east-1_c6aZQLgwn --username andrewbrown --password  <mypassword> --permanent```

![confirmed user ](https://user-images.githubusercontent.com/60808086/224467437-bfd47f6a-3dd0-4274-af6f-a9df4b29504f.png)
