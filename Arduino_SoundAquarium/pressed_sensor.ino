const int pressA_pin = 0;
const int pressB_pin = 1;
const int pressC_pin = 2;
int inByte = 0;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  establishContact();
}

void loop() {
  // put your main code here, to run repeatedly:
  int value1 = analogRead(pressA_pin);
  int value2 = analogRead(pressB_pin);
  int value3 = analogRead(pressC_pin);

  int ReValue1 = map(value1,0, 1023, 0, 255);

  delay(10);

  int ReValue2 = map(value2,0, 1023, 0, 255);

  delay(10);

  int ReValue3 = map(value3,0, 1023, 0, 255);

  // Serial.print(ReValue1);
  // Serial.print("\t");
  // Serial.print(ReValue2);
  // Serial.print("\t");
  // Serial.println(ReValue3);

  if(Serial.available() > 0){

    inByte = Serial.read();

    Serial.write(ReValue1);
    Serial.write(ReValue2);
    Serial.write(ReValue3);

    delay(10);
  }

}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('T');   // 大文字のAを送る
    delay(300);
  }




}
