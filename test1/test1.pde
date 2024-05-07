// ====================================
// БАЗОВЫЙ ПРИМЕР ДЛЯ ОБЩЕНИЯ С АРДУИНО
// ====================================
int speed = 9600;

import processing.serial.*;
Serial serial;
import controlP5.*;
ControlP5 cp5;
String portName = "COM6";     // имя порта
boolean skip = true;
int DT1 = 0x10;
int DT2 = 0x11;
int fillVal = 0;
byte[] inBuffer = new byte[20];
//int[] testBuff = {0x82, 0xFE, 0xFF, 0x16, 0x00, 0xAA, 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0xBB};
int[] outBuffer = {0x81, 0x10, 0x16, 0x00, 0xAA, 0x00};
//int[] intBuff = new int [20];
int count = 0;

void setup() {
  size(500, 400);    // размер окна
  setupGUI();        // инициализация интерфейса
}

void draw() {
  background(200);   // заливаем фон
  fill(fillVal);
  // circle(100, 100, 60);
  //parsPKU();
  //parsing();         // парсим

  // для удобной отправки пакетов можно юзать sendPacket(ключ,"дата1,дата2,дата3")
  // например sendPacket(5, "255,255,255") - отправить три значения по ключу 5
}


// функция для отправки пакета на арду
void sendPacket(int key, String data) {
  if (serial != null) serial.write(str(key) + ',' + data + ';');
  // отправит "key,data;"
}

void serialEvent(Serial p) {
  inBuffer = p.readBytes();
  int[] inBuff_int = int(inBuffer);
  int check = crc8(inBuff_int, 9);
  if (check == 0)
  {
       if(inBuff_int[1] == DT1)
       {
          float t_downLeft = cp5.get(Slider.class, "down-left").getValue();
          float t_upLeft = cp5.get(Slider.class, "up-left").getValue();
          float t_downRight = cp5.get(Slider.class, "down-right").getValue();
          float t_upRight = cp5.get(Slider.class, "up-right").getValue();
          int t_downLeft_ds = int(t_downLeft/0.0625);
          int t_upLeft_ds = int(t_upLeft/0.0625);
          int t_downRight_ds = int(t_downRight/0.0625);
          int t_upRight_ds = int(t_upRight/0.0625);
          int[] t_arr = new int[20];
          //1 датчик
          t_arr[0] = t_downLeft_ds & 0xFF;
          t_arr[1] = (t_downLeft_ds >> 8) & 0xFF;
          //2 датчик
          t_arr[2] = t_upLeft_ds & 0xFF;
          t_arr[3] = (t_upLeft_ds >> 8) & 0xFF;
          //3 датчик
          t_arr[4] = t_downLeft_ds & 0xFF;
          t_arr[5] = (t_downLeft_ds >> 8) & 0xFF;
          //4 датчик
          t_arr[6] = t_upLeft_ds & 0xFF;
          t_arr[7] = (t_upLeft_ds >> 8) & 0xFF;
          //5 датчик
          t_arr[8] = t_downRight_ds & 0xFF;
          t_arr[9] = (t_downRight_ds >> 8) & 0xFF;
          //6 датчик
          t_arr[10] = t_upRight_ds & 0xFF;
          t_arr[11] = (t_upRight_ds >> 8) & 0xFF;
          //7 датчик
          t_arr[12] = t_downRight_ds & 0xFF;
          t_arr[13] = (t_downRight_ds >> 8) & 0xFF;
          //8 датчик
          t_arr[14] = t_upRight_ds & 0xFF;
          t_arr[15] = (t_upRight_ds >> 8) & 0xFF;
          //9 датчик
          t_arr[16] = 140 & 0xFF;
          t_arr[17] = (140 >> 8) & 0xFF;
          //10 датчик
          t_arr[18] = 140 & 0xFF;
          t_arr[19] = (140 >> 8) & 0xFF;
          int[] packet = concat(outBuffer, t_arr);
          packet[1] = 0x10;
          int pack_crc = crc8(packet, packet.length);
          packet = append(packet, pack_crc);
          serial.write(byte(packet));
          for (int i = 0; i < packet.length; i++) {
              print(hex(byte(packet[i])));
          }
          print('\n');
       }
       if(inBuff_int[1] == DT2)
       {
          float t_downLeft = cp5.get(Slider.class, "down-left").getValue();
          float t_upLeft = cp5.get(Slider.class, "up-left").getValue();
          float t_downRight = cp5.get(Slider.class, "down-right").getValue();
          float t_upRight = cp5.get(Slider.class, "up-right").getValue();
          int t_downLeft_ds = int(t_downLeft/0.0625);
          int t_upLeft_ds = int(t_upLeft/0.0625);
          int t_downRight_ds = int(t_downRight/0.0625);
          int t_upRight_ds = int(t_upRight/0.0625);
          int[] t_arr = new int[20];
          //1 датчик
          t_arr[0] = t_downLeft_ds & 0xFF;
          t_arr[1] = (t_downLeft_ds >> 8) & 0xFF;
          //2 датчик
          t_arr[2] = t_upLeft_ds & 0xFF;
          t_arr[3] = (t_upLeft_ds >> 8) & 0xFF;
          //3 датчик
          t_arr[4] = t_downLeft_ds & 0xFF;
          t_arr[5] = (t_downLeft_ds >> 8) & 0xFF;
          //4 датчик
          t_arr[6] = t_upLeft_ds & 0xFF;
          t_arr[7] = (t_upLeft_ds >> 8) & 0xFF;
          //5 датчик
          t_arr[8] = t_downRight_ds & 0xFF;
          t_arr[9] = (t_downRight_ds >> 8) & 0xFF;
          //6 датчик
          t_arr[10] = t_upRight_ds & 0xFF;
          t_arr[11] = (t_upRight_ds >> 8) & 0xFF;
          //7 датчик
          t_arr[12] = t_downRight_ds & 0xFF;
          t_arr[13] = (t_downRight_ds >> 8) & 0xFF;
          //8 датчик
          t_arr[14] = t_upRight_ds & 0xFF;
          t_arr[15] = (t_upRight_ds >> 8) & 0xFF;
          //9 датчик
          t_arr[16] = 140 & 0xFF;
          t_arr[17] = (140 >> 8) & 0xFF;
          //10 датчик
          t_arr[18] = 0x00;
          t_arr[19] = 0x80;
          int[] packet = concat(outBuffer, t_arr);
          packet[1] = 0x11;
          int pack_crc = crc8(packet, packet.length);
          packet = append(packet, pack_crc);
          serial.write(byte(packet));
          for (int i = 0; i < packet.length; i++) {
              print(hex(byte(packet[i])));
          }
          print('\n');
       }
  }
}

