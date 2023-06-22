
char val; // Data received from the serial port
 int ledAzul1 = 2; 
  int ledAzul2 = 3; 
   int ledRojo1 = 4; 
    int ledRojo2 = 5; 
     int ledVerde = 6; 
          int led13 = 13; 
          int relay = 10;
const int button = 11;

int valor;
#include <Servo.h>
Servo teToca;


     void setup(){
         pinMode(button, INPUT);

   pinMode(ledAzul1, OUTPUT); 
    pinMode(led13, OUTPUT); 
   pinMode(ledAzul2, OUTPUT); 
   pinMode(ledRojo1, OUTPUT); 
   pinMode(ledRojo2, OUTPUT); 
   pinMode(ledVerde, OUTPUT); 
   Serial.begin(9600); // Start serial communication at 9600 bps
   teToca.attach(9);
pinMode(relay, OUTPUT); // Configurar relay como salida o OUTPUT

 }

 void loop() {
   if (Serial.available()) 
   { // If data is available to read,
     val = Serial.read(); // read it and store it in val
   }
   if (val == '1') 
   { // If 1 was received
     digitalWrite(ledAzul1, HIGH); // turn the LED 
          digitalWrite(ledAzul2, HIGH); // turn the LED on
             digitalWrite(ledRojo1, LOW); // otherwise turn it off
          digitalWrite(ledRojo2, LOW); // otherwise turn it off
digitalWrite(led13,HIGH);
          digitalWrite(ledVerde,LOW);

   } 
   else{digitalWrite(ledAzul1,LOW);
   digitalWrite(ledAzul2,LOW);
   }
   
  if(val=='0') {
     digitalWrite(ledAzul1, LOW); // otherwise turn it off
          digitalWrite(ledAzul2, LOW); // otherwise turn it off
     digitalWrite(ledRojo1, HIGH); // turn the LED 
          digitalWrite(ledRojo2, HIGH); // turn the LED on
               digitalWrite(ledVerde,LOW);
delay(10);
   }
  if(val=='2'){
     digitalWrite(ledVerde,HIGH);
         digitalWrite(ledAzul1, LOW); // turn the LED 
          digitalWrite(ledAzul2, LOW); // turn the LED on
             digitalWrite(ledRojo1, LOW); // otherwise turn it off
          digitalWrite(ledRojo2, LOW); // otherwise turn it off
   }
     if(val=='3'){
      
             digitalWrite(ledRojo1, LOW); // otherwise turn it off
          digitalWrite(ledRojo2, LOW); // otherwise turn it off
   }
   if(val=='6'){
teToca.write(int(random(0,5))*36);

   }
   if(val=='2'){
  digitalWrite(relay, HIGH); // envia señal alta al relay
  Serial.println("Relay accionado");
   }
if(val=='8'){
    digitalWrite(relay, LOW);  // envia señal baja al relay
  Serial.println("Relay no accionado");
  digitalWrite(ledVerde,LOW);
}

}

