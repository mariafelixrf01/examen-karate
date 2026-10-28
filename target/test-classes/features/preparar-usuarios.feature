Feature: Preparar usuarios para regresion

  Background:
    * def authUrl = 'http://134.209.211.10:4001'
    * def walletUrl = 'http://134.209.211.10:4002'
    * url authUrl
    * def generarCelular =
      """
      function() {
        return '9' + Math.floor(10000000 + Math.random() * 90000000);
      }
      """

  Scenario: Crear usuarios y preparar saldos

    # 1. Registrar Emisor
    * def celularEmisor = generarCelular()
    * def emailEmisor = 'emisor_' + celularEmisor + '@hotmail.com'
    * def emisorRequest =
      """
      {
        phone: '#(celularEmisor)',
        fullName: 'Antony Emisor',
        pin: '654321',
        email: '#(emailEmisor)'
      }
      """

    Given path 'auth', 'v1', 'register'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And request emisorRequest
    When method post
    Then status 201

    * def emisor = response
    * match emisor.user.phone == celularEmisor
    * def emisorId = emisor.user.id

    # 2. Registrar Receptor
    * def celularReceptor = generarCelular()
    * def emailReceptor = 'receptor_' + celularReceptor + '@hotmail.com'
    * def receptorRequest =
      """
      {
        phone: '#(celularReceptor)',
        fullName: 'Antony Receptor',
        pin: '654321',
        email: '#(emailReceptor)'
      }
      """

    Given path 'auth', 'v1', 'register'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And request receptorRequest
    When method post
    Then status 201

    * def receptor = response
    * match receptor.user.phone == celularReceptor
    * def receptorId = receptor.user.id

    # 3. Login del Emisor
    Given url authUrl
    And path 'auth', 'v1', 'login'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And request { phone: '#(celularEmisor)', pin: '654321' }
    When method post
    Then status 200

    * def loginEmisor = response
    * def tokenEmisor = loginEmisor.token
    * match tokenEmisor == '#string'

    # 4. Recargar 500 al Emisor
    Given url walletUrl
    And path 'wallet', 'v1', 'deposit'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And header Authorization = 'Bearer ' + tokenEmisor
    And request { amount: 500 }
    When method post
    Then status 200

    * def recargaEmisor = response
    * print 'Recarga Emisor:', recargaEmisor

    # 5. Login del Receptor
    Given url authUrl
    And path 'auth', 'v1', 'login'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And request { phone: '#(celularReceptor)', pin: '654321' }
    When method post
    Then status 200

    * def loginReceptor = response
    * def tokenReceptor = loginReceptor.token
    * match tokenReceptor == '#string'

    # 6. Recargar 500 al Receptor
    Given url walletUrl
    And path 'wallet', 'v1', 'deposit'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And header Authorization = 'Bearer ' + tokenReceptor
    And request { amount: 500 }
    When method post
    Then status 200

    * def recargaReceptor = response
    * print 'Recarga Receptor:', recargaReceptor

    # 7. Consultar saldo inicial del Emisor
    Given url walletUrl
    And path 'wallet', 'v1', 'balance'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And header Authorization = 'Bearer ' + tokenEmisor
    When method get
    Then status 200

    * def respuestaSaldoEmisor = response
    * print 'Saldo inicial Emisor:', respuestaSaldoEmisor
    * def saldoEmisorInicial = respuestaSaldoEmisor.balance
    * match saldoEmisorInicial == 500

    # 8. Consultar saldo inicial del Receptor
    Given url walletUrl
    And path 'wallet', 'v1', 'balance'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And header Authorization = 'Bearer ' + tokenReceptor
    When method get
    Then status 200

    * def respuestaSaldoReceptor = response
    * print 'Saldo inicial Receptor:', respuestaSaldoReceptor
    * def saldoReceptorInicial = respuestaSaldoReceptor.balance
    * match saldoReceptorInicial == 500

    # 9. Devolver todos los datos a regresion.feature
    * def resultado =
      """
      {
        emisor: '#(emisor)',
        receptor: '#(receptor)',
        emisorId: '#(emisorId)',
        receptorId: '#(receptorId)',
        celularEmisor: '#(celularEmisor)',
        celularReceptor: '#(celularReceptor)',
        tokenEmisor: '#(tokenEmisor)',
        tokenReceptor: '#(tokenReceptor)',
        saldoEmisorInicial: '#(saldoEmisorInicial)',
        saldoReceptorInicial: '#(saldoReceptorInicial)'
      }
      """

    * print 'Preparacion completada correctamente'
    * print 'Saldo inicial Emisor:', saldoEmisorInicial
    * print 'Saldo inicial Receptor:', saldoReceptorInicial