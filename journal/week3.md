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

**2. Install and configure amplify client-side library for Amazon Cognito**

**Install AWS Amplify**

from our workspace navigate to the frontend directory then issue ```npm i aws-amplify --save```

**Configure AWS Amplify**
We will hook up our cognito pool to our code in our ```app.js```  frontend
```
import { Amplify } from 'aws-amplify';

Amplify.configure({
  "AWS_PROJECT_REGION": process.env.REACT_APP_AWS_PROJECT_REGION,
  "aws_cognito_identity_pool_id": process.env.REACT_APP_AWS_COGNITO_IDENTITY_POOL_ID,
  "aws_cognito_region": process.env.REACT_APP_AWS_COGNITO_REGION,
  "aws_user_pools_id": process.env.REACT_APP_AWS_USER_POOLS_ID,
  "aws_user_pools_web_client_id": process.env.REACT_APP_CLIENT_ID,
  "oauth": {},
  Auth: {
    // We are not using an Identity Pool
    // identityPoolId: process.env.REACT_APP_IDENTITY_POOL_ID, // REQUIRED - Amazon Cognito Identity Pool ID
    region: process.env.REACT_APP_AWS_PROJECT_REGION,           // REQUIRED - Amazon Cognito Region
    userPoolId: process.env.REACT_APP_AWS_USER_POOLS_ID,         // OPTIONAL - Amazon Cognito User Pool ID
    userPoolWebClientId: process.env.REACT_APP_CLIENT_ID,   // OPTIONAL - Amazon Cognito Web Client ID (26-char alphanumeric string)
  }
});

```
