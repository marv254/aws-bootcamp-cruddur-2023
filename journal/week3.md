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
```javascript
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
we will also set env variables for our ```docker-compose.yaml``` file
```yaml
 REACT_APP_AWS_PROJECT_REGION: "${AWS_DEFAULT_REGION}"
 REACT_APP_AWS_COGNITO_REGION: "${AWS_DEFAULT_REGION}"
 REACT_APP_AWS_USER_POOLS_ID: "us-east-1_c6aZQLgwn"
 REACT_APP_CLIENT_ID: "5a9vnlocco0e8pd9d6ghcpr0pq"
 ```
**3. Show conditional elements and data based on logged in or logged out**

Inside our ``` HomeFeedPage.js``` we will hookup this code
```javascript
import { Auth } from 'aws-amplify';

import DesktopNavigation  from '../components/DesktopNavigation';
import DesktopSidebar     from '../components/DesktopSidebar';
import ActivityFeed from '../components/ActivityFeed';
import ActivityForm from '../components/ActivityForm';
import ReplyForm from '../components/ReplyForm';

// [TODO] Authenication
import Cookies from 'js-cookie'

export default function HomeFeedPage() {
  const [activities, setActivities] = React.useState([]);
  const [popped, setPopped] = React.useState(false);
  const [poppedReply, setPoppedReply] = React.useState(false);
  const [replyActivity, setReplyActivity] = React.useState({});
  const [user, setUser] = React.useState(null);
  const dataFetchedRef = React.useRef(false);

  const loadData = async () => {
    try {
      const backend_url = `${process.env.REACT_APP_BACKEND_URL}/api/activities/home`
      const res = await fetch(backend_url, {
        headers: {
          Authorization: `Bearer ${localStorage.getItem("access_token")}`
        },
        method: "GET"
      });
      let resJson = await res.json();
      if (res.status === 200) {
        setActivities(resJson)
      } else {
        console.log(res)
      }
    } catch (err) {
      console.log(err);
    }
  };

  const checkAuth = async () => {
    Auth.currentAuthenticatedUser({
      // Optional, By default is false. 
      // If set to true, this call will send a 
      // request to Cognito to get the latest user data
      bypassCache: false 
    })
    .then((user) => {
      console.log('user',user);
      return Auth.currentAuthenticatedUser()
    }).then((cognito_user) => {
        setUser({
          display_name: cognito_user.attributes.name,
          handle: cognito_user.attributes.preferred_username
        })
    })
    .catch((err) => console.log(err));
  };
  
  React.useEffect(()=>{
    //prevents double call
    if (dataFetchedRef.current) return;
    dataFetchedRef.current = true;

    loadData();
    checkAuth();
  }, [])
```
we will have to pass user to the following components:

```javascript
<DesktopNavigation user={user} active={'home'} setPopped={setPopped} />
<DesktopSidebar user={user} />
```
We'll rewrite ```DesktopNavigation.js``` component so that it it conditionally shows links in the left hand column on whether you are logged in or not.
```javascript
import './DesktopNavigation.css';
import {ReactComponent as Logo} from './svg/logo.svg';
import DesktopNavigationLink from '../components/DesktopNavigationLink';
import CrudButton from '../components/CrudButton';
import ProfileInfo from '../components/ProfileInfo';

export default function DesktopNavigation(props) {

  let button;
  let profile;
  let notificationsLink;
  let messagesLink;
  let profileLink;
  if (props.user) {
    button = <CrudButton setPopped={props.setPopped} />;
    profile = <ProfileInfo user={props.user} />;
    notificationsLink = <DesktopNavigationLink 
      url="/notifications" 
      name="Notifications" 
      handle="notifications" 
      active={props.active} />;
    messagesLink = <DesktopNavigationLink 
      url="/messages"
      name="Messages"
      handle="messages" 
      active={props.active} />
    profileLink = <DesktopNavigationLink 
      url="/@andrewbrown" 
      name="Profile"
      handle="profile"
      active={props.active} />
  }

  return (
    <nav>
      <Logo className='logo' />
      <DesktopNavigationLink url="/" 
        name="Home"
        handle="home"
        active={props.active} />
      {notificationsLink}
      {messagesLink}
      {profileLink}
      <DesktopNavigationLink url="/#" 
        name="More" 
        handle="more"
        active={props.active} />
      {button}
      {profile}
    </nav>
  );
}
```
we will then update our ```ProfileInfo.js``` component
```javascript
import { Auth } from 'aws-amplify';

const signOut = async () => {
  try {
      await Auth.signOut({ global: true });
      window.location.href = "/"
  } catch (error) {
      console.log('error signing out: ', error);
  }
}
```
We'll rewrite ```DesktopSidebar.js``` so that it conditionally shows components in case you are logged in or not.
```javascript 
import './DesktopSidebar.css';
import Search from '../components/Search';
import TrendingSection from '../components/TrendingsSection'
import SuggestedUsersSection from '../components/SuggestedUsersSection'
import JoinSection from '../components/JoinSection'

export default function DesktopSidebar(props) {
  const trendings = [
    {"hashtag": "100DaysOfCloud", "count": 2053 },
    {"hashtag": "CloudProject", "count": 8253 },
    {"hashtag": "AWS", "count": 9053 },
    {"hashtag": "FreeWillyReboot", "count": 7753 }
  ]

  const users = [
    {"display_name": "Andrew Brown", "handle": "andrewbrown"}
  ]

  let trending;
  let suggested;
  let join;
  if (props.user) {
    trending = <TrendingSection trendings={trendings} />
    suggested = <SuggestedUsersSection users={users} />
  } else {
    join = <JoinSection />
  }

  return (
    <section>
      <Search />
      {trending}
      {suggested}
      {join}
      <footer>
        <a href="#">About</a>
        <a href="#">Terms of Service</a>
        <a href="#">Privacy Policy</a>
      </footer>
    </section>
  );
}
```
**4. Verify JWT Token server side to serve authenticated API endpoints**

**Sign Up Page** 
```javascript
import { Auth } from 'aws-amplify';

const [errors, setErrors] = React.useState('');
  
  const onsubmit = async (event) => {
    event.preventDefault();
    setErrors('')
    console.log('username',username)
    console.log('email',email)
    console.log('name',name)
    try {
      const { user } = await Auth.signUp({
        username: email,
        password: password,
        attributes: {
          name: name,
          email: email,
          preferred_username: username,
        },
        autoSignIn: { // optional - enables auto sign in after user is confirmed
          enabled: true,
        }
      });
      console.log(user);
      window.location.href = `/confirm?email=${email}`
    } catch (error) {
        console.log(error);
        setErrors(error.message)
    }
    return false
  }
```
![signup1](https://user-images.githubusercontent.com/60808086/224473070-3b2ec36b-827d-4b05-9a79-502e1b7fc6d2.png)

![signup2](https://user-images.githubusercontent.com/60808086/224473080-dc847c1a-1c4e-4fde-ac27-89c3901dd761.png)
![signup3](https://user-images.githubusercontent.com/60808086/224473083-2be79fca-3f92-4d98-80ae-d1cf062e4567.png)
![signup4](https://user-images.githubusercontent.com/60808086/224473087-12162806-d487-4abf-9164-2f97177652d2.png)

**Sign In Page**
```javascript
import { Auth } from 'aws-amplify';

const [errors, setErrors] = React.useState('');

  const onsubmit = async (event) => {
    setErrors('')
    event.preventDefault();
    Auth.signIn(email, password)
    .then(user => {
      console.log('user',user)
      localStorage.setItem("access_token", user.signInUserSession.accessToken.jwtToken)
      window.location.href = "/"
    })
    .catch(error => { 
      if (error.code == 'UserNotConfirmedException') {
        window.location.href = "/confirm"
      }
      setErrors(error.message)
    });
    return false
  }
```
![signin](https://user-images.githubusercontent.com/60808086/224473357-273e129f-014d-40fc-a072-4a1e9de5efde.png)
![signin2](https://user-images.githubusercontent.com/60808086/224473360-dc68f987-df9c-4989-8ecf-f6b177687c78.png)

**Confirmation Page**
```javascript
  const resend_code = async (event) => {
    setErrors('')
    try {
      await Auth.resendSignUp(email);
      console.log('code resent successfully');
      setCodeSent(true)
    } catch (err) {
      // does not return a code
      // does cognito always return english
      // for this to be an okay match?
      console.log(err)
      if (err.message == 'Username cannot be empty'){
        setErrors("You need to provide an email in order to send Resend Activiation Code")   
      } else if (err.message == "Username/client id combination not found."){
        setErrors("Email is invalid or cannot be found.")   
      }
    }
  }

  const onsubmit = async (event) => {
    event.preventDefault();
    setErrors('')
    try {
      await Auth.confirmSignUp(email, code);
      window.location.href = "/"
    } catch (error) {
      setErrors(error.message)
    }
    return false
  }
```

**Recovery Page**
```javascript
import { Auth } from 'aws-amplify';

const onsubmit_send_code = async (event) => {
    event.preventDefault();
    setErrors('')
    Auth.forgotPassword(username)
    .then((data) => setFormState('confirm_code') )
    .catch((err) => setErrors(err.message) );
    return false
  }
  
  const onsubmit_confirm_code = async (event) => {
    event.preventDefault();
    setErrors('')
    if (password == passwordAgain){
      Auth.forgotPasswordSubmit(username, code, password)
      .then((data) => setFormState('success'))
      .catch((err) => setErrors(err.message) );
    } else {
      setErrors('Passwords do not match')
    }
    return false
  }
  ```
  add in the ```HomeFeedPage.js``` a header  to pass along the access token
  ```javascript
    headers: {
    Authorization: `Bearer ${localStorage.getItem("access_token")}`
  }
  ```
  ![recover](https://user-images.githubusercontent.com/60808086/224473844-4ed6f071-90f9-4144-980b-ef0508919d7c.png)
![recover2](https://user-images.githubusercontent.com/60808086/224473850-e003ebb8-53af-4386-88e1-497ff1a50490.png)

![recover3](https://user-images.githubusercontent.com/60808086/224473856-7cabd68b-1fc1-4575-b736-260c5db3df72.png)
![recover4](https://user-images.githubusercontent.com/60808086/224473866-a9005502-4e55-4f8b-af99-1a22bc3ee2bd.png)
