#define factor_conversion1 7.5
#define factor_conversion2 7.5
float TiempoMuestreo=200; //en segundos
volatile long NumPulsos1;//variable para la cantidad de pulsos recibidos por el sensor 1
volatile long NumPulsos2;//variable para la cantidad de pulsos recibidos por el sensosr 2
int PinSensor1 = 21;    //Sensor1 conectado en el pin 2
int PinSensor2 = 20;    //Sensor2 conectado en el pin 3/float factor_conversion
int pinsensorpresion0 = 0;
int pinsensorpresion1 = 1;
float volumen1=0.0; //volumen del sensor 1
float volumen2=0.0; //volumen del sensor 1
float Fre1=0.0;
float Fre2=0.0;
float TM=0;
long dt=0; //variación de tiempo por cada bucle
long t0=0; //millis() del bucle anterior
char Tm=' ';
int u1=1000, u2=504;
int pinBomba = 12;
//comunicacion
String recepcion;
int index1;
int index2;
String Btex;
String Ttex;
int flag=0;
int bomba=1;

void setup()
{ 
  Serial.begin(9600); 
  pinMode(PinSensor1, INPUT); 
  pinMode(PinSensor2, INPUT); 
  pinMode(pinBomba, OUTPUT);
  attachInterrupt(2,ContarPulsos1,RISING);//(Interrupción 0(Pin2),función,Flanco de subida)
  attachInterrupt(3,ContarPulsos2,RISING);
  t0=millis();
} 

void loop ()    
{
  
  //u1= analogRead(pinsensorpresion0);
  //u2= analogRead(pinsensorpresion1);
 
  float frecuencia1=0.0; //obtenemos la frecuencia de los pulsos del sensor 1 en Hz
  float frecuencia2=0.0; //obtenemos la frecuencia de los pulsos del sensor 2 en Hz
  NumPulsos1 = 0;
  NumPulsos2 = 0;//Ponemos a 0 el número de pulsos
  interrupts();    //Habilitamos las interrupciones
  delay(TiempoMuestreo);   //muestra de 200ms 
  noInterrupts(); //Deshabilitamos  las interrupciones
  frecuencia1=NumPulsos1/(TiempoMuestreo/1000); //Hz(pulsos por segundo)
  frecuencia2=NumPulsos2/(TiempoMuestreo/1000);
  Fre1=frecuencia1;
  Fre2=frecuencia2;
  float caudal1_L_m=frecuencia1/factor_conversion1; //calculamos el caudal en L/m
  float caudal2_L_m=frecuencia2/factor_conversion2; //calculamos el caudal en L/m
  dt=millis()-t0; //calculamos la variación de tiempo
  t0=millis();
  
  volumen1=volumen1+(caudal1_L_m/60.0)*(dt/1000.0); // volumen(L)=caudal(L/s)*tiempo(s)
  volumen2=volumen2+(caudal2_L_m/60.0)*(dt/1000.0); // volumen(L)=caudal(L/s)*tiempo(s)
  u1= analogRead(pinsensorpresion0);
  u2= analogRead(pinsensorpresion1);
  LEERSERIAL();
  if (bomba==0){
    digitalWrite(pinBomba, LOW);
  } 
  if (bomba==1){
    digitalWrite(pinBomba, HIGH);
  }                      

   //-----Enviamos por el puerto serie--------------- 
  Serial.println (caudal1_L_m,3); 
  Serial.println (caudal2_L_m,3); 
  Serial.println (volumen1,3);
  Serial.println (volumen2,3); 
  Serial.println (Fre1,3); 
  Serial.println (Fre2,3);
  Serial.println (u1); 
  Serial.println (u2);
  Serial.println (bomba);
  Serial.println ("P");
}

//Funcion para leer serial
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
  TiempoMuestreo= Ttex.toInt();
  bomba = Btex.toInt();
  flag=0;
  recepcion="";
  }
}
//---Función que se ejecuta en interrupción---------------
void ContarPulsos1()
{ 
  NumPulsos1++;  //incrementamos la variable de pulsos
} 
//---Función que se ejecuta en interrupción---------------
void ContarPulsos2()
{
  NumPulsos2++;//incrementamos la variable de pulsos
}
