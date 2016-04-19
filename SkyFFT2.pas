{*****************************************************************************
*                                                                            *
*   下面的FFT（傅立叶变换）函数是从网上找来的！虽然我也学过，但早忘了^o^     *
*                                                                            *
*   Email:     iamdream@yeah.net                                             *
*                                                                            *
*****************************************************************************}

unit SkyFFT2;

interface

uses
  Windows, Classes, SysUtils, Math;

type
  TComplex = record
    Real: Double;
    Imag: Double;
  end;

  PComplexArray = ^TComplexArray;
  TComplexArray = array of TComplex;

  procedure FFT(Source, Target: TComplexArray; iCount: Integer);
  procedure iFFT(Source, Target: TComplexArray; iCount: Integer);

implementation
{
function IsPowerOfTwo ( x: word ): boolean;   // 是 2 的幂?
var
  i, y:  word;
begin
  y := 2;
  for i := 1 to 31 do begin
    if x = y then begin
      Result := TRUE;
      Exit;
    end;
    y := y SHL 1;
  end;
  Result := FALSE;
end;
}

function NumberOfBitsNeeded ( PowerOfTwo: word ): word;
var
  i: word;
begin
  for i := 0 to 16 do begin
    if (PowerOfTwo AND (1 SHL i)) <> 0 then begin
      Result := i;
      Exit;
    end;
  end;
  Result := 0;
end;


function ReverseBits ( index, NumBits: word ): word;
var
  i: word;
begin
  Result := 0;
  for i := 0 to NumBits-1 do begin
    Result := (Result SHL 1) OR (index AND 1);
    index := index SHR 1;
  end;
end;

procedure DoFFT(Source, Target: TComplexArray; iCount: Integer; AngleNumerator: Double);
var
  NumBits, i, j, k, n, BlockSize, BlockEnd: word;
  delta_angle, delta_ar: double;
  alpha, beta: double;
  tr, ti, ar, ai: double;
begin
  //if not IsPowerOfTwo(iCount) or (iCount<2) then
  //  raise Exception.Create('Count is not a positive integer power of 2');

  NumBits := NumberOfBitsNeeded (iCount);
  for i := 0 to iCount-1 do begin
    j := ReverseBits ( i, NumBits );
    Target[j] := Source[i];
  end;
  BlockEnd := 1;
  BlockSize := 2;
  while BlockSize <= iCount do begin
    delta_angle := AngleNumerator / BlockSize;
    alpha       := sin ( 0.5 * delta_angle );
    alpha       := 2.0 * alpha * alpha;
    beta        := sin ( delta_angle );

    i := 0;
    while i < iCount do begin
      ar := 1.0;    (* cos(0) *)
      ai := 0.0;    (* sin(0) *)

      j := i;
      for n := 0 to BlockEnd-1 do begin
        k := j + BlockEnd;
        tr := ar*Target[k].Real - ai*Target[k].Imag;
        ti := ar*Target[k].Imag + ai*Target[k].Real;
        Target[k].Real := Target[j].Real - tr;
        Target[k].Imag := Target[j].Imag - ti;
        Target[j].Real := Target[j].Real + tr;
        Target[j].Imag := Target[j].Imag + ti;
        delta_ar := alpha*ar + beta*ai;
        ai := ai - (alpha*ai - beta*ar);
        ar := ar - delta_ar;
        INC(j);
      end;
      i := i + BlockSize;
    end;
    BlockEnd := BlockSize;
    BlockSize := BlockSize SHL 1;
  end;
end;

procedure FFT(Source, Target: TComplexArray; iCount: Integer);
begin
  DoFFT(Source, Target, iCount, 2 * PI);
end;

procedure iFFT(Source, Target: TComplexArray; iCount: Integer);
var
  i: Integer;
begin
  DoFFT(Source, Target, iCount, -2 * PI);
  (* Normalize the resulting time samples... *)
  for i := 0 to iCount -1 do begin
    Target[i].Real := Target[i].Real / iCount;
    Target[i].Imag := Target[i].Imag / iCount;
  end;
end;

end.
