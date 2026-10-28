
Feature: Regresion de usuarios

  Background:
    * url baseUrl
    * def datos = callonce read('preparar-usuarios.feature')
    * def emisor = datos.resultado.emisor
    * def receptor = datos.resultado.receptor
    * def celularEmisor = datos.resultado.celularEmisor
    * def celularReceptor = datos.resultado.celularReceptor

  Scenario: Validar usuarios registrados
    * match emisor == '#present'
    * match receptor == '#present'
    * match emisor.user == '#present'
    * match receptor.user == '#present'
    * match celularEmisor == '#regex 9[0-9]{8}'
    * match celularReceptor == '#regex 9[0-9]{8}'
    * match celularEmisor != celularReceptor

  Scenario: Validar que los celulares sean distintos
    * match emisor.user.phone == celularEmisor
    * match receptor.user.phone == celularReceptor
    * match emisor.user.phone != receptor.user.phone
