*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Library     env.py

*** Variables ***
${base_url}     https://clarity.dexcom.com
${login_base_url}    https://uam1.dexcom.com

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

Login
    create session          mysession               ${login_base_url}
    ${body}=                create dictionary       username=%{USERNAME}        password=%{PASSWORD}        idsrv.xsrf=${idsrv-xsrf}
    ${header}=              create dictionary       Content-Type=x-www-form-urlencoded
    ${response}=            post request            mysession                   ${login_uri}                data=${body}                headers=${header}

    #VALIDATIONS
    ${status_code}          convert to string       ${response.status_code}
    should be equal         ${status_code}          200
