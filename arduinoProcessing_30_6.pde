import processing.sound.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
AudioIn microfono;
Amplitude amp;
Amplitude volumenSonido;
Amplitude volumenMaquina1;
Amplitude volumenMaquina2;
Amplitude volumenMaquina3;
Amplitude volumenMaquina4;
Amplitude volumenMaquinaZapateo1;
Amplitude volumenMaquinaZapateo2;
Amplitude volumenMaquinaZapateo3;
int numDeImagen;
PImage muerte[];
String val;
String estado="inicio";
int vidaMaquina=500;
float pisoAmp=0.25;
float a=0;
float moverCirculoZapateo;
int estadoZapateo=0;
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
int tiempoFinalReiniciar=3500; //TIEMPO QUE TARDA EN REINICIAR DESPUES DE PERDER  1 segundo=1000
int tiempoReiniciar;
int marcaDeTiempoSonido;
int tiempoFinalSonido=17000; //TIEMPO QUE TARDA EN REINICIAR DESPUES DE PERDER  1 segundo=1000
int tiempoSonido;
int marcaDeTiempoDelay;
int tiempoFinalDelay=17000; //TIEMPO QUE TARDA EN CERRAR DESPUES DE PERDER  1 segundo=1000
int tiempoDelay;
int tdeJugador=10000;
int empezo, tiempoDeZapateo;
boolean empezoElJuego=false;
boolean sonar=false;
boolean girarServo;
boolean yaEligio;
SoundFile[] sonido;
SoundFile[] resp;
SoundFile base, risa;
PImage risas;
boolean zapatear=true, respuestaM=false, setear=true;
int estados=0;
int[] tdeMaquina = { 8000, 13000, 17000 };
int empezarJuego, marcaDeTiempoInicio;
void setup()
{
  //size(1000, 1000);
  fullScreen();
  amp = new Amplitude(this);
  volumenSonido= new Amplitude(this);

  volumenMaquina1=new Amplitude  (this);
  volumenMaquina2=new Amplitude  (this);
  volumenMaquina3=new Amplitude  (this);
  volumenMaquina4=new Amplitude  (this);
  volumenMaquinaZapateo1=new Amplitude  (this);
  volumenMaquinaZapateo2=new Amplitude  (this);
  volumenMaquinaZapateo3=new Amplitude  (this);

  microfono = new AudioIn(this, 0);
  muerte=new PImage[99];
  microfono.start();
  amp.input(microfono);
  //String portName = Serial.list()[0];
  // myPort = new Serial(this, portName, 9600);
  sonido= new SoundFile[4];
  for (int i=0; i<sonido.length; i++) {

    sonido[i]=new SoundFile(this, "audio"+i+".wav");
    sonido[i].amp(0.2);
  }

  sonido[0].play();
  resp= new SoundFile[3];
  for (int i=0; i<resp.length; i++) {

    resp[i]=new SoundFile(this, "resp"+i+".wav");
    resp[i].amp(0.2);
  }
  for (int i=0; i<muerte.length; i++) {

    muerte[i]=loadImage("imagenes/img("+i+").jpg");
  }
  base= new SoundFile(this, "base.wav");
  risa= new SoundFile(this, "risa.wav");
  risa.amp(0.5);
  risas= loadImage("risaM.jpg");
  volumenMaquina1.input(sonido[0]);
  volumenMaquina2.input(sonido[1]);
  volumenMaquina3.input(sonido[2]);
  volumenMaquina4.input(sonido[3]);
  volumenMaquinaZapateo1.input(resp[0]);
  volumenMaquinaZapateo2.input(resp[1]);
  volumenMaquinaZapateo3.input(resp[2]);
}

void draw() {
  fill(0);
  rect(0, 0, width, height);
  println(estado, tiempoPerder);
  //println(estado, contadorMaquina, contador, vidaMaquina, segundoJuego);
  //println(amp.analyze());
  if (amp.analyze()>0.02 && estado=="inicio" && yaEligio) {
    estado="jugador";
    marcaDeTiempoJugador=millis();
    empezoElJuego=true;
    marcaDeTiempoPerder=millis();
    yaEligio=false;
  }
  if (estado=="inicio") {
    risa.stop();
    background(0);

    empezarJuego=millis()-marcaDeTiempoInicio;
    girarServo=true;
    tiempoSonido=millis()-marcaDeTiempoSonido;
    // myPort.write('8');


    vidaMaquina=600;
    tiempoGanaste=0;
    tiempoPerder=0;
    marcaDeTiempoGanaste=millis();
    //myPort.write('3');
    tiempoJuego=millis()-marcaDeTiempoJuego;


    tiempoReiniciar=0;
    //-----------------cuestion sonido-------------//
    if (tiempoSonido>tiempoFinalSonido) {


      sonido[queSonido].play();

      queSonido++;
      marcaDeTiempoSonido=millis();
    }



    if (queSonido>3) {
      queSonido=1;
      // myPort.write('6');
      yaEligio=true;
    }
    a=volumenMaquina4.analyze()*100;
    if (queSonido==1) {
      a=volumenMaquina1.analyze()*100;
    }
    if (queSonido==2) {
      a=volumenMaquina2.analyze()*100;
    }
    if (queSonido==3) {
      a=volumenMaquina3.analyze()*100;
    }


    push();
    noFill();
    strokeWeight(10);
    stroke(255, 0, 0);
    //circle(100*a,height/2,200);
    bezier(100.0, 540.0, 490.0, 266.0+a*100, 1290.0, 847.0-a*100, 1820.0, 540.0);

    pop();
    println(a, volumenMaquina1.analyze(), queSonido);
  }




  if (empezoElJuego) {
    tiempoPerder=millis()-marcaDeTiempoPerder;
  }
  if (estado=="jugador")
  {
    for (int i=0; i< sonido.length; i++) {
      sonido[i].stop();
    }
    marcaDeTiempoGanaste=millis();
    tiempoGanaste=0;
    marcaDeTiempoMaquina=millis();
    tiempoMaquina=0;
    tiempoJugador=millis()-marcaDeTiempoJugador;
    jugar();
  }




  if (estado=="ganaste") {
    println(tiempoGanaste, numDeImagen);
    tiempoGanaste=millis()-marcaDeTiempoGanaste;
    //myPort.write('2');
    numDeImagen++;
    if (numDeImagen>98) {
      numDeImagen=0;
    }
    image(muerte[numDeImagen], 0, 0);
    image(muerte[numDeImagen], 0, height/2);
    image(muerte[numDeImagen], width/2, height/2);

    image(muerte[numDeImagen], width/2, 0);
  }
  if (tiempoGanaste>tiempoFinalGanaste) {
    estado="inicio";
    //myPort.write('8');
    estados=0;
    zapatear=true;
    respuestaM=false;
    setear=true;
  }
  if (estado=="perdiste") {


    image(risas, 0, 0);
    tiempoJuego=0;
    empezoElJuego=false;
    println(tiempoReiniciar);
    marcaDeTiempoPerder=millis();
    tiempoReiniciar=millis()-marcaDeTiempoReiniciar;
    tiempoPerder=0;
    contadorTitilar++;
    if (contadorTitilar%15==0) {
      //myPort.write('0');
    } else {
      //myPort.write("3");
    }

    if (tiempoReiniciar>tiempoFinalReiniciar) {
      image(risas, 0, 0);
      marcaDeTiempoInicio=millis();
      contadorTitilar=0;
      risa.stop();
      sonido[0].play();
      zapatear=true;
      respuestaM=false;
      setear=true;
      estados=0;
      estado="inicio";
    }
  }
}

