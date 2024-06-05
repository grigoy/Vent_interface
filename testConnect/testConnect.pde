int speed = 9600;

import processing.serial.*;
Serial serial;
import controlP5.*;
ControlP5 cp5;
String portName = "COM9";     // имя порта
int[] packet = {0x02, 0x06, 0x00, 0x00, 0x01, 0x90, 0x88, 0x05};
int pollTimer, respTimer;
byte[] rxBuff = new byte[20];
int reqCntr = 0, respCntr = 0;
int MBdelay = 50;
boolean out = false; 

void setup() {
  size(400, 400);    // размер окна
  setupGUI();        // инициализация интерфейса
  pollTimer = millis();
}

void draw() {
  background(200);   // заливаем фон
  if(serial != null){
    if(millis() - pollTimer > MBdelay){
      sendPacket(packet, packet.length);
      reqCntr++;
  //    printPacket(packet, packet.length);
      pollTimer = millis();
      respTimer = millis();
      out = true;
    } 
    if(reqCntr % 10 == 0 && millis() - pollTimer > MBdelay - 20 && out){
      println("reqCntr = ", reqCntr, "respCntr = ", respCntr);
      out = false;
    }
  }
}

void serialEvent(Serial serial) 
{
  int size, crc;
  size = serial.readBytes(rxBuff);
  crc = modbusCRC16(int(rxBuff), size);
  if(crc == 0)
  {
    println(millis() - respTimer);
//    println("response");
//    printPacket(int(rxBuff), size);
    respCntr++;
  }
}

void sendPacket(int[] pack, int size)
{
  for (int i = 0; i < size; i++) {
    serial.write(byte(pack[i]));
  }
}

void printPacket(int[] pack, int size)
{
  for (int i = 0; i < size; i++) {
    print(hex(byte(pack[i])));
  }
  print('\n');
}

int modbusCRC16(int[] data, int size) {
  int i, n;
  int crc = 0xffff;
  for (i = 0; i <= size; i++)
  {
    crc ^= data[i];
    for (n = 0; n < 8; n++)
      crc = ((crc & 0x0001) > 0)?((crc >> 1)^0xa001):(crc >> 1);
  }
  return SwapByte(crc);
}

int SwapByte(int data_int)
{
  int byte_lo, byte_hi;
  byte_hi = (data_int & 0x00FF);
  byte_lo = (data_int >> 8);
  return ((byte_hi<<8)|byte_lo);
}

void setupGUI() {
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("Calibri", 16));  // сделаем шрифт побольше
  // выпадающий список
  cp5.addScrollableList("com")
    .setPosition(10, 10)
    .setSize(80, 100)
    .setBarHeight(30)
    .setItemHeight(30)
    .close()
    .addItems(Serial.list());
  ;
  
    // добавляем кнопки
  cp5.addButton("open").setPosition(90, 10).setSize(80, 30);
  cp5.addButton("close").setPosition(170, 10).setSize(80, 30);
}

// список портов
void com(int n) {
  portName = Serial.list()[n];  // запоминаем выбранный порт в portName
}

// кнопка открыть порт
void open() {
  if (portName != null && serial == null) {     // если выбран порт и сейчас он закрыт
    serial = new Serial(this, portName, speed); // открываем portName
    serial.buffer(8);
  }
}

// кнопка закрыть порт
void close() {
  if (serial != null) { // если порт открыт
    serial.stop();      // закрываем portName
    serial = null;      // serial выключен
  }
}
