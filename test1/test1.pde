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
byte[] inBuffer = new byte[40];
//int[] testBuff = {0x82, 0xFE, 0xFF, 0x16, 0x00, 0xAA, 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0xBB};
int[] outBuffer = {0x81, 0x10, 0x16, 0x00, 0xAA, 0x00};

Knob RSV1_1;
Knob RSV1_2;
Knob RSV2_1;
Knob RSV2_2;
Knob RSV3_1;
Knob RSV3_2;

void setup() {
  size(1000, 400);    // размер окна
  setupGUI();        // инициализация интерфейса
}

void draw() {
  background(200);   // заливаем фон
  parsing();         // парсим
}

void parsing() {
  while (serial != null && serial.available() > 0) {
    delay(20);
    //inBuffer = serial.readBytes();
    int size = serial.readBytes(inBuffer);
    if (inBuffer != null) {
      for (int i = 0; i < size; i++) {
        print(hex(inBuffer[i]));
      }
      print('\n');
      int[] inBuff_int = int(inBuffer);
      temp_sensors(inBuff_int, size);
      speed_reg(inBuff_int, size);
    }
  }
}

void temp_sensors(int[] rx_buff, int size) {
  int check = crc8(rx_buff, size);
  if (check == 0)
  {
    if (rx_buff[1] == DT1)
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
      t_arr[16] = 0x140 & 0xFF;
      t_arr[17] = (0x140 >> 8) & 0xFF;
      //10 датчик
      t_arr[18] = 0x140 & 0xFF;
      t_arr[19] = (0x140 >> 8) & 0xFF;
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
    if (rx_buff[1] == DT2)
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
      t_arr[16] = 0x140 & 0xFF;
      t_arr[17] = (0x140 >> 8) & 0xFF;
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

void speed_reg(int[] rx_buff, int size) {
  int check = modbusCRC16(rx_buff, size);
  if (check == 0)
  {
    if(rx_buff[1] == 6)
    {
      if (rx_buff[0] == 1)
      {
        if (rx_buff[3] == 1) RSV1_1.setValue(rx_buff[5]);            
        if (rx_buff[3] == 2) RSV1_2.setValue(rx_buff[5]);
      }
      if (rx_buff[0] == 2)
      {
        if (rx_buff[3] == 1) RSV2_1.setValue(rx_buff[5]);
        if (rx_buff[3] == 2) RSV2_2.setValue(rx_buff[5]);
      }
      if (rx_buff[0] == 3)
      {
        if (rx_buff[3] == 1) RSV3_1.setValue(rx_buff[5]);
        if (rx_buff[3] == 2) RSV3_2.setValue(rx_buff[5]);
      }
      serial.write(byte(rx_buff));
      printPacket(rx_buff, size);
    }
    if(rx_buff[1] == 3)
    {
      ;
    }
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

// ======= ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА ========
void setupGUI() {
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("Calibri", 16));  // сделаем шрифт побольше

  int x = 300;

  cp5.addSlider("up-left")
    .setPosition(x, 90)
    .setSize(20, 100)
    .setRange(20, 40)
    ;

  cp5.addSlider("down-left")
    .setPosition(x + 100, 90)
    .setSize(20, 100)
    .setRange(20, 40)
    ;

  cp5.addSlider("up-right")
    .setPosition(x + 100*2, 90)
    .setSize(20, 100)
    .setRange(20, 40)
    ;

  cp5.addSlider("down-right")
    .setPosition(x + 100*3, 90)
    .setSize(20, 100)
    .setRange(20, 40)
    ;

  RSV1_1 = cp5.addKnob("RSV1_1")
    .setRange(0, 100)
    .setPosition(50, 270)
    .setRadius(50)
    .setDragDirection(Knob.VERTICAL)
    ;

  RSV1_2 = cp5.addKnob("RSV1_2")
    .setRange(0, 100)
    .setPosition(200, 270)
    .setRadius(50)
    .setDragDirection(Knob.VERTICAL)
    ;

  RSV2_1 = cp5.addKnob("RSV2_1")
    .setRange(0, 100)
    .setPosition(650, 270)
    .setRadius(50)
    .setDragDirection(Knob.VERTICAL)
    ;
  RSV2_2 = cp5.addKnob("RSV2_2")
    .setRange(0, 100)
    .setPosition(800, 270)
    .setRadius(50)
    .setDragDirection(Knob.VERTICAL)
    ;

  RSV3_1 = cp5.addKnob("RSV3_1")
    .setRange(0, 100)
    .setPosition(350, 250)
    .setRadius(50)
    .setDragDirection(Knob.VERTICAL)
    ;

  RSV3_2 = cp5.addKnob("RSV3_2")
    .setRange(0, 100)
    .setPosition(500, 250)
    .setRadius(50)
    .setDragDirection(Knob.VERTICAL)
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
  // n = 2; //COM6
  portName = Serial.list()[n];  // запоминаем выбранный порт в portName
}

// кнопка открыть порт
void open() {
  if (portName != null && serial == null) {     // если выбран порт и сейчас он закрыт
    serial = new Serial(this, portName, speed); // открываем portName
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
