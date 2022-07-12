volatile unsigned int cuenta = 0;
bool ESTADO = false;
void setup() { 
 pinMode(13,OUTPUT);
 
 SREG = (SREG & 0b01111111); //Desabilitar interrupciones
 TIMSK2 = TIMSK2|0b00000001; //Habilita la interrupcion por desbordamiento
 TCCR2B = 0b00000111; //Configura preescala para que FT2 sea de 7812.5Hz
 SREG = (SREG & 0b01111111) | 0b10000000; //Habilitar interrupciones //Desabilitar interrupciones
 
}


void loop() {

}

ISR(TIMER2_OVF_vect){
    cuenta++;
    if(cuenta > 29) {
      digitalWrite(13,ESTADO);
      ESTADO = !ESTADO;
      cuenta=0;
    }
 
 
  
}
