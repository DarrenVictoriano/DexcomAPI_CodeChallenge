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
<br>

### Test Case:
1.	Login with valid username and password
2.	make HTTP request call to "/api/subject/1594950620847472640/analysis_session"
3.	Assert analysisSessionId should not be None

<br>

### Constraints
* DO NOT use selenium and webdriver for this test. Create a test for API, not WEB.
* Use sessions obj from python requests library to easily maintain a "session"
* (Optional) Use a python automation framework. e.g. robot framework (Keyword Driven), unittest (like JUnit), cucumber (BDD) or any other test framework.
* (Optional) Centralize configuration for host, username and password (Do not hard code)
* Upload code in GitHub is highly recommended.
* Code completion in python is not mandatory. Explain the understanding of login process in detail or complete code in a different language as alternative.
