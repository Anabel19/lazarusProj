unit ParseMethod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, fpexprpars, Dialogs, matrix, class_mc, class_ma, class_intg, intersec, class_edo,
  class_extra;

type
  TPMeth = Class
  Private
      r, c: integer;  //matrix
      FParser: TFPExpressionParser;
      identifier: array of TFPExprIdentifierDef;
      Procedure AddFunctions();
      function readMatrix(arg: string):mmatrix;

  Public
      cant_:integer;     //extra
      pointss: TStringList;

      f1,
      f2: String;
      max,
      min,
      varx: real;
      ResultInts: TStringList; //root interseccion
      hedo: real;
      Lfunxedo: TStringList;
      Lsolxedo: TStringList;
      LfexTra: TStringList;
      LRexTra: TStringList;
      Expression: string;
      procedure loadArchivo(archivo_a_leer:String);
      procedure ExprInts( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      procedure ExprIntg( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      procedure ExprEdo(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      procedure ExprExtr(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

      function EvaluateOpM(Input: String): String;
      function EvaluateOpM1(Input: String): string;
      //procedure Op(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

      function NewValue( Variable:string; Value: Double ): Double;
      function NewStr( Variable:string; Value: string ): string;
      procedure AddVariable( Variable: string; Value: Double );
      procedure AddString( Variable: string; Value: string );
      function Evaluate(  ): Double;
      //function Evaluate(  ): Variant;
      function EvaluateStr(): String;
      constructor create();
      destructor destroy;

  end;

implementation

constructor TPMeth.create;
begin
   FParser:= TFPExpressionParser.Create( nil );
   FParser.Builtins := [ bcMath ];
   AddFunctions();

   ResultInts:= TStringList.Create;
   Lfunxedo:= TStringList.Create;
   Lsolxedo:= TStringList.Create;
   pointss:= TStringList.Create;
   LfexTra:= TStringList.Create;
   LRexTra:= TStringList.Create;
end;
//sin(x)/x^2+ln(x)-x
//1-x
destructor TPMeth.destroy;
begin
    FParser.Destroy;
    ResultInts.Destroy;
    Lfunxedo.Destroy;
    Lsolxedo.Destroy;
    pointss.Destroy;
    LfexTra.Destroy;
    LRexTra.Destroy;
end;

function TPMeth.NewValue( Variable: string; Value: Double ): Double;
begin
    FParser.IdentifierByName(Variable).AsFloat:= Value;

end;

function TPMeth.NewStr( Variable: string; Value: string ): string;
begin
    FParser.IdentifierByName(Variable).AsString:= Value;
end;

function TPMeth.Evaluate(): Double;
begin
     FParser.Expression:= Expression;
     Result:= ArgToFloat( FParser.Evaluate );

end;
{
function TPMeth.Evaluate(): Variant;
begin
     FParser.Expression:= Expression;
     Result:= Variant(FParser.Evaluate);

end;}
function TPMeth.EvaluateStr(): String;
begin
     ShowMessage('ffff');
     FParser.Expression:= Expression;
     Result:= FParser.Evaluate.ResString;

end;

function IsNumber(AValue: TExprFloat): Boolean;
begin
  result := not (IsNaN(AValue) or IsInfinite(AValue) or IsInfinite(-AValue));
end;

Procedure ExprBisecc( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  ax,by,
  err: Double;
  MC: TMC;
begin
    ax := ArgToFloat( Args[ 1 ] );
    by := ArgToFloat( Args[ 2 ] );
    err:= ArgToFloat( Args[ 3 ]);
    MC:=TMC.create;
    MC.funx:=Args[0].ResString;
    MC.a:=ax;
    MC.b:=by;
    MC.Error:= err;
     Result.resFloat := MC.biseccion();
    MC.destroy;
end;

Procedure ExprPF( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  ax,by,
  err: Double;
  MC: TMC;
begin
    ax := ArgToFloat( Args[ 1 ] );
    by := ArgToFloat( Args[ 2 ] );
    err:= ArgToFloat( Args[ 3 ]);
    MC:=TMC.create;
    MC.funx:=Args[0].ResString;
    MC.a:=ax;
    MC.b:=by;
    MC.Error:= err;
     Result.resFloat := MC.falsa_posicion();
    MC.destroy;
end;

Procedure ExprN( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  ax,
  err: Double;
  MA: TMA;
begin
    ax := ArgToFloat( Args[ 2 ] );
    err:= ArgToFloat( Args[ 3 ]);
    MA:=TMA.create;
    MA.funx:=Args[0].ResString;
    MA.dfunx:=Args[1].ResString;
    MA.xi:=ax;
    MA.Error:= err;
     Result.resFloat := MA.newton();
    MA.destroy;
end;

Procedure ExprS( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  ax,
  err: Double;
  MA: TMA;
begin
    ax := ArgToFloat( Args[ 1 ] );
    err:= ArgToFloat( Args[ 2 ]);
    MA:=TMA.create;
    MA.funx:=Args[0].ResString;
    MA.xi:=ax;
    MA.Error:= err;
     Result.resFloat := MA.secante();
    MA.destroy;
end;
  //nikelapsa-inkalaps -bakent fronend[angular] starapp

//INTEGRAL         integral('x*x',1,2,5,'trapecio')
procedure TPMeth.ExprIntg( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var I: TIntGral;
begin
  I:= TIntGral.create;
  f1:= Args[0].ResString;
  I.funx:= f1;
  min:= ArgToFloat(Args[1]);
  max:= ArgToFloat(Args[2]);
  I.a:= min;
  I.b:= max;
  I.N:= ArgToFloat(Args[3]);
  varx:=(I.b-I.a)/I.N;

  if (Args[4].ResInteger = 0)  then
      I.MIntgType:= 0
  else if (Args[4].ResInteger = 1)  then
      I.MIntgType:= 1
  else if (Args[4].ResInteger = 2)  then
      I.MIntgType:= 2;
  {
  if Pos('trapecio', Args[4].ResString) > 0 then
      MI.MIntgType:= 0
  else if  Pos('simpsom1_3', Args[4].ResString) > 0 then
      MI.MIntgType:= 1
  else if  Pos('simpsom3_8', Args[4].ResString) > 0 then
      MI.MIntgType:= 2;  }

  Result.ResFloat:= I.execute;
  I.Destroy;
end;

Procedure TPMeth.ExprInts( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  TIs: TInter; i,cant:Integer;
  rpta: String;
begin
    ResultInts.Clear;
    f1:= Args[0].ResString;
    f2:= Args[1].ResString;
    min:= ArgToFloat(Args[2]);//Args[2].ResInteger;
    max:= ArgToFloat(Args[3]);
    varx:= ArgToFloat(Args[4]);

    TIs:= TInter.create;
    TIs.Lfunxions.Add(f1);
    TIs.Lfunxions.Add(f2);
    TIs.max_:=max;
    TIs.min_:=min;
    TIs.vx:= varx;
    rpta:='';
    if (f1='') or (f2='') then begin;
        exit;
       //Result.ResInteger:=0;
      end
    else  begin
          TIs.execute();
          i:=0;
          cant:=TIs.Lr.Count;
          while i<cant do begin
             //ResultInts.Add( LineEnding +  '('+TIs.Lr[i]+','+TIs.Lfr[i]+')'  + LineEnding );
             ResultInts.Add(TIs.Lr[i]);   ResultInts.Add(TIs.Lfr[i]);
             rpta:= rpta + '('+TIs.Lr[i]+','+TIs.Lfr[i]+')';
             //Result.ResInteger:=1;
             i:=i+1;
          end;
          Result.ResString:= rpta;
    end;
    //ResultInts.Destroy;
    TIs.Destroy;
end;

procedure TPMeth.ExprEdo(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var EDO: TEDO;
    i: Integer;   rpta: String;
begin
    ShowMessage('ffff'+Args[0].ResString);
    Lfunxedo.Clear;
    Lsolxedo.Clear;
    EDO:= TEDO.create;             //rpta:= '';
    min:= ArgToFloat(Args[2]);     varx:= ArgToFloat(Args[2]);
    max:= ArgToFloat(Args[3]);     hedo:= EDO.h;
    EDO.x:=min;
    EDO.y:=max;
    EDO.N:= ArgToFloat(Args[4]);
    EDO.dfunx:= Args[0].ResString;
    EDO.fsol:= Args[1].ResString;
    if (Args[5].ResInteger = 0)  then
      EDO.EDOType:= 0
    else if (Args[5].ResInteger = 1)  then
        EDO.EDOType:= 1
    else if (Args[5].ResInteger = 2)  then
        EDO.EDOType:= 2
    else if (Args[5].ResInteger = 3)  then
        EDO.EDOType:= 3;

    EDO.execute;
    for i:=0 to EDO.Lfx.Count-1 do begin
        Lfunxedo.Add(EDO.Lfx[i]);
        Lsolxedo.Add(EDO.Lry[i]);
        //rpta:= rpta + '('+ FloatToStr(min)+','+EDO.Lfx[i]+')';
        //min:=min+ varx;
    end;
    //ShowMessage(rpta);
    Result.ResString:= rpta;
    EDO.Destroy;
end;

procedure tpmeth.loadArchivo(archivo_a_leer:String);
        var
            LineasArchivo: TStringList;
            unaLinea: String;
            i: Integer;
            //para obtener intervalo
            PosSeparador: Integer;
            X_,Y_:String;
        const
             Separador = ';';
        begin
            // Fase 1: Cargar Archivo En contendor
            LineasArchivo:= TStringList.Create();
            LineasArchivo.LoadFromFile(archivo_a_leer);
            // Fase 2: Procesar archivo
            //SetLength(EX.points, LineasArchivo.Count,2);//setear la cantidad de datos
            cant_ :=LineasArchivo.Count;
            i:=0;
            while i <  LineasArchivo.Count  do
            begin
              unaLinea:=LineasArchivo[i];
              PosSeparador:=Pos(Separador,unaLinea);// el que separa valores ;
              X_:=Copy(unaLinea,1,PosSeparador-1);
              Y_:=Copy(unaLinea,PosSeparador+1,Length(unaLinea)-PosSeparador);
              pointss.Add(X_);     pointss.Add(Y_);
              i:= i+1;
            end;
        // Fase 3: Guardar Archivo
        LineasArchivo.SaveToFile(archivo_a_leer);

        // Fase 4: Como somos limpios, limpiamos antes de salir
        LineasArchivo.Free;
 end;

procedure TPMeth.ExprExtr(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var EX: TExtra;
    i: integer;
    //cant_: integer;
    FileName: string;
    //pointss: TStringList;
    nr: TStringList;

begin
    LfexTra.Clear;
    LRexTra.Clear;
    nr:= TStringList.Create;
    nr.Add('rlin: ');
    nr.Add('rexp: ');
    nr.Add('rlog: ');
    nr.Add('rsenoid: ');
    EX:= TExtra.create;
    pointss.Create;
    FileName:= Args[0].ResString;
    loadArchivo(FileName);
    EX.cant:= cant_;
    i:=0;
    min:= StrToFloat(pointss[0]);
    max:= StrToFloat(pointss[cant_]);
    varx:= (max-min)/cant_;
    while i< pointss.Count do begin
        EX.points.Add(pointss[i]);
        EX.points.Add(pointss[i+1]);
        i:=i+2;
    end;

    EX.execute;
    for i:=0 to EX.frpt.Count-1 do begin
        //ShowMessage(EX.frpt[i]);
        LfexTra.Add(EX.frpt[i]);
    end;
    for i:=0 to EX.Rrpt.Count-1 do begin
        //ShowMessage(nr[i]+EX.Rrpt[i]);
        LRexTra.Add(nr[i]+EX.Rrpt[i]);
    end;

    Result.ResString:= FileName;
    nr.Destroy;
    //pointss.Destroy;
    EX.Destroy;
end;

//MATRIXS
//[],[],[]
function TPMeth.readMatrix(arg: String): mmatrix;
var i, j, k: integer;
    separador, s_p,
    corch, corchf: string;
    only_cont: TStringList;
begin
    only_cont:= TStringList.Create;
    r:= 1;        c:= 1;
    separador:=';';    s_p:=',';
    corch:= '[';   corchf:=']';

    for i:=0 to Length(arg)-1 do
       if (arg[i] = separador) then
           r:= r + 1;
    for j:=(Pos(corch, arg)) to (Pos(corchf, arg)) do
       if (arg[j] = s_p) then
           c:= c + 1;
    SetLength(Result, r, c);
    //recolected only content
    for k:= 1 to Length(arg) do begin
        if (arg[k]<> s_p) and (arg[k]<>separador) and (arg[k]<> corch) and (arg[k]<> corchf) then begin
            only_cont.Add(arg[k]);
        end;
    end;
    k:=0;
    for i:=0 to r-1 do
       for j:=0 to c-1 do begin
          Result[i,j]:= StrToFloat(only_cont[k]);
          k:= k+1;
       end;
 only_cont.Destroy;
end;

function TPMeth.EvaluateOpM(Input: string):string;
var   M: TMatrix;
      rpta: mmatrix;
      Arg: TStringList;
      i, j,
      r1, c1, r2, c2,
      pos_sig: integer;
      rpts, trpts: string;
begin
      rpts:= '';   trpts:='';
      M:= TMatrix.create();
      Arg:= TStringList.Create;
      if (Input[Pos('+', Input)] = '+') then begin
          pos_sig:= Pos('+', Input);
          M.TMatType:= 0;
      end
      else if (Input[Pos('-', Input)] = '-') then begin
          pos_sig:= Pos('-', Input);
          M.TMatType:= 1;
      end
      else if (Input[Pos('*', Input)] = '*') then  begin
          pos_sig:= Pos('*', Input);
          M.TMatType:= 2;
      end
      else if (Input[Pos('^', Input)] = '^') then  begin
          pos_sig:= Pos('^', Input);
          M.TMatType:= 7;
      end;                                        //[][]+[][]
      Arg.Add(Copy(Input, 1, Length(Input)-(Length(Input)-pos_sig +1)));
      Arg.Add(Copy(Input, pos_sig+1, Length(Input)-pos_sig));

      M.m1_:= readMatrix(Arg[0]);
      r1:= r;          c1:= c;
      M.m2_:= readMatrix(Arg[1]);
      r2:= r;          c2:= c;

      rpta:= M.execute;
      for i:=0 to r1-1 do begin
         rpts:= '';
         for j:=0 to c2-1 do begin
            if (j<> c2-1) then
              rpts:= rpts + FloatToStr(rpta[i][j])+','
            else rpts:= rpts + FloatToStr(rpta[i][j]);
         end;
         if (i<> r1-1) then
           trpts:= trpts+ '['+rpts+'];'
         else trpts:= trpts+ '['+rpts+']';
      end;
      Result:= trpts;
      Arg.Destroy;
      M.Destroy;
end;

function TPMeth.EvaluateOpM1(Input: string):string;
var   M: TMatrix;
      rpta: mmatrix;
      Arg: string;
      i, j,
      r1, c1,
      pos_sig: integer;
      det, rpt: real;
      rpts, trpts: string;
begin
      rpts:= '';   trpts:='';
      M:= TMatrix.create();
      if (Input[Pos('I', Input)] = 'I') then  begin
          pos_sig:= Pos('I', Input);
          M.TMatType:= 3;
      end
      else if (Input[Pos('^', Input)+1] = 'T') then  begin
          pos_sig:= Pos('^', Input);
          M.TMatType:= 5;  // A|-   A^T
      end;
      Arg:= Copy(Input, 1, Length(Input)-(Length(Input)-pos_sig +1));
      M.m1_:= readMatrix(Arg);
      r1:= r;          c1:= c;

      if (M.TMatType = 3) then   begin
          det:=M.det(M.m1_);
          if c1 <> r1 then begin
                ShowMessage('matriz no cuadrada');  exit;
          end;
          if det = 0 then begin
               ShowMessage('Matriz no invertible, Determinante 0');
               exit;
          end;
      end
      else if (M.TMatType = 5) then begin
           r1:= c1;     c1:=r1;
      end;

      rpta:= M.execute;
      for i:=0 to r1-1 do begin
         rpts:= '';
         for j:=0 to c1-1 do begin
            if (j<> c1-1) then  begin
              rpts:= rpts + FloatToStr(rpta[i][j])+',';
            end
            else rpts:= rpts + FloatToStr(rpta[i][j]);
         end;
         if (i<> r1-1) then
           trpts:= trpts+ '['+rpts+'];'
         else trpts:= trpts+ '['+rpts+']';
      end;
      Result:= trpts;
      {
      else if (Input[Pos('^', Input)+1] = '-') then  begin
          pos_sig:= Pos('^', Input);
          ShowMessage('-> '+IntToStr(pos_sig)+ '||||' +input[pos_sig]);
      end
      else if (Input[Pos('*', Input)+1] = '(') then
          pos_sig:= Pos('*', Input);
       }

       //Arg.Destroy;
       M.Destroy;
end;

Procedure TPMeth.AddFunctions();
begin
   with FParser.Identifiers do begin
       AddFunction('biseccion','F','SFFF', @ExprBisecc);
       AddFunction('falsa_posicion','F','SFFF', @ExprPF);
       AddFunction('newton','F','SSFF', @ExprN);
       AddFunction('secante','F','SFF', @ExprS);
       AddFunction('interseccion','S','SSFFF', @ExprInts);
       AddFunction('integral','F','SFFFS',@ExprIntg);
       AddFunction('edo','S','SSFFFI', @ExprEdo);
       AddFunction('extrapolar','S','S', @ExprExtr);
       //AddFunction('+','S','SS',@OpSUM);
       {
       AddFunction('-','S','SS',@OpMat);
       AddFunction('*','S','SS',@OpMat);
       AddFunction('^-1','S','S',@OpMatr);
       AddFunction('det','F','S',@OpMatr);
       AddFunction('^T','S','S',@OpMatr);
       AddFunction('*escalar','S','SF',@OpMatri);
       AddFunction('^','S','SI',@OpMatrix);
       }
   end

end;

procedure TPMeth.AddVariable( Variable: string; Value: Double );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;
   identifier[ Len - 1 ]:= FParser.Identifiers.AddFloatVariable( Variable, Value);
   ShowMessage('parsssssvaaaa '+ Variable+ '.---- '+ FloatToStr(value));
end;

procedure TPMeth.AddString( Variable: string; Value: string );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;

   identifier[ Len - 1 ]:= FParser.Identifiers.AddStringVariable( Variable, Value);
   ShowMessage('parsssss '+ Variable+ '.---- '+value);
end;

end.


