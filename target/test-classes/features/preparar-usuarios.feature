
Feature: Preparar usuarios para regresion

  Background:
    * url 'http://134.209.211.10:4001'

    # Generar celular peruano de 9 digitos
    * def generarCelular =
      """
      function() {
        return '9' + Math.floor(10000000 + Math.random() * 90000000);
      }
      """

  Scenario: Crear emisor y receptor y preparar saldos

    # 1. Registrar emisor
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
    * print 'Emisor registrado:', emisor
    * match emisor == '#present'

    # 2. Registrar receptor
    * def celularReceptor = generarCelular()
    * match celularReceptor != celularEmisor
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
    * print 'Receptor registrado:', receptor
    * match receptor == '#present'

    # 3. Asignar saldo a ambos usuarios
    # Pendiente: agregar los endpoints reales de la API.

    # 4. Consultar los saldos actuales
    # Pendiente: agregar las consultas reales de saldo.

    # 5. Devolver los datos para otros escenarios
    * def resultado =
      """
      function() {
        return {
          emisor: emisor,
          receptor: receptor,
          celularEmisor: celularEmisor,
          celularReceptor: celularReceptor
        };
      }
      """
    * def resultado = resultado()
