*** Settings ***

Library    RequestsLibrary

*** Variables ***

${url}    https://petstore.swagger.io/v2/user

${id}    294214401
${username}    patricia_costa
${firstName}    Patricia
${lastName}    Costa
${email}    patricia_costa@microlasersp.com.br
${password}    iqHJKLN7lI
${phone}    (95)99425-0745
${userStatus}    0

*** Test Cases ***
Post User
    ${body}    Create Dictionary    id=${id}    username=${username}    firstName=${firstName}    lastName=${lastName}    email=${email}    password=${password}    phone=${phone}    userStatus=${userStatus}

    ${response}    POST    url=${url}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]    ${{int(200)}}
    Should Be Equal    ${response_body}[type]    unknown
    Should Be Equal    ${response_body}[message]    ${id}

Get User
    ${response}    GET    url=${{$url + '/' + $username}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[firstName]    ${firstName}
    Should Be Equal    ${response_body}[email]    ${email}

Put User
    ${body}    Evaluate    json.loads(open('./fixtures/json/user2.json').read())

    ${response}    PUT    url=${{$url + '/' + $username}}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]    ${{int(200)}}
    Should Be Equal    ${response_body}[type]    unknown
    Should Be Equal    ${response_body}[message]    ${id}

Delete User
    ${response}    DELETE    url=${{$url + '/' + $username}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]    ${{int(200)}}
    Should Be Equal    ${response_body}[type]    unknown
    Should Be Equal    ${response_body}[message]    ${username}