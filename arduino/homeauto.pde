#include <ShiftRegLCD.h>
#include <Servo.h>
#include <TimeAlarms.h>
#include <Time.h>

// 1 hour, max time a Relay can stay ON
#define OPEN_MAX_SECONDS 3600
#define RELAY_OFF 0


//ShiftRegLCD srlcd(7, 8, 9, 2);
ShiftRegLCD srlcd(9, 10, 11, 2);// temporary test values

// define the pins connected to 74HC595
const int latchPin = 4; // ST_CP of 74HC595
const int clockPin = 5; // SH_CP of 74HC595
const int dataPin = 3; // DS of 74HC595
// pin for detecting the IR impulses
const int irDetectPin = 2;
//const int buttonPin = 10; // the number of the pushbutton pin
const int buttonPin = 4; // temporary test values
const int servoPin = 7; 

// variables will change:
int buttonState = 0; // variable for reading the pushbutton status
int doOnce = false;
int menuCount = 0;
int menuOptionCount = 1;

static unsigned char ARROW_RIGHT = 0x7e;
static unsigned char ARROW_LEFT = 0x7f;

// create servo object to control a servo 
Servo myservo; 
// variable to store the servo position
int servopos = 20; 

#define MAXVALUES 40
// vars for reading the data from serial
char inData[MAXVALUES];
byte index = 0; // Index into array; where to store the character
float month_cost = 0.0;
float today_cost = 0.0;
float hour_cost = 0.0;
int valve_on = 0; // which valve to be open. 0 = none
int valve_on_period = 0; //minutes 
int water_heater = 1;  // 1 = hot, 0 = cold
int hh = 0; // hour
int mm = 0;  // min
int ss = 0;  // sec
int mnt = 0;  //month
int dday = 0;  //day
int yyear = 0;  // year

/***********************************************************************************************/
void irImpulse()
{
  Serial.println("b_snd_cmd");
}

/***********************************************************************************************/
void setup()
{
  Serial.begin(9600);
  //Interrupt 0 is digital pin 2, so that is where the IR detector is connected
  //Triggers on FALLING (change from HIGH to LOW)
  attachInterrupt(0, irImpulse, FALLING);
  digitalWrite(2, HIGH);
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
  Alarm.timerOnce(2, DoRelaysOFF);
  //Alarm.timerRepeat(15, PrintDisplay);            // timer for every 30 seconds 
}

/***********************************************************************************************/
void loop()
{

  if(Serial.available() > 0)          // If the serial port is available and sending data...
  {
    if((char)Serial.read() == 's')
    {                  
      getSerialValues();
      DecodeSerialString();
      setTime(hh,mm,ss,mnt,dday,yyear); 
      PrintDisplay();
    }
  }

  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);
  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  if ((buttonState == HIGH) && !doOnce)
  {
    doOnce = true;
  }
  else if (buttonState == LOW)
  {
    doOnce = false;
  }
  Alarm.delay(50);
}

/***********************************************************************************************/
void PrintDisplay()
{
  srlcd.clear();
  srlcd.setCursor(0,0);
  // digital clock display of the time
  srlcd.print("Current time: ");
  srlcd.print(hour());
  srlcd.print(":");
  int digits = minute();
  if(digits < 10)
    srlcd.print('0');
  srlcd.print(digits);
  // show the cost
  srlcd.setCursor(0,1);
  srlcd.print("Month cost: $");
  srlcd.print(month_cost);
  srlcd.setCursor(0,2);
  srlcd.print("Day cost:  ");
  if(today_cost > 100.0)
  { 
    srlcd.print("$");
    srlcd.print(today_cost/100.0);
  }
  else
  {
    srlcd.print(today_cost);
    srlcd.print("c");
  }
  srlcd.setCursor(0,3);
  srlcd.print("Hour cost:  ");
  if(hour_cost > 100.0)
  { 
    srlcd.print("$");
    srlcd.print(hour_cost/100.0);
  }
  else
  {
    srlcd.print(hour_cost);
    srlcd.print("c");
  }  
}

