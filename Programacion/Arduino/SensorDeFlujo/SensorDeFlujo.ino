#define factor_conversion1 7.11
#define factor_conversion2 7.11
volatile long NumPulsos1;//variable para la cantidad de pulsos recibidos por el sensor 1
volatile long NumPulsos2;//variable para la cantidad de pulsos recibidos por el sensosr 2
int PinSensor1 = 2;    //Sensor1 conectado en el pin 2
int PinSensor2 = 3;    //Sensor2 conectado en el pin 3
//float factor_conversion1=7.11, factor_conversion1=7.11;; //factor de conversion para convertir de frecuencia a caudal del sensor 1
float volumen1=0; //volumen del sensor 1
float volumen2=0; //volumen del sensor 1
long dt=0; //variación de tiempo por cada bucle
long t0=0; //millis() del bucle anterior


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
//---Función para obtener frecuencia de los pulsos--------
int ObtenerFrecuecia1() 
{
  int frecuencia1;
  NumPulsos1 = 0;   //Ponemos a 0 el número de pulsos
  interrupts();    //Habilitamos las interrupciones
  delay(500);   //muestra de 1 segundo
  noInterrupts(); //Deshabilitamos  las interrupciones
  frecuencia1=NumPulsos1; //Hz(pulsos por segundo)
  return frecuencia1;
}
//Funcion para obtener frecuencia del sensor 2
int ObtenerFrecuecia2() 
{
  int frecuencia2;
  NumPulsos2 = 0;   //Ponemos a 0 el número de pulsos
  interrupts();    //Habilitamos las interrupciones
  delay(500);   //muestra de 1 segundo
  noInterrupts(); //Deshabilitamos  las interrupciones
  frecuencia2=NumPulsos2; //Hz(pulsos por segundo)
  return frecuencia2;
}
void setup()
{ 
  Serial.begin(19200); 
  pinMode(PinSensor1, INPUT); 
  pinMode(PinSensor2, INPUT); 
  attachInterrupt(0,ContarPulsos1,RISING);//(Interrupción 0(Pin2),función,Flanco de subida)
  attachInterrupt(1,ContarPulsos2,RISING);
  t0=millis();
} 

void loop ()    
{
  //-----Enviamos por el puerto serie---------------
  /*Serial.print ("Numero de Pulsos en Sensor1 = "); 
  Serial.println (NumPulsos1); 
  Serial.print ("Numero de Pulsos en Sensor2 = "); 
  Serial.println (NumPulsos2);
  delay(50);*/
 // if (Serial.available()) {
    if(Serial.read()=='r')volumen1=0;//restablecemos el volumen1 si recibimos 'r'
    if(Serial.read()=='t')volumen2=0;//restablecemos el volumen2 si recibimos 't'
 // }
  float frecuencia1=ObtenerFrecuecia1()*2; //obtenemos la frecuencia de los pulsos del sensor 1 en Hz
  float frecuencia2=ObtenerFrecuecia2()*2; //obtenemos la frecuencia de los pulsos del sensor 2 en Hz
  float caudal1_L_m=frecuencia1/factor_conversion1; //calculamos el caudal en L/m
  float caudal2_L_m=frecuencia2/factor_conversion2; //calculamos el caudal en L/m
  dt=millis()-t0; //calculamos la variación de tiempo
  t0=millis();
  volumen1=volumen1+(caudal1_L_m/60)*(dt/1000); // volumen(L)=caudal(L/s)*tiempo(s)
  volumen2=volumen2+(caudal2_L_m/60)*(dt/1000); // volumen(L)=caudal(L/s)*tiempo(s)


   //-----Enviamos por el puerto serie---------------
  Serial.print ("Caudal: "); 
  Serial.print (caudal1_L_m,3); 
  Serial.print ("L/min\tVolumen: "); 
  Serial.print (volumen1,3); 
  Serial.println (" L");
  Serial.print ("Caudal: "); 
  Serial.print (caudal2_L_m,3); 
  Serial.print ("L/min\tVolumen: "); 
  Serial.print (volumen2,3); 
  Serial.println (" L");
}
