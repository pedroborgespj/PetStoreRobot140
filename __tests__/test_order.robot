*** Settings ***

Library    RequestsLibrary

*** Variables ***

${url}    https://petstore.swagger.io/v2/store/order

${id}    394214401
${petId}    194214401
${quantity}    1
${shipDate}    2024-05-26T18:32:24.567Z
${status}    approved
${complete}    ${{boll(True)}}

*** Test Cases ***

Post Order
    ${body}    Create Dictionary    id=${id}    petId=${petId}    quantity=${quantity}    shipDate=${shipDate}    status=${status}    complete=${complete}

    ${response}    POST    url=${url}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[petId]    ${{int($petId)}}
    Should Be Equal    ${response_body}[status]    ${status}

Get Order
    ${response}    GET    url=${{$url + '/' + $id}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[petId]    ${{int($petId)}}
    Should Be Equal    ${response_body}[quantity]    ${{int($quantity)}}
    Should Be Equal    ${response_body}[complete]    ${complete}

Delete Order
    ${response}    DELETE    url=${{$url + '/' + $id}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]    ${{int(200)}}
    Should Be Equal    ${response_body}[type]    unknown
    Should Be Equal    ${response_body}[message]    ${id}