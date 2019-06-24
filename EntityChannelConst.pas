unit EntityChannelConst;

interface

{$I EntitySystemOpt.inc}

const

//------------------------------------------------------------------------------
// Общие ошибки связи канала
//------------------------------------------------------------------------------

  //Нет ошибок
  CHANNEL_ERROR_NONE            =  0; .ываыва.
  //Нет соединения. При проверки наличия соединения было обнаружено, что соединение отсутствует
  CHANNEL_ERROR_LINK            =  -1;
  //Нет соединения. Соединение утеряно в процессе приема или передачи данных
  CHANNEL_ERROR_LOST            =  -2;
  //Нет соединения. Нет обмена данными продолжительное время
  CHANNEL_ERROR_KEEPALIVE       =  -3;
  //Нет соединения. По инициативе владельца канала
  CHANNEL_ERROR_SHUTDOWN        =  -4;
  //Нет соединения. Перегрузка данных
  CHANNEL_ERROR_OVERLOAD        =  -5;
  //Нет соединения. Недогрузка данных
  CHANNEL_ERROR_UNDERLOAD       =  -6;
  //Нет соединения. Нет обмена данными
  CHANNEL_ERROR_EXCHANGE        =  -7;
  //Нет соединения. Сбой при попытке управления каналом
  CHANNEL_ERROR_FAILURE         =  -8;

//------------------------------------------------------------------------------
// Базовые настройки канала
//------------------------------------------------------------------------------

//Тип приемника

  CHANNEL_RECEIVER_STREAM     = 1;

  CHANNEL_RECEIVER_PACKET     = 0; //Имеется ввиду отключенный бит 0

//Тип передатчика

  CHANNEL_TRANSMITTER_STREAM  = 2;

  CHANNEL_TRANSMITTER_PACKET  = 0; //Имеется ввиду отключенный бит 1

//Управление каналом

  CHANNEL_CONTROL_HALFDUPLEX   = 4;

  CHANNEL_CONTROL_FULLDUPLEX   = 0; //Имеется ввиду отключенный бит 2

  CHANNEL_CONTROL_CHANNEL      = 8;

  CHANNEL_CONTROL_SOCKET       = 0; //Имеется ввиду отключенный бит 3


  CHANNEL_CONTROL_EXCHANGE     = 16;

  CHANNEL_CONTROL_OVERLOAD     = 32;

  CHANNEL_CONTROL_UNDERLOAD    = 64;

  CHANNEL_CONTROL_RESERVED     = 128;

//------------------------------------------------------------------------------
// Прикладные настройки канала
//------------------------------------------------------------------------------

  CHANNEL_STREAM_FULLDUPLEX  = CHANNEL_TRANSMITTER_STREAM + CHANNEL_RECEIVER_STREAM + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_CHANNEL;
  CHANNEL_STREAM_HALFDUPLEX  = CHANNEL_TRANSMITTER_STREAM + CHANNEL_RECEIVER_STREAM + CHANNEL_CONTROL_HALFDUPLEX + CHANNEL_CONTROL_CHANNEL;
  CHANNEL_STREAM_RECVSIMPLEX = CHANNEL_TRANSMITTER_STREAM + CHANNEL_RECEIVER_STREAM + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_CHANNEL;
  CHANNEL_STREAM_SENDSIMPLEX = CHANNEL_TRANSMITTER_STREAM + CHANNEL_RECEIVER_STREAM + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_CHANNEL;
  CHANNEL_PACKET_FULLDUPLEX  = CHANNEL_TRANSMITTER_PACKET + CHANNEL_RECEIVER_PACKET + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_CHANNEL;
  CHANNEL_PACKET_HALFDUPLEX  = CHANNEL_TRANSMITTER_PACKET + CHANNEL_RECEIVER_PACKET + CHANNEL_CONTROL_HALFDUPLEX + CHANNEL_CONTROL_CHANNEL;
  CHANNEL_PACKET_RECVSIMPLEX = CHANNEL_TRANSMITTER_PACKET + CHANNEL_RECEIVER_PACKET + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_CHANNEL;
  CHANNEL_PACKET_SENDSIMPLEX = CHANNEL_TRANSMITTER_PACKET + CHANNEL_RECEIVER_PACKET + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_CHANNEL;

//------------------------------------------------------------------------------
// Прикладные настройки сокета
//------------------------------------------------------------------------------

  SOCKET_STREAM_FULLDUPLEX  = CHANNEL_TRANSMITTER_STREAM + CHANNEL_RECEIVER_STREAM + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_SOCKET;
  SOCKET_STREAM_HALFDUPLEX  = CHANNEL_TRANSMITTER_STREAM + CHANNEL_RECEIVER_STREAM + CHANNEL_CONTROL_HALFDUPLEX + CHANNEL_CONTROL_SOCKET;
  SOCKET_STREAM_RECVSIMPLEX = CHANNEL_TRANSMITTER_STREAM + CHANNEL_RECEIVER_STREAM + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_SOCKET;
  SOCKET_STREAM_SENDSIMPLEX = CHANNEL_TRANSMITTER_STREAM + CHANNEL_RECEIVER_STREAM + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_SOCKET;
  SOCKET_PACKET_FULLDUPLEX  = CHANNEL_TRANSMITTER_PACKET + CHANNEL_RECEIVER_PACKET + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_SOCKET;
  SOCKET_PACKET_HALFDUPLEX  = CHANNEL_TRANSMITTER_PACKET + CHANNEL_RECEIVER_PACKET + CHANNEL_CONTROL_HALFDUPLEX + CHANNEL_CONTROL_SOCKET;
  SOCKET_PACKET_RECVSIMPLEX = CHANNEL_TRANSMITTER_PACKET + CHANNEL_RECEIVER_PACKET + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_SOCKET;
  SOCKET_PACKET_SENDSIMPLEX = CHANNEL_TRANSMITTER_PACKET + CHANNEL_RECEIVER_PACKET + CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_SOCKET;

//------------------------------------------------

  CHANNEL_BUFFER_STRING        = 65536;

type

  TBytes  = type UInt64;

implementation

end.
