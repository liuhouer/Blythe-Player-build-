{*****************************************************************************
*                  音频波形及频谱显示控件 - TSkyAudioMeter                   *
*                                                                            *
*   功能： 即时显示音频波形及频谱，提供一点娱乐效果                          *
*   版本： V1.01                                                             *
*   作者： 顾中军                                                            *
*   日期:  2006.3.25 ~ 2006.3.31 完成波形显示部分                            *
*          2006.4.1 ~ 2006.4.3   加上简单频谱显示功能                        *
*   用法：                                                                   *
*          很简单，设置好各参数，设置Active为True即可看到效果                *
*   说明：                                                                   *
*       一直以来，我都是用自己编的一个简单播放器来听MP3。原先我从网上找到一  *
*   个DLL可以输出简单频谱，但效果并不太好，而且只有DLL而无源码，难以集成到   *
*   播放器里，感觉很不爽！                                                   *
*       前些天，我整理源码时找到了一段C代码，试了一下，发现可以显示波形，于  *
*   就将其转换成Delphi代码了。                                               *
*       在转换过程中，我改进了代码结构，并加上更多的效果（其实挺简单的）。   *
*   至于频谱的显示，则只是对得到的音频数据做了一下傅立叶变换而已，效果还不   *
*   错，呵呵……                                                             *
*       祝你愉快！！！                                                       *
*                                                                            *
*   Email:     iamdream@yeah.net                                             *
*****************************************************************************}

unit SkyAudioMeter;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, MMSystem, Graphics, Math,
  SkyFFT2;

const
  DEF_BUFFER_SIZE = 1024;
  DEF_DATA_SCALE  = 16384;
  SIZE_RATIO      = 4;

type
  TSkyWaveMode = (svmLine, svmDot, svmNubby);    //线、点、块状
  TSkyAMStyle  = (smsSpectrum, smsOscillograph); //频谱、示波器

  TSkyAudioMeter = class(TCustomControl)
  private
    { Private declarations }
    FActive:      Boolean;
    FRealTime:    Boolean;
    FRedial:      Boolean;
    FAutoFit:     Boolean;         //自适应幅度
    FWaveIn:      HWAVEIN;
    FWaveHeaders: array of WaveHdr;
    FWaveFormat:  TWaveFormatEx;
    FBuffers:     Integer;
    FBufferSize:  Integer;
    FBufferIndex: Integer;
    FWaveBufSize: Integer;
    FErrorMsg:    string;
    FTick:        DWord;
    FBorderColor,
    FForeColor:   TColor;
    FWaitTick:    DWord;
    FDataStep:    Integer;
    FDataScale:   Integer;
    FFillSkip:    Integer;
    FMixTime:     Integer;
    FWaveMode:    TSkyWaveMode;
    FAMStyle:     TSkyAMStyle;
    FFreqWidth:   Integer;         //频带宽度
    FFreqSpace:   Integer;         //频带间隔
    FWaveSource:  TComplexArray;
    FFreqTarget:  TComplexArray;
    function InitWaveIn: MMRESULT;
    function CloseWaveIn: MMRESULT;
    procedure SetActive(Value: Boolean);
    procedure SetBuffers(Value: Integer);
    procedure SetBorderColor(Value: TColor);
    procedure SetForeColor(Value: TColor);
    procedure SetErrorMsg(const Value: string);
    procedure SetDataStep(Value: Integer);
    procedure SetDataScale(Value: Integer);
    procedure SetMixTime(Value: Integer);
    procedure SetAMStyle(Value: TSkyAMStyle);
    procedure SetFreqWidth(Value: Integer);
    procedure SetFreqSpace(Value: Integer);
    procedure WMEraseBkgnd(var Message: TMessage); message WM_ERASEBKGND;
  protected
    { Protected declarations }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure ProcessInput;
    procedure PaintWave(Data: PSmallInt); virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
  published
    { Published declarations }
    property Active: Boolean read FActive write SetActive default False;
    property RealTime: Boolean read FRealTime write FRealTime default False;
    property Buffers: Integer read FBuffers write SetBuffers default 2;
    property ErrorMsg: string read FErrorMsg write SetErrorMsg;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clGreen;
    property ForeColor: TColor read FForeColor write SetForeColor default clAqua;
    property WaitTick: DWord read FWaitTick write FWaitTick default 40;
    property DataStep: Integer read FDataStep write SetDataStep default 2;
    property DataScale: Integer read FDataScale write SetDataScale default DEF_DATA_SCALE;
    property MixTime: Integer read FMixTime write SetMixTime default 0;
    property WaveMode: TSkyWaveMode read FWaveMode write FWaveMode default svmLine;
    property Redial: Boolean read FRedial write FRedial default False;
    property AutoFit: Boolean read FAutoFit write FAutoFit default False;
    property AMStyle: TSkyAMStyle read FAMStyle write SetAMStyle default smsOscillograph;
    property FreqWidth: Integer read FFreqWidth write SetFreqWidth default 1;
    property FreqSpace: Integer read FFreqSpace write SetFreqSpace default 1;

    property Action;
    property Align;
    property Color default clBlack;
    property Constraints;
    //property Ctl3D;
    property PopupMenu;
    property ShowHint;
    property Visible;

    property OnCanResize;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('Samples', [TSkyAudioMeter]);
