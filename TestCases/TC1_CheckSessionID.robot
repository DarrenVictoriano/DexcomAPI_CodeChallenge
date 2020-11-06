*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Library     env.py

*** Variables ***
${base_url}             https://clarity.dexcom.com
${login_base_url}       https://uam1.dexcom.com
${sessionID}            /api/subject/1594950620847472640/analysis_session

*** Test Cases ***
Click HomeUser
    create session          mysession                   ${base_url}
    ${response}=            get request                 mysession                   /users/auth/dexcom_sts
    # save 302 redirect URLs to a variables
    ${first_redirect}=      set variable                ${response.history[1].url}
    ${second_redirect}=     convert to string           ${response.url}
    ${start}=               get length                  ${login_base_url}
    ${login_uri}=           get substring               ${second_redirect}              start=${start}
    # save the idsrv-xsrf cookie into a variable for later use
    ${idsrv-xsrf}=             get from dictionary         ${response.cookies}         idsrv.xsrf
    # make these variables available test suite wide
    set suite variable      ${first_redirect}
    set suite variable      ${login_uri}
    set suite variable      ${idsrv-xsrf}

    #VALIDATIONS
    ${status_code}=     convert to string           ${response.status_code}
    should be equal     ${status_code}              200

Login with valid credentials
    create session          mysession               ${login_base_url}
    ${body}=                create dictionary       username=%{USERNAME}        password=%{PASSWORD}        idsrv.xsrf=${idsrv-xsrf}
    ${header}=              create dictionary       Content-Type=x-www-form-urlencoded
    ${response}=            post request            mysession                   ${login_uri}                data=${body}                headers=${header}

    #VALIDATIONS
    ${status_code}          convert to string       ${response.status_code}
    should be equal         ${status_code}          200

# Select Profile
#     create session          mysession               ${login_base_url}
#     ${body}                 create dictionary       oginAsId="5d4efde1-7884-4cf3-beb7-39e5388ac40d"
#     ${header}               create dictionary       Content-Type=application/x-www-form-urlencoded          Access-Control-Request-Method=POST              Access-Control-Request-Headers=authority                Origin=${login_base_url}
#     ${response}             post request            mysession                   /identity/dependent         data=${body}                headers=${header}
#     log to console          ${response.content}

Check for analysisSessionId
    create session          mysession               ${base_url}
    ${header}=              create dictionary       Content-Type=x-www-form-urlencoded          Access-Token=%{ACCESS_TOKEN}
    ${response}=            post request            mysession              ${sessionID}         headers=${header}
    ${response_dict}=       set variable            ${response.json()}
    ${analysisSessionId}    get from dictionary     ${response_dict}        analysisSessionId
    should be true          ${analysisSessionId} is not None