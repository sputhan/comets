
*** Settings ***
Library           RequestsLibrary

*** Variables ***
${API_URL}        https://ssd-api.jpl.nasa.gov/cad.api

*** Keywords ***
Query API
    [Arguments]    &{args}
    Create Session    API    ${API_URL}    verify=true
    ${resp}=    Get Request    API    /    params=${args}
    [Return]    ${resp}