end;


//---------------------------------------------------------------------------
procedure WaveInProc(waveIn: HWAVEIN; uMsg: UINT; dwInstance, dwParam1, dwParam2: DWORD); stdcall;
begin
  if (uMsg = MM_WIM_DATA) and (dwInstance <> 0)
      and (TObject(dwInstance) is TSkyAudioMeter) then
  begin
    with TSkyAudioMeter(TObject(dwInstance)) do begin
      ProcessInput;
    end;
  end;
end;
//---------------------------------------------------------------------------



constructor TSkyAudioMeter.Create(AOwner: TComponent);
begin
  inherited;
  Width   := 200;
  Height  := 100;
  Color   := clBlack;
  TabStop := True;   //设为True，才能接受键盘消息（含弹出右键菜单）2006.3.29

  FBorderColor := clGreen;
  FForeColor   := clAqua;
  SetBuffers(2);
  FBufferSize  := DEF_BUFFER_SIZE;
  FBufferIndex := Low(FWaveHeaders);
  with FWaveFormat do begin
    wFormatTag      := WAVE_FORMAT_PCM;
    nChannels       := 2;
    nSamplesPerSec  := 44100;
    wBitsPerSample  := 16;
    nBlockAlign     := wBitsPerSample div 8 * nChannels;
    nAvgBytesPerSec := nBlockAlign * nSamplesPerSec;
    cbSize          := 0;
    FWaveBufSize    := FBufferSize * nBlockAlign;
  end;
  FWaitTick   := 40;
  FDataStep   := 2;
  FDataScale  := DEF_DATA_SCALE;
  FWaveMode   := svmLine;
  FAMStyle    := smsOscillograph;
  FFreqWidth  := 1;
  FFreqSpace  := 1;
  SetLength(FWaveSource, DEF_BUFFER_SIZE);
  SetLength(FFreqTarget, DEF_BUFFER_SIZE);
end;

destructor TSkyAudioMeter.Destroy;
begin
  SetActive(False);
  inherited;
end;

procedure TSkyAudioMeter.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if not Focused then begin
    Windows.SetFocus(Handle);
  end;
end;

function TSkyAudioMeter.InitWaveIn: MMRESULT;
var
  i: Integer;
  sErr: string[255];
begin
  for i := Low(FWaveHeaders) to High(FWaveHeaders) do begin
    with FWaveHeaders[i] do begin
      dwBufferLength := FWaveBufSize;
      dwFlags        := 0;
      dwLoops        := 0;
      if lpData = nil then
        lpData := PChar(VirtualAlloc(nil, FWaveBufSize, MEM_COMMIT, PAGE_READWRITE));
    end;
  end;
  Result := waveInOpen(@FWaveIn, WAVE_MAPPER, @FWaveFormat, DWORD(@WaveInProc),
                       DWord(Self), CALLBACK_FUNCTION);
  if Result = MMSYSERR_NOERROR then begin
    FBufferIndex := Low(FWaveHeaders);
    for i := Low(FWaveHeaders) to High(FWaveHeaders) do begin
      Result := waveInPrepareHeader(FWaveIn, @FWaveHeaders[i], SizeOf(WAVEHDR));
      if Result = MMSYSERR_NOERROR then begin
        Result := waveInAddBuffer(FWaveIn, @FWaveHeaders[i], SizeOf(WAVEHDR));
      end;
      if Result <> MMSYSERR_NOERROR then Break; 
    end;
    if Result = MMSYSERR_NOERROR then begin
      Result := waveInStart(FWaveIn);
      FTick  := GetTickCount();
    end;
  end;
  if Result <> MMSYSERR_NOERROR then begin
    if waveInGetErrorText(Result, PChar(@sErr[1]), Length(sErr)) = MMSYSERR_NOERROR then
      FErrorMsg := sErr;
  end;
end;

function TSkyAudioMeter.CloseWaveIn: MMRESULT;
var
  i: Integer;
