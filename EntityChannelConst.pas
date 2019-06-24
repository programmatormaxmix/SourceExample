unit EntityChannelConst;

interface

{$I EntitySystemOpt.inc}

const

//------------------------------------------------------------------------------
// ����� ������ ����� ������
//------------------------------------------------------------------------------

  //��� ������
  CHANNEL_ERROR_NONE            =  0; .������.
  //��� ����������. ��� �������� ������� ���������� ���� ����������, ��� ���������� �����������
  CHANNEL_ERROR_LINK            =  -1;
  //��� ����������. ���������� ������� � �������� ������ ��� �������� ������
  CHANNEL_ERROR_LOST            =  -2;
  //��� ����������. ��� ������ ������� ��������������� �����
  CHANNEL_ERROR_KEEPALIVE       =  -3;
  //��� ����������. �� ���������� ��������� ������
  CHANNEL_ERROR_SHUTDOWN        =  -4;
  //��� ����������. ���������� ������
  CHANNEL_ERROR_OVERLOAD        =  -5;
  //��� ����������. ���������� ������
  CHANNEL_ERROR_UNDERLOAD       =  -6;
  //��� ����������. ��� ������ �������
  CHANNEL_ERROR_EXCHANGE        =  -7;
  //��� ����������. ���� ��� ������� ���������� �������
  CHANNEL_ERROR_FAILURE         =  -8;

//------------------------------------------------------------------------------
// ������� ��������� ������
//------------------------------------------------------------------------------

//��� ���������

  CHANNEL_RECEIVER_STREAM     = 1;

  CHANNEL_RECEIVER_PACKET     = 0; //������� ����� ����������� ��� 0

//��� �����������

  CHANNEL_TRANSMITTER_STREAM  = 2;

  CHANNEL_TRANSMITTER_PACKET  = 0; //������� ����� ����������� ��� 1

//���������� �������

  CHANNEL_CONTROL_HALFDUPLEX   = 4;

  CHANNEL_CONTROL_FULLDUPLEX   = 0; //������� ����� ����������� ��� 2

  CHANNEL_CONTROL_CHANNEL      = 8;

  CHANNEL_CONTROL_SOCKET       = 0; //������� ����� ����������� ��� 3


  CHANNEL_CONTROL_EXCHANGE     = 16;

  CHANNEL_CONTROL_OVERLOAD     = 32;

  CHANNEL_CONTROL_UNDERLOAD    = 64;

  CHANNEL_CONTROL_RESERVED     = 128;

//------------------------------------------------------------------------------
// ���������� ��������� ������
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
// ���������� ��������� ������
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
