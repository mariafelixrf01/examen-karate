package com.example.karate;

import com.intuit.karate.junit5.Karate;

class RegresionRunnerTest {

	@Karate.Test
	Karate regresion() {
		return Karate.run("classpath:features/regresion.feature");
	}
}
