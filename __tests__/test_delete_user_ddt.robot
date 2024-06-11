*** Settings ***
Library    RequestsLibrary
Library    DataDriver    ../fixtures/csv/users.csv    dialect=excel
Test Template    Delete User DDT

*** Variables ***
${url}    https://petstore.swagger.io/v2/user

*** Test Cases ***
TC001    ${username}

*** Keywords ***
Delete User DDT
    [Arguments]    ${username}

    ${response}    DELETE    url=${{$url + '/' + $username}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]    ${{int(200)}}
    Should Be Equal    ${response_body}[type]    unknown
    Should Be Equal    ${response_body}[message]    ${username}