# Dexcom API Test: Code Challenge

### Requirements:
1. Install required dependency using `requirements.txt`
   * `pip install -r requirements.txt`
2. Create a file called `.env` and store it on the root directory of this repo
   * This is where you store the USERNAME, PASSWORD and ACCESS_TOKEN

        ```python
        # .env
        USERNAME=your_user_name
        PASSWORD=your_password
        ACCESS_TOKEN=your_token
        ```

### Test Case:
1.	Login with valid username and password
2.	make HTTP request call to "/api/subject/1594950620847472640/analysis_session"
3.	Assert analysisSessionId should not be None


### Constraints
* DO NOT use selenium and webdriver for this test. Create a test for API, not WEB.
* Use sessions obj from python requests library to easily maintain a "session"
* (Optional) Use a python automation framework. e.g. robot framework (Keyword Driven), unittest (like JUnit), cucumber (BDD) or any other test framework.
* (Optional) Centralize configuration for host, username and password (Do not hard code)
* Upload code in GitHub is highly recommended.
* Code completion in python is not mandatory. Explain the understanding of login process in detail or complete code in a different language as alternative.

<br>
<hr>

## Test Process

1.	Go to https://clarity.dexcom.com/
2.	Click "Dexcom CLARITY for Home Users"
    * If you click this the browser will send a GET request to https://clarity.dexcom.com/users/auth/dexcom_sts which will fetch some data then store them in the cookies and respond a status code 302 which is a redirect to the below link with a bunch of query paramaters (which I broken down for reading purposes)
      *	https://uam1.dexcom.com/identity/connect/authorize?
      *	client_id=DAEC20AC-9626-4B0E-94B5-B674E298F51E
      *	&prompt
      *	&redirect_uri=https%3A%2F%2Fclarity.dexcom.com%2Fusers%2Fauth%2Fdexcom_sts%2Fcallback
      *	&response_type=code
      *	&scope=openid+profile+offline_access
      *	&state=4d7f7fb8477a546a86a4bfdf26159899296c350c9714297b
      *	&ui_locales=en-US
      *	This link above is basically another GET request that will fetch some data to store in cookies and respond a status 302 again which is redirect to the below link with “signin” query parameter:
      *	https://uam1.dexcom.com/identity/login?
      *	signin=e45872b6d7579e8010bc78caf9faa9d0
      *	This 2nd redirect have a query parameter “signin” which is needed to login so this is where we should do the POST request for the Login process
3.	Give the valid username/password in the login window
      *	As I mention above, to login we need to send a POST request to the link with the query parameter “signin”, along with a request body (idsrv.xsrf, username and password)
         *	https://uam1.dexcom.com/identity/login?
            *	signin=e45872b6d7579e8010bc78caf9faa9d0
      *	After successfully logging in you will be redirected to a link with a query parameter “loginOptions”:
         *	https://uam1.dexcom.com/multiaccount?
            *	loginOptions=someLongRandomKey
      *	In the browser side, after logging in successfully you will land into a profile selection page which I am not sure if necessary.
         *	Either way, to select a profile, send a POST request to https://uam1.dexcom.com/identity/dependent
            *	With a body {loginAsId: this is from the ID of the UI element)

4.	make HTTP request call to "/api/subject/1594950620847472640/analysis_session"
      *	Sending a POST request however requires a header called “Access-Token”, which I can’t seem to find out where to get :(
      *	Now, I was able to get this token by getting the Access-Token in the browser’s Network Console and hardcoded it into the environment variable for the sake of this test but obviously after the session expired the token will expired too.
