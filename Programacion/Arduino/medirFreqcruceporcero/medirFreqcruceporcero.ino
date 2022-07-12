// period of pulse accumulation and serial output, milliseconds
const int MainPeriod = 100;
long previousMillis = 0; // will store last time of the cycle end
 
volatile unsigned long previousMicros=0;
volatile unsigned long duration=0; // accumulates pulse width
volatile unsigned int pulsecount=0;
 
// interrupt handler
void freqCounterCallback() 
{
  unsigned long currentMicros = micros();
  duration += currentMicros - previousMicros;
  previousMicros = currentMicros;
  pulsecount++;
}
 
void reportFrequency()
{
    float freq = 1e6 / float(duration) * (float)pulsecount;
    Serial.print("Frec:");
    Serial.print(freq);
    Serial.println(" Hz"); 
 
     // clear counters
    duration = 0;
    pulsecount = 0;
}
 
void setup()
{
  Serial.begin(19200); 
  attachInterrupt(0, freqCounterCallback, RISING);
}
 
void loop()
{
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= MainPeriod) 
  {
    previousMillis = currentMillis;    
    reportFrequency();
  }
}
