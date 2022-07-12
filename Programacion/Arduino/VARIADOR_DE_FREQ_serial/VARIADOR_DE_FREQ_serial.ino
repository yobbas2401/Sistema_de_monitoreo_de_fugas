
int Tdisparo= 0;  //tiempo del disparo
//int pinPot = 5;  //entrada potenciometro
int pinPULSO = 9, pot = 0; //salida de pulso
int pinzero = 2; //entrada
int INTCERO=0;
int index1;
int index2;
int bomba = 0;
String recepcion;
String Ttex;
String Btex;
boolean flag=0;

void CRUCECERO()
{ 
  digitalWrite(pinPULSO, LOW);
  INTCERO=1;  //incrementamos la variable de pulsos
 // digitalWrite(pinPULSO, LOW);
  //Tdisparo= map(analogRead(pinPot), 0, 1023, 0,8333);
} 
void setup() {
  Serial.begin(9600);
  pinMode(pinzero, INPUT); 
  pinMode(pinPULSO, OUTPUT); 
 attachInterrupt(0,CRUCECERO,RISING);//(Interrupción 0(Pin2),función,Flanco de subida
 
}


void loop() {
  LEERSERIAL();
    if(bomba==1)
    {
      if(INTCERO==1)
      {
      //digitalWrite(pinPULSO, LOW);
      delayMicroseconds(Tdisparo); 
      digitalWrite(pinPULSO, HIGH);   // sets the pin on
      // pauses for 50 microseconds
      //digitalWrite(pinPULSO, LOW);
      INTCERO=0;
      }
    }
    if(bomba==0)
    {
      digitalWrite(pinPULSO, LOW);
    }
    
     }


void LEERSERIAL(){
  if(Serial.available()>0)
  {
  while(Serial.available())
  {
    char c;
    c=Serial.read();
    recepcion+=c;
    if(c=='P')
    {
      flag=1;
      break;
    } 
  }
  }
  if(flag==1)
  {
  index1= recepcion.indexOf('T');
  index2= recepcion.indexOf('B');
  //index3= recepcion.indexOf('P');
  Ttex= recepcion.substring(index1+2, index2-1);
  Btex= recepcion.substring(index2+2);
  //Ytex= recepcion.substring(index2+2, index3);
  Tdisparo = Ttex.toInt();
  bomba = Btex.toInt();
  flag=0;
  recepcion="";
  }
}