/*void parsPKU() {
 if (serial != null && serial.available() > 0) {
 inBuffer = serial.readBytes();
 int[] intBuff = int(inBuffer);
 //    serial.readBytes(inBuffer);
 if (inBuffer != null) {
 println(inBuffer);
 print('\n');
 int temp = crc8(intBuff, 9);
 println(temp);
 }
 }
 } */

int crc8(int[] buffer, int size) {
  int crc = 0;
  for (int i = 0; i < size; i++) {
    int data = buffer[i];
    for (int j = 8; j > 0; j--) {
      crc = (((crc ^ data) & 1) > 0) ? ((crc >> 1) ^ 140) : (crc >> 1);
      data >>= 1;
    }
  }
  return crc;
}

// функция парсинга, опрашивать в лупе
/*void parsing() {
  // если порт открыт и в буфере что то есть
  if (serial != null && serial.available() > 0) {
    String str = serial.readStringUntil('\n');
    if (str != null)
    {

      String data[] = str.trim().split(",");
      //int[] data = int(split(str, ','));  // парсить можно сразу в int[]!
      if (skip) {
        skip = false;
        return;  // пропускаем первый пакет
      }
      println(str);
      switch (int(data[0])) {  // свитч по ключу
      case 0:
        fillVal = int(data[1]);
        break;
      case 1:
        break;
      case 2:
        break;
      }
    }
  }
} */

// ======= ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА ========
void setupGUI() {
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("Calibri", 16));  // сделаем шрифт побольше

  cp5.addSlider("up-left")
    .setPosition(50, 110)
    .setSize(20, 100)
    .setRange(20, 40)
    ;
    
      cp5.addSlider("down-left")
    .setPosition(150, 110)
    .setSize(20, 100)
    .setRange(20, 40)
    ;
    
      cp5.addSlider("up-right")
    .setPosition(250, 110)
    .setSize(20, 100)
    .setRange(20, 40)
    ;
    
      cp5.addSlider("down-right")
    .setPosition(350, 110)
    .setSize(20, 100)
    .setRange(20, 40)
    ;

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

// ==== ОБРАБОТЧИКИ ИНТЕРФЕЙСА =====
// список портов
void com(int n) {
  n = 2; //COM6
  portName = Serial.list()[n];  // запоминаем выбранный порт в portName
}

// кнопка открыть порт
void open() {
  if (portName != null && serial == null) {     // если выбран порт и сейчас он закрыт
    serial = new Serial(this, portName, speed); // открываем portName
    serial.buffer(9);
    skip = true;    // флаг на пропуск первого пакета
  }
}

// кнопка закрыть порт
void close() {
  if (serial != null) { // если порт открыт
    serial.stop();      // закрываем portName
    serial = null;      // serial выключен
  }
}