void zapatear() {
  if ( setear==true) {
    empezo=millis();
    setear=false;
    base.play();
  }
  tiempoDeZapateo=millis()-empezo;
  if (tiempoDeZapateo<tdeJugador) {

    if (amp.analyze()>pisoAmp && estadoZapateo==0) {
      // myPort.write('1');
      println("1");
      vidaMaquina=200;
      fill(random(0, 255), random(0, 255), random(0, 255), 60);
      rect(random(0, width), random(0, height), random(10, 200), random(10, 150));
      rect(random(0, width), random(0, height), random(10, 200), random(10, 150));
      rect(random(0, width), random(0, height), random(10, 200), random(10, 150));
    } else if (amp.analyze()>pisoAmp && estadoZapateo==1) {
      // myPort.write('1');
      println("1");
      vidaMaquina=200;
      fill(random(0, 255), random(0, 255), random(0, 255), 180);
      rect(random(0, width), random(0, height), random(10, 200), random(50, 300));
      rect(random(0, width), random(0, height), random(10, 200), random(50, 300));
      rect(random(0, width), random(0, height), random(10, 200), random(50, 300));
    } else if (amp.analyze()>pisoAmp && estadoZapateo==2) {
      // myPort.write('1');
      println("1");
      vidaMaquina=200;
      fill(random(0, 255), random(0, 255), random(0, 255), 255);
      rect(random(0, width), random(0, height), random(100, 500), random(100, 500));
      rect(random(0, width), random(0, height), random(100, 500), random(100, 500));
      rect(random(0, width), random(0, height), random(100, 500), random(100, 500));
    } else {
      // myPort.write('3');
      vidaMaquina--;
      println("vida= "+vidaMaquina);
    }
  } else {
    base.stop();
    tiempoDeZapateo=0;
    zapatear=false;
    respuestaM=true;
    estados=estados+1;
    setear=true;
  }
  if (vidaMaquina<1) {
    marcaDeTiempoReiniciar=millis();
    base.stop();
  }
}
void respuestaMaquina(int NumRespuesta) {
  if ( setear==true) {
    empezo=millis();
    setear=false;
    resp[NumRespuesta].play();
  }
  tiempoDeZapateo=millis()-empezo;
  if (tiempoDeZapateo<tdeMaquina[NumRespuesta]) {
  } else {
    base.stop();
    tiempoDeZapateo=0;
    zapatear=true;
    respuestaM=false;
    estados=estados+1;
    setear=true;
  }
}
void jugar() {
  float a;
  push();
  fill(255, 0, 0);
  if (vidaMaquina<1) {
    risa.play();
    estado="perdiste";
  } else if (estados==0&&zapatear==true&&respuestaM==false) {
    estadoZapateo=0;

    zapatear();
  } else if (estados==1&&zapatear==false&&respuestaM==true) {
    respuestaMaquina(0);
    a=volumenMaquinaZapateo1.analyze()*1000;
    rect(width/4, height/4+-a, 500, 500);
    rect(width*0.70, height/4+a, 500, 500);
  } else if (estados==2&&zapatear==true&&respuestaM==false) {
    estadoZapateo=1;

    zapatear();
  } else if (estados==3&&zapatear==false&&respuestaM==true) {
    respuestaMaquina(1);
    a=volumenMaquinaZapateo2.analyze()*1000;
    rect(width/4, height/4+-a, 500, 500);
    rect(width*0.70, height/4+a, 500, 500);
  } else  if (estados==4&&zapatear==true&&respuestaM==false) {
    estadoZapateo=2;

    zapatear();
  } else if (estados==5&&zapatear==false&&respuestaM==true) {
    respuestaMaquina(2);
    estado="ganaste";
  }
  pop();
}