begin
  for i := Low(FWaveHeaders) to High(FWaveHeaders) do begin
    while waveInUnprepareHeader(FWaveIn, @FWaveHeaders[i], SizeOf(WAVEHDR)) = WAVERR_STILLPLAYING do
    begin
      Sleep(200);      //这样才有保证释放彻底！  2006.3.27
    end;
  end;
  Result := waveInClose(FWaveIn);
  for i := Low(FWaveHeaders) to High(FWaveHeaders) do begin
    VirtualFree(FWaveHeaders[i].lpData, 0, MEM_RELEASE );
    FWaveHeaders[i].lpData := nil;
  end;
end;

procedure TSkyAudioMeter.SetActive(Value: Boolean);
begin                            //由于采用回调函数方法似乎在系统中只能独占使用
  if FActive <> Value then begin //所以设计期不可将Active设为True！  2006.3.27
    FActive := Value;            //当然，设计期还是可以预览一下的，XP则可以?!
    if Value then begin
      FActive := InitWaveIn = MMSYSERR_NOERROR;
      if not FActive then
        CloseWaveIn;
    end else begin
      CloseWaveIn;
    end;
  end;
end;

procedure TSkyAudioMeter.SetBuffers(Value: Integer);
var
  bActive: Boolean;
begin
  if (FBuffers <> Value) and (Value >= 1) and (Value <= 64) then begin
    FBuffers := Value;
    bActive  := FActive;
    if FActive then SetActive(False);
    SetLength(FWaveHeaders, Value);
    if bActive then SetActive(True);
  end;
end;

procedure TSkyAudioMeter.SetBorderColor(Value: TColor);
begin
  if FBorderColor <> Value then begin
    FBorderColor := Value;
    Paint;
  end;
end;

procedure TSkyAudioMeter.SetForeColor(Value: TColor);
begin
  if FForeColor <> Value then begin
    FForeColor := Value;
    Paint;
  end;
end;

procedure TSkyAudioMeter.SetErrorMsg(const Value: string);
begin                    //写个空函数,否则设计期ErrorMsg属性不出现
end;

procedure TSkyAudioMeter.SetDataStep(Value: Integer);
begin                    //标准: DATA STEP = 2 , 改为奇数，
                         //则可简单合成两个声道波形为一个波形！  2006.3.27
  if (FDataStep <> Value) and (Value >= 1) and (Value <= 64) then
    FDataStep := Value;
end;

procedure TSkyAudioMeter.SetDataScale(Value: Integer);
begin
  if (Value > 0) and (Value <= 65536) then
    FDataScale := Value;
end;

procedure TSkyAudioMeter.SetMixTime(Value: Integer);
begin
  if (Value >= 0) and (Value <= 64) then
    FMixTime := Value;
end;

procedure TSkyAudioMeter.SetAMStyle(Value: TSkyAMStyle);
begin
  if Value <> FAMStyle then begin
    FAMStyle := Value;
    Paint;
  end;
end;

procedure TSkyAudioMeter.SetFreqWidth(Value: Integer);
begin
  if (Value > 0) and (Value <= 64) then
    FFreqWidth := Value;
end;

procedure TSkyAudioMeter.SetFreqSpace(Value: Integer);
begin
  if (Value >= 0) and (Value <= 64) then
    FFreqSpace := Value;
end;

procedure TSkyAudioMeter.WMEraseBkgnd(var Message: TMessage);
begin
  Message.Result := 1;
end;

procedure TSkyAudioMeter.Open;
begin
  SetActive(True);
end;

procedure TSkyAudioMeter.Close;
begin
  SetActive(False);
end;

procedure TSkyAudioMeter.Paint;
begin
  with Canvas do begin
    Lock;
    try
      Brush.Color := Color;
      Pen.Color   := BorderColor;
      Rectangle( 0, 0, Width, Height );
    finally
      UnLock;
    end;
  end;
end;

procedure TSkyAudioMeter.ProcessInput;
var
  pBuff: PWAVEHDR;
begin
  if FActive then begin
    pBuff := @FWaveHeaders[FBufferIndex];
    waveInUnprepareHeader(FWaveIn, pBuff, SizeOf(WAVEHDR));
    if not RealTime then
      PaintWave(PSmallInt(pBuff.lpData)); //其实可用线程，只不过一般情况不需要
    Inc(FBufferIndex);
    if FBufferIndex > High(FWaveHeaders) then
      FBufferIndex := Low(FWaveHeaders);
    waveInPrepareHeader(FWaveIn, @FWaveHeaders[FBufferIndex], SizeOf(WAVEHDR));
    waveInAddBuffer(FWaveIn, @FWaveHeaders[FBufferIndex], SizeOf(WAVEHDR));
    if RealTime then
      PaintWave(PSmallInt(pBuff.lpData)); //其实可用线程，只不过一般情况不需要
  end;
