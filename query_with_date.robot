*** Settings ***
Library  RequestsLibrary
Library  helper.py

*** Variables ***
${API_URL}  https://ssd-api.jpl.nasa.gov/cad.api

*** Test Cases ***
Valid Query with data range +D and now
    [Documentation]  Querying within a shorter date range should return smaller count in output
    Create Session    API   ${API_URL}   verify=true
    ${params}=  Create Dictionary   date-min=now   date-max=+100
    ${resp}=  Get Request  API   /    params=${params}
    Verify Output Format  ${resp.text}
    ${count_1}  Set Variable  ${resp.json()["count"]}
    ${params}=  Create Dictionary   date-min=now   date-max=+30
    ${resp}=  Get Request  API   /    params=${params}
    Verify Output Format  ${resp.text}
    ${count_2}=   Set Variable  ${resp.json()["count"]}
    Should Be True  ${count_2}<${count_1}

Valid Query with data range YYYY-MM-DD format
    [Documentation]  Querying within a shorter date range should return smaller count in output
    Create Session    API   ${API_URL}   verify=true
    ${params}=  Create Dictionary   date-min=2020-01-01   date-max=2021-01-01
    ${resp}=  Get Request  API   /    params=${params}
    Verify Output Format  ${resp.text}
    ${count_1}  Set Variable  ${resp.json()["count"]}
    ${params}=  Create Dictionary   date-min=2020-01-01   date-max=2020-05-01
    ${resp}=  Get Request  API   /    params=${params}
    Verify Output Format  ${resp.text}
    ${count_2}=   Set Variable  ${resp.json()["count"]}
    Should Be True  ${count_2}<${count_1}

Valid Query with data range YYYY-MM-DDThh:mm:ss format
    [Documentation]  Querying within a shorter date range should return smaller count in output
    Create Session    API   ${API_URL}   verify=true
    ${params}=  Create Dictionary   date-min=2020-01-01T00:10:10   date-max=2020-01-01T10:10:10
    ${resp}=  Get Request  API   /    params=${params}
    Verify Output Format  ${resp.text}
    ${count_1}  Set Variable  ${resp.json()["count"]}
    ${params}=  Create Dictionary   date-min=2020-01-01T05:10:10   date-max=2020-01-01T10:10:10
    ${resp}=  Get Request  API   /    params=${params}
    Verify Output Format  ${resp.text}
    ${count_2}=   Set Variable  ${resp.json()["count"]}
    Should Be True  ${count_2}<${count_1}

Invalid Query with data range +D and now
    [Documentation]  verify status 400 on invalid queries
    Create Session    API   ${API_URL}   verify=true
    ${params}=  Create Dictionary   date-min=now   date-max=qwd
    ${resp}=  Get Request  API   /    params=${params}
    Status Should Be  400  ${resp}

Invalid Query with data range YYYY-MM-DD format
    [Documentation]  verify status 400 on invalid queries
    Create Session    API   ${API_URL}   verify=true
    ${params}=  Create Dictionary   date-min=2020-1-1   date-max=+10
    ${resp}=  Get Request  API   /    params=${params}
    Status Should Be  400  ${resp}

Invalid Query with data range YYYY-MM-DDThh:mm:ss format
    [Documentation]  verify status 400 on invalid queries
    Create Session    API   ${API_URL}   verify=true
    ${params}=  Create Dictionary   date-min=2020-01-0105:10:10   date-max=+10
    ${resp}=  Get Request  API   /    params=${params}
    Status Should Be  400  ${resp}