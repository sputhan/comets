*** Settings ***
Resource          commonkeywords.robot

*** Test Cases ***
Valid Query with date range +D and now
    [Documentation]    Querying within a shorter date range should return smaller count in output
    ${count_1}=    Query Count With date range    date-min=now    date-max=+100
    ${count_2}=    Query Count With date range    date-min=now    date-max=+30
    Should Be True    ${count_2}<${count_1}

Valid Query with date range YYYY-MM-DD format
    [Documentation]    Querying within a shorter date range should return smaller count in output
    ${count_1}=    Query Count With date range    date-min=2020-01-01    date-max=2021-01-01
    ${count_2}=    Query Count With date range    date-min=2020-01-01    date-max=2020-05-01
    Should Be True    ${count_2}<${count_1}

Valid Query with date range YYYY-MM-DDThh:mm:ss format
    [Documentation]    Querying within a shorter date range should return smaller count in output
    ${count_1}=    Query Count With date range    date-min=2020-01-01T00:10:10    date-max=2020-01-01T10:10:10
    ${count_2}=    Query Count With date range    date-min=2020-01-01T05:10:10    date-max=2020-01-01T10:10:10
    Should Be True    ${count_2}<${count_1}

Invalid Date Ranges
    [Template]    Query With Date Range Invalid
    info=+D and now format    date-min=now    date-max=qwd
    info=YYYY-MM-DD format    date-min=2020-1-1    date-max=+10
    info=YYYY-MM-DDThh:mm:ss format    date-min=2020-01-0105:10:10    date-max=+10

*** Keywords ***
Query Count With Date Range
    [Arguments]    ${date-min}    ${date-max}
    ${resp}=    Query API   date-min=${date-min}    date-max=${date-max}
    [Return]     ${resp.json()["count"]}

Query With Date Range Invalid
    [Arguments]    ${info}    ${date-min}    ${date-max}
    ${resp}=    Query API       date-min=${date-min}    date-max=${date-max}
    Status Should Be    400    ${resp}
