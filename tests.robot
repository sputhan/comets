*** Settings ***
Resource          commonkeywords.robot
Library           helper.py

*** Test Cases ***
Default Parameters Happy Case
    Create Session    API    ${API_URL}    verify=true
    ${resp}=    Get Request    API    /
    Verify Output Format    ${resp.text}
    Should Be True    ${resp.json()["count"]}>0

Restrictive Query Output with Zero Count
    ${resp}=    Query API    date-min=now    date-max=+0
    Should Be Equal    ${resp.json()["count"]}    0

Wide Query Output with High Count
    [Tags]    slow
    ${resp}=    Query API    date-min=1900-01-01    date-max=2100-01-01    dist-max=10
    Should Be True    ${resp.json()["count"]}>1000

Unsuccesful Query
    ${resp}=    Query API    dist=30
    Status Should Be    400    ${resp}

