import processing.sound.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
AudioIn microfono;
Amplitude amp;
Amplitude volumenSonido;
String val;
String estado="inicio";
int vidaMaquina=500;
float pisoAmp=0.25;
int contadorTitilar;
int queSonido=1;
int marcaDeTiempoMaquina;
int tiempoFinalMaquina=5000; // TIEMPO DEL TURNO DE LA MAQUINA 1 segundo=1000
int tiempoMaquina;
int marcaDeTiempoJugador;
int tiempoFinalJugador=10000; // TIEMPO DE ZAPATEO DEL TURNO DEL JUGADOR 1 segundo=1000
int tiempoJugador;
int marcaDeTiempoGanaste;
int tiempoFinalGanaste=40000; // TIEMPO PARA CAMBIAR LA RESISTENCIA 1 segundo=1000 (tiempo? quizas mejor boton de reiniciar, veremos)
int tiempoGanaste;
int marcaDeTiempoJuego;
int tiempoJuegoFinal=10000000; //TIEMPO DE INACTIVIDAD EN EL INICIO  1 segundo=1000
int tiempoJuego;
int marcaDeTiempoPerder;
int tiempoFinalPerder=60000; //TIEMPO PARA GANARLE A LA MAQUINA  1 segundo=1000
int tiempoPerder;
int marcaDeTiempoReiniciar;
int tiempoFinalReiniciar=5000; //TIEMPO QUE TARDA EN REINICIAR DESPUES DE PERDER  1 segundo=1000
int tiempoReiniciar;
int marcaDeTiempoSonido;
int tiempoFinalSonido=17000; //TIEMPO QUE TARDA EN REINICIAR DESPUES DE PERDER  1 segundo=1000
int tiempoSonido;
int marcaDeTiempoDelay;
int tiempoFinalDelay=17000; //TIEMPO QUE TARDA EN CERRAR DESPUES DE PERDER  1 segundo=1000
int tiempoDelay;
boolean empezoElJuego=false;
boolean sonar=false;
boolean girarServo;
SoundFile[] sonido;
void setup()
{
  size(1000, 1000);
  amp = new Amplitude(this);
  volumenSonido= new Amplitude(this);
  microfono = new AudioIn(this, 0);
  microfono.start();
  amp.input(microfono);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  sonido= new SoundFile[4];
  for (int i=0; i<sonido.length; i++) {

    sonido[i]=new SoundFile(this, "audio"+i+".wav");
    sonido[i].amp(0.2);
  }

  sonido[0].play();
}

void draw() {
println(estado,tiempoPerder);
  //println(estado, contadorMaquina, contador, vidaMaquina, segundoJuego);
  //println(amp.analyze());
  if (amp.analyze()>0.1 && estado=="inicio") {
    estado="jugador";
    marcaDeTiempoJugador=millis();
    empezoElJuego=true;
    marcaDeTiempoPerder=millis();
  }
  if (estado=="inicio") {
    background(0);
girarServo=true;
    tiempoSonido=millis()-marcaDeTiempoSonido;
        myPort.write('8');

    vidaMaquina=100;
    tiempoGanaste=0;
    tiempoPerder=0;
    marcaDeTiempoGanaste=millis();
    myPort.write('3');
    tiempoJuego=millis()-marcaDeTiempoJuego;

    marcaDeTiempoReiniciar=millis();
    tiempoReiniciar=0;
    //-----------------cuestion sonido-------------//
    if (tiempoSonido>tiempoFinalSonido) {


      sonido[queSonido].play();

      queSonido++;
      marcaDeTiempoSonido=millis();}



    if (queSonido>3) {
      queSonido=0;
      myPort.write('6');

    }
  }


  if (tiempoJuego>tiempoJuegoFinal) {
    estado="perdiste";
  }

  if (empezoElJuego) {
    tiempoPerder=millis()-marcaDeTiempoPerder;
  }
  if (estado=="jugador")
  { for(int i=0; i< sonido.length; i++){
  sonido[i].stop();
  }
  marcaDeTiempoGanaste=millis();
  tiempoGanaste=0;
    marcaDeTiempoMaquina=millis();
    tiempoMaquina=0;
    tiempoJugador=millis()-marcaDeTiempoJugador;
    if (amp.analyze()>pisoAmp) {
      myPort.write('1');
      println("1");
      vidaMaquina--;
    } else {
      myPort.write('3');
    }
  }
  if (tiempoJugador>tiempoFinalJugador ) {
    estado="maquina";
  }
  if (tiempoMaquina>tiempoFinalMaquina) {
    estado="jugador";
  }
  if (estado=="maquina") {
    marcaDeTiempoJugador=millis();

    tiempoMaquina=millis()-marcaDeTiempoMaquina;
    myPort.write('0');
  }
  if (vidaMaquina<=0) {
    estado="ganaste";
  }
  if (tiempoPerder>tiempoFinalPerder && vidaMaquina>0) {
    estado="perdiste";
    marcaDeTiempoReiniciar=millis();
  }
  if (estado=="ganaste") {println(tiempoGanaste);
    tiempoGanaste=millis()-marcaDeTiempoGanaste;
    myPort.write('2');

  }
  if (tiempoGanaste>tiempoFinalGanaste) {
    estado="inicio";
        myPort.write('8');


  }
  if (estado=="perdiste") {
    marcaDeTiempoJuego=millis();
    tiempoJuego=0;
    empezoElJuego=false;
    tiempoReiniciar=millis()-marcaDeTiempoReiniciar;
    marcaDeTiempoPerder=millis();
    tiempoPerder=0;
    contadorTitilar++;
    if (contadorTitilar%15==0) {
      myPort.write('0');
    } else {
      myPort.write("3");
    }

    if (tiempoReiniciar>tiempoFinalReiniciar) {
      contadorTitilar=0;
      marcaDeTiempoReiniciar=millis();
      estado="inicio";
    }
  }
}
