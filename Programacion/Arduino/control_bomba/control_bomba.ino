//comunicacion serial entre tarjeta de adquisicion de datos y software de interfaz en labview.

int Tdisparo= 0;  //tiempo del disparo
//int pinPot = 5;  //entrada potenciometro
int pinPULSO = 40, pot = 0; //salida de pulso
int pinzero = 2; //entrada
int INTCERO=0;
int index1;
int index2;
int bomba = 1;
String recepcion;
String Ttex;
String Btex;
boolean flag=0;

void setup() {
  Serial.begin(9600);
  pinMode(pinzero, INPUT); 
  pinMode(pinPULSO, OUTPUT); 
 }


void loop() {
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
    if(bomba==1)
    {
      digitalWrite(pinPULSO, HIGH);
      delay(5);
      }
    
    if(bomba==0)
    {
      digitalWrite(pinPULSO, LOW);
      delay(5);
    }
    
     }
