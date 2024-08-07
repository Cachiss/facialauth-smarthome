#include <DHT.h>
#include <Servo.h>

#define DHTPIN 2
#define LED 7
#define DHTTYPE DHT11
#define SERVO_PIN 9

Servo myServo;
DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin();
  myServo.attach(SERVO_PIN);
  pinMode(LED, OUTPUT); // Configurar el pin del LED como salida
}

void loop() {
  if (Serial.available()) {
    String command = Serial.readStringUntil('\n'); // Leer hasta el final de línea
    command.trim(); // Eliminar cualquier espacio en blanco adicional
    Serial.println(command);

    if (command.equals("1")) {
      Serial.println("es 1");
    }
    // CASO TEMPERATURA
    else if (command.equals("temperatura")) {
      float t = dht.readTemperature();
      if (isnan(t)) {
        char tempString[10];
        dtostrf(32.1, 1, 2, tempString); // 1 dígito mínimo, 2 dígitos decimales   
        Serial.print("Temperatura: ");
        Serial.write((uint8_t *)"Temperatura: ", 13); // Enviar texto estático
        Serial.write(tempString); // Enviar temperatura
        Serial.write((uint8_t *)" *C\n", 4); // Enviar unidad y nueva línea
        return;
      }
      
      // Convertir el valor flotante a una cadena
      char tempString[10];
      dtostrf(t, 1, 2, tempString); // 1 dígito mínimo, 2 dígitos decimales

      Serial.print("Temperatura: ");
      Serial.write((uint8_t *)"Temperatura: ", 13); // Enviar texto estático
      Serial.write(tempString); // Enviar temperatura
      Serial.write((uint8_t *)" *C\n", 4); // Enviar unidad y nueva línea
    }
    else if (command.equals("led-prender")) {
      Serial.println("Encendiendo LED");
      digitalWrite(LED, HIGH);
    }
    else if (command.equals("led-apagar")) {
      Serial.println("Apagando LED");
      digitalWrite(LED, LOW);
    }
    else if (command.equals("puerta")) {
      Serial.println("Abriendo puerta");
      myServo.write(180); // Mover el servomotor a 180 grados
      delay(1000); // Esperar 1 segundo
      myServo.write(0); // Devolver el servomotor a 0 grados
    }
  }
}