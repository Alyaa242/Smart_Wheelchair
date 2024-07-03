#include <SoftwareSerial.h>

int enA  = 3;
int inA1 = 4;
int inA2 = 5;

int enB  = 9;
int inB1 = 14;
int inB2 = 15;

int Tx   = 11;
int Rx   = 12;

SoftwareSerial bluetooth(Rx, Tx);

void setup() {
  pinMode(enA,  OUTPUT);
  pinMode(inA1, OUTPUT);
  pinMode(inA2, OUTPUT);

  pinMode(enB,  OUTPUT);
  pinMode(inB1, OUTPUT);
  pinMode(inB2, OUTPUT);

  digitalWrite(enA, HIGH);
  digitalWrite(enB, HIGH);

  analogWrite(enA,128);
  analogWrite(enB,128);

  bluetooth.begin(38400);
}

void loop() {
  while (!bluetooth.available());
  byte mode = bluetooth.read();

  if (mode >= '0' && mode <= '4') {
    bool F = (mode == '1');
    bool B = (mode == '2');
    bool R = (mode == '3');
    bool L = (mode == '4');

    digitalWrite(inA1, F | L);
    digitalWrite(inA2, B | R);
    digitalWrite(inB1, F | R);
    digitalWrite(inB2, B | L);
  }
}