end;

procedure TSkyAudioMeter.PaintWave(Data: PSmallInt);
var
  pData: PSmallInt;

  procedure CalcRedialXY(var x, y: Integer);
  var
    iOriginX, iOriginY, iRadii: Integer;
    dStereoScale: Double;
  begin
    iOriginX := Width shr 1;
    iOriginY := Height shr 1;
    iRadii   := Min(Width, Height) shr 1;
    dStereoScale := 0.707 * iRadii / DataScale;

    x := iOriginX + Trunc(Tan(y) * x * dStereoScale);
    y := iOriginY + Trunc(CoTan(x) * y * dStereoScale);

    if WaveMode = svmLine then
      Canvas.MoveTo(iOriginX, iOriginY);
  end;

  function GetScale: Integer;
  var
    dwVolume: DWord;
  begin
    if AutoFit and (waveOutGetVolume(0, @dwVolume)= MMSYSERR_NOERROR) then begin
      Result := Max(Integer((dwVolume shr 16)and $0FFFF),
                    Integer(dwVolume and $0FFFF)) shr 1;
    end else begin
      Result := DataScale;          //标准: 32768, 只是可能幅度太小
    end;
  end;

  procedure DoPaintWaveGraph;
  var
    x, y, i, k, iOldX, iZeroLevel: Integer;
    dTimeScale, ts:  Double;
  begin
    iZeroLevel  := Height shr 1;
    dTimeScale := iZeroLevel / GetScale();
    with Canvas do begin
      ts := Width / FBufferSize;
      for k := 0 to (DataStep + 1) mod 2 do begin
        MoveTo(0, iZeroLevel);
        iOldX := -1;
        pData := Data;
        Inc(pData, k);
        i     := k;
        while i < FBufferSize do begin
          if Redial then  x := i  else  x := Trunc(i * ts);
          if x <> iOldX then begin
            if Redial then begin
              y := pData^;
              CalcRedialXY(x, y);
            end else
              y := iZeroLevel - Trunc(pData^ * dTimeScale);
            case WaveMode of
              svmLine:    LineTo( x, y );
              svmDot:     Pixels[x, y] := ForeColor;
              svmNubby:   FillRect(Rect(x-1, y-1, x+1, y+1));
            end;
            iOldX := x;
          end;
          Inc(pData, DataStep);
          Inc(i, DataStep);
        end;
      end;
    end;
  end;

  procedure DoPaintSpectrum;
  var
    i, x, y: Integer;
  begin
    pData := Data;
    for i := 0 to DEF_BUFFER_SIZE -1 do begin
      FWaveSource[i].Real := DWord(pData^ - 32768);
      FWaveSource[i].Imag := 0;
      Inc(pData);
    end;
    FFT(FWaveSource, FFreqTarget, DEF_BUFFER_SIZE);
    with Canvas do begin
      x := 0;
      for i := 0 to DEF_BUFFER_SIZE div SIZE_RATIO -1 do begin
        if x < Width then begin
          y := Trunc(sqrt((FFreqTarget[i].Real * FFreqTarget[i].Real
                           + FFreqTarget[i].Imag * FFreqTarget[i].Imag)
                          / DEF_BUFFER_SIZE));
          y := Min(y, 8192);
          y := Height - y * Height div 8192;
          Rectangle(x, y, x + FreqWidth, Height -1);
          Inc(x, FreqSpace + FreqWidth);
        end else begin
          Break;
        end;
      end;
    end;
  end;

begin
  if not Active or not Visible then Exit;

  if not RealTime then begin
    if GetTickCount() - FTick < WaitTick then Exit;
    FTick := GetTickCount();
  end;

  with Canvas do begin
    Lock();
    try
      Brush.Color := Color;
      Pen.Color   := BorderColor;
      if FFillSkip = 0 then begin
        Rectangle( 0, 0, Width, Height );
      end;
      if MixTime = 0 then begin
        FFillSkip := 0;
      end else begin
        Inc(FFillSkip);
        FFillSkip := FFillSkip mod MixTime;
      end;

      Pen.Color   := ForeColor;
      Brush.Color := ForeColor;
      case AMStyle of
        smsSpectrum:     DoPaintSpectrum();
        smsOscillograph: DoPaintWaveGraph();
      end;
    finally
      Unlock();
    end;
  end;
end;

end.

