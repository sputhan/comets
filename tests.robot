*** Settings ***
Library  RequestsLibrary
Library  helper.py

*** Variables ***
${API_URL}  https://ssd-api.jpl.nasa.gov/cad.api

*** Test Cases ***
Default Parameters
  Create Session    API   ${API_URL}   verify=true
  ${resp}=  Get Request    API    /
  Verify Output Format  ${resp.text}
  Should Be True  ${resp.json()["count"]}>0

Restrictive Query Output with Zero Count
    Create Session    API   ${API_URL}   verify=true
    ${params}=  Create Dictionary   date-min=now   date-max=+0
    ${resp}=  Get Request  API   /    params=${params}
    Should Be Equal  ${resp.json()["count"]}  0

# Wide Query Output with High Count
#     Create Session    API   ${API_URL}   verify=true
#     ${params}=  Create Dictionary   date-min=1900-01-01   date-max=2100-01-01  dist-max=10
#     ${resp}=  Get Request  API   /    params=${params}
#     Should Be True  ${resp.json()["count"]}>1000

Unsuccesful Query
    Create Session    API   ${API_URL}   verify=true
    ${params}=  Create Dictionary   dist=30
    ${resp}=  Get Request  API   /    params=${params}
    Status Should Be  400  ${resp}