/***********************************************************************************************/
void getSerialValues()
{
  byte bytesread = 0;
  byte val = 0;
  while ( bytesread < MAXVALUES ) // Read 10 digit code
  {                        
    if( Serial.available() > 0)   // Check to make sure data is coming on the serial line
    { 
      val = Serial.read();        // Store the current ASCII byte in val
      if(((char)val == 'e') || (val < 46) || (val > 57)) // if end of communication (e) or invalid chars
      {                           // If header or stop bytes before the 10 digit reading
        break;                    // Stop reading                                 
      }
      inData[bytesread] = val;
      bytesread++;           // Increment the counter to keep track
    }
  }
  Alarm.delay(1000);
  Serial.flush();
}
/***********************************************************************************************/
void DecodeSerialString()
{
  char varArray[8];
  int i = 0;
  int k = 0; // offset for the $/c char that comes after the float value
  // get month to date cost
  memcpy(varArray, inData+(k*8), 7);
  varArray[7] = 0; 
  month_cost = atof(varArray);
  k++;
  // get day cost
  memcpy(varArray, inData+(k*8), 7);
  varArray[7] = 0; 
  today_cost = atof(varArray);
  k++;
  // get hour cost
  memcpy(varArray, inData+(k*8), 7);
  varArray[7] = 0; 
  hour_cost = atof(varArray);
  k++;
  k = k * 8;
  // get the valve to be ON (0 = none)
  i = 1; // lenght of the valve value
  memcpy(varArray, inData + k, i);
  varArray[i] = 0;
  valve_on = atoi(varArray); 
  k = k + i;
  // get the period for the valve to be ON
  i = 2; // lenght of the valve period value
  memcpy(varArray, inData + k, i);
  varArray[i] = 0;
  valve_on_period = atoi(varArray); 
  k = k + i;
  // get the period for the valve to be ON
  i = 1; // lenght of the water heater setting
  memcpy(varArray, inData + k, i);
  varArray[i] = 0;
  water_heater = atoi(varArray); 
  k = k + i;
  // get the hour
  i = 2; // lenght of hour 
  memcpy(varArray, inData + k, i);
  varArray[i] = 0;
  hh = atoi(varArray); 
  k = k + i;
  // get the min 
  i = 2; // lenght of min
  memcpy(varArray, inData + k, i);
  varArray[i] = 0;
  mm = atoi(varArray); 
  k = k + i;
  // get the sec 
  i = 2; // lenght of sec 
  memcpy(varArray, inData + k, i);
  varArray[i] = 0;
  ss = atoi(varArray); 
  k = k + i;
  // get the month 
  i = 2; // lenght of month 
  memcpy(varArray, inData + k, i);
  varArray[i] = 0;
  mnt = atoi(varArray); 
  k = k + i;
  // get the day 
  i = 2; // lenght of day 
  memcpy(varArray, inData + k, i);
  varArray[i] = 0;
  dday = atoi(varArray); 
  k = k + i;
  // get the 
  i = 2; // lenght of 
  memcpy(varArray, inData + k, i);
  varArray[i] = 0;
  yyear = atoi(varArray); 
  k = k + i;
}

/***********************************************************************************************/
void DoRelayON(byte avalue)
{
  //ground latchPin and hold low for as long as you are transmitting
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, avalue); 
  //return the latch pin high to signal chip that it 
  //no longer needs to listen for information
  digitalWrite(latchPin, HIGH);
  Alarm.timerOnce(OPEN_MAX_SECONDS, DoRelaysOFF);
}

/***********************************************************************************************/
void DoRelaysOFF()
{
  //ground latchPin and hold low for as long as you are transmitting
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, RELAY_OFF); 
  //return the latch pin high to signal chip that it 
  //no longer needs to listen for information
  digitalWrite(latchPin, HIGH);
}


/***********************************************************************************************/
void TemperatureLow()  
{
  // moves the servo for the water heater in the position for LOW 
  for(; servopos < 60; servopos += 1)  // goes from 0 degrees to 180 degrees 
  {                                    // in steps of 1 degree 
    myservo.write(servopos);           // tell servo to go to position in variable 'pos' 
    Alarm.delay(3);                    // waits 15ms for the servo to reach the position 
  }
}

/***********************************************************************************************/
void TemperatureHigh()
{
  // moves the servo for the water heater in the position for HIGH 
  for(; servopos>=20; servopos-=1) // goes from 180 degrees to 0 degrees 
  {                                
    myservo.write(servopos);       // tell servo to go to position in variable 'pos' 
    Alarm.delay(3);                // waits 15ms for the servo to reach the position 
  }    
}




