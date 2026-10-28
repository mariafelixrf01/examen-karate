Feature: Regresion de transferencia entre usuarios

  Background:
    * def datos = callonce read('preparar-usuarios.feature')
    * def receptorId = datos.resultado.receptorId
    * def tokenEmisor = datos.resultado.tokenEmisor
    * def tokenReceptor = datos.resultado.tokenReceptor
    * def saldoEmisorInicial = datos.resultado.saldoEmisorInicial
    * def saldoReceptorInicial = datos.resultado.saldoReceptorInicial

  Scenario: Transferir 450 del Emisor al Receptor y validar

    # 1. Validar tokens
    * match tokenEmisor == '#string'
    * match tokenReceptor == '#string'

    # 2. Transferir 450 del Emisor al Receptor
    Given url transactionUrl
    And path 'transaction', 'v1', 'transfer'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And header Authorization = 'Bearer ' + tokenEmisor
    And request
      """
      {
        recipientId: '#(receptorId)',
        amount: 450,
        description: 'Pago de Servicios',
        categoryId: 'cat_food_1'
      }
      """
    When method post
    Then status 200
    * def transferencia = response
    * print 'Respuesta de transferencia:', transferencia
    * def codigoTransaccion = transferencia.transactionId
    * match codigoTransaccion == '#string'

    # 3. Validar saldo final del Emisor
    Given url walletUrl
    And path 'wallet', 'v1', 'balance'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And header Authorization = 'Bearer ' + tokenEmisor
    When method get
    Then status 200
    * def saldoEmisorFinalRespuesta = response
    * print 'Saldo final Emisor:', saldoEmisorFinalRespuesta
    * def saldoEmisorFinal = saldoEmisorFinalRespuesta.balance
    * match saldoEmisorFinal == saldoEmisorInicial - 450

    # 4. Validar saldo final del Receptor
    Given url walletUrl
    And path 'wallet', 'v1', 'balance'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And header Authorization = 'Bearer ' + tokenReceptor
    When method get
    Then status 200
    * def saldoReceptorFinalRespuesta = response
    * print 'Saldo final Receptor:', saldoReceptorFinalRespuesta
    * def saldoReceptorFinal = saldoReceptorFinalRespuesta.balance
    * match saldoReceptorFinal == saldoReceptorInicial + 450

    # 5. Consultar estadísticas del Receptor
    Given url walletUrl
    And path 'wallet', 'v1', 'stats'
    And param startDate = '2026-10-01'
    And param endDate = '2026-10-31'
    And header Content-Type = 'application/json'
    And header x-channel = 'POSTMAN'
    And header Authorization = 'Bearer ' + tokenReceptor
    When method get
    Then status 200

    * def estadisticasReceptor = response
    * print 'Estadisticas del Receptor:', estadisticasReceptor

    # 6. Validar el ingreso y el saldo del Receptor
    * match estadisticasReceptor.income == 950
    * match estadisticasReceptor.expense == 0
    * match estadisticasReceptor.balance == saldoReceptorInicial + 450

    # 7. Confirmar que la transferencia fue completada
    * match transferencia.status == 'COMPLETED'
    * match transferencia.transactionId == '#string'
    * print 'Codigo de transaccion:', transferencia.transactionId
    * print 'Regresion completada correctamente'