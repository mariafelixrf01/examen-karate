# examen-karate

## Estructura de pruebas

Las pruebas de Karate viven en `src/test/resources/features` y sus runners JUnit 5
en `src/test/java/com/example/karate`. La configuracion compartida esta en
`src/test/resources/karate-config.js`.

`regresion.feature` ejecuta la preparacion una sola vez y reutiliza los usuarios
y sus saldos en los escenarios de validacion. `preparar-usuarios.feature` genera
celulares aleatorios, crea el emisor y el receptor, les asigna saldo y devuelve
los datos para la regresion. La base URL predeterminada es `http://134.209.211.10`;
puedes indicar otra URL con la propiedad `baseUrl`:

```bash
./mvnw test -DbaseUrl=http://servidor-de-pruebas
```

La API debe exponer las rutas `usuarios` y `usuarios/{id}/saldo`. Una respuesta
distinta de `201` al crear usuario o de `200` al asignar saldo hace fallar las
aserciones, incluido el rechazo de un celular que ya exista.