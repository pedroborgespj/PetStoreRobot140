*** Settings ***
# Bibliotecas e Configurações
Library    RequestsLibrary

*** Variables ***
# Objetos, Atributos e Variables
${url}    https://petstore.swagger.io/v2/pet

${id}    194214401                            # $ sinaliza uma variavel simples
${name}    Snoopy
&{category}    id=1    name=cachorro          # & sinaliza uma lista com campos fixos
@{photoUrls}                                  # @ sinaliza uma lista com vários registros
&{tag}    id=1    name=vacinado
@{tags}    ${tag}                             # lista de outra lista
${status}    available


*** Test Cases ***
# Descritivo de Negócio + Passos de Automação

Post Pet
    # Montar a mensagem / body
    ${body}    Create Dictionary    id=${id}    category=${category}    name=${name}    photoUrls=${photoUrls}    tags=${tags}    status=${status}
    
    # Executar
    ${response}    POST    url=${url}    json=${body}

    # Validar
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}    # imprimir o retorno da api no terminal

    Status Should Be    200
    Should Be Equal    ${response_body}[id]               ${{int(${id})}}
    Should Be Equal    ${response_body}[name]             ${name}
    Should Be Equal    ${response_body}[tags][0][id]      ${{int(${tag}[id])}}
    Should Be Equal    ${response_body}[tags][0][name]    ${tag}[name]
    Should Be Equal    ${response_body}[status]           ${status}

Get Pet
    ${response}    GET    url=${{$url + '/' + $id}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[name]    ${name}
    Should Be Equal    ${response_body}[category][id]    ${{int(${category}[id])}}
    Should Be Equal    ${response_body}[category][name]    ${category}[name]

Put Pet
    # Montar a mensagem / body
    ${body}    Evaluate    json.loads(open('./fixtures/json/pet2.json').read())

    # Executar
    ${response}    PUT    url=${url}    json=${body}

    # Validar
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}    # imprimir o retorno da api no terminal

    Status Should Be    200
    Should Be Equal    ${response_body}[id]               ${{int(${id})}}
    Should Be Equal    ${response_body}[category][id]    ${{int(${category}[id])}}
    Should Be Equal    ${response_body}[category][name]    ${category}[name]
    Should Be Equal    ${response_body}[name]             ${name}
    Should Be Equal    ${response_body}[tags][0][id]      ${{int(${tag}[id])}}
    Should Be Equal    ${response_body}[tags][0][name]    ${tag}[name]
    Should Be Equal    ${response_body}[status]           sold
    Should Be Equal    ${response_body}[status]           ${body}[status]

Delete Pet
    ${response}    DELETE    url=${{$url + '/' + $id}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]    ${{int(200)}}
    Should Be Equal    ${response_body}[type]    unknown
    Should Be Equal    ${response_body}[message]    ${id}

*** Keywords ***
# Descritivo de Negócio (se estruturar separadamente)
# DSL - Domain Specific Language = Linguagem Especifica de Dominio