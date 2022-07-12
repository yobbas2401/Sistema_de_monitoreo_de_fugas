
int Tdisparo= 7000;  //tiempo del disparo
int pinPot = 5;  //entrada potenciometro
int pinPULSO = 5, pot = 0; //salida de pulso
int pinzero = 0; //entrada
int INTCERO=0;

void CRUCECERO()
{ 
  INTCERO=1;  //incrementamos la variable de pulsos
  digitalWrite(pinPULSO, LOW);
  Tdisparo= map(analogRead(pinPot), 0, 1023, 0,8333);
} 
void setup() {
  Serial.begin(9600);
  pinMode(pinzero, INPUT); 
  pinMode(pinPot, INPUT);
  pinMode(pinPULSO, OUTPUT); 
 attachInterrupt(pinzero,CRUCECERO,RISING);//(Interrupción 0(Pin2),función,Flanco de subida
 
}


void loop() {
      
      if(INTCERO==1){
      delayMicroseconds(Tdisparo); 
      digitalWrite(pinPULSO, HIGH);   // sets the pin on
      // pauses for 50 microseconds
      //digitalWrite(pinPULSO, LOW);
      INTCERO=0;
      }
      
     }
