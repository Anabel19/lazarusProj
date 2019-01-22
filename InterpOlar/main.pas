unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, class_extra, TAGraph, TASeries;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Edit1: TEdit;
    Edit2: TEdit;
    num: TEdit;
    EJEX: TConstantLine;
    EJEY: TConstantLine;
    gf: TComboBox;
    Graficar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Memo4: TMemo;
    Panel1: TPanel;
    Plotear: TLineSeries;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    destructor Destroy; override;
  private
    cant_: integer;
    pointss: TStringList;
    procedure loadArchivo(archivo_a_leer:String);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.loadArchivo(archivo_a_leer:String);
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
  LineasArchivo.loadFromFile(archivo_a_leer);

  // Fase 2: Procesar archivo
  //SetLength(EX.points, LineasArchivo.Count,2);//setear la cantidad de datos
  cant_ :=LineasArchivo.Count;
  i:=0;
  while i <  LineasArchivo.Count  do
  begin
    unaLinea:=LineasArchivo[i];
    PosSeparador:=Pos(Separador,unaLinea);// el que separa valores ;
    X_:=Copy(unaLinea,1,PosSeparador-1);
    Y_:=copy(unaLinea,PosSeparador+1,Length(unaLinea)-PosSeparador);
    pointss.Add(X_);     pointss.Add(Y_);
    ShowMessage(x_);    ShowMessage(y_);
    //matrixDatos[i][0]:=StrToFloat(X_);matrixDatos[i][1]:=StrToFloat(Y_);
    i:= i+1;
   // ShowMessage(unaLinea);//Hacer_Algo_Con_Cada_Linea(unaLinea);
  end;
  // Fase 3: Guardar Archivo
  LineasArchivo.SaveToFile(archivo_a_leer);

  // Fase 4: Como somos limpios, limpiamos antes de salir
  LineasArchivo.Free;

end;

//normalizacion- proceso inverso de la normalizacion
procedure TForm1.Button1Click(Sender: TObject);
var i: integer;
    nombreFile:String;
    IT: TInter;
begin
    IT:= TInter.create;
    pointss.Clear;
    nombreFile:=Edit1.Text;
    loadArchivo(nombreFile);
    IT.cant:= cant_;
    IT.num_:= StrToFloat(num.Text);
    i:=0;
    while i < pointss.Count do begin
        IT.points.Add(pointss[i]);
        IT.points.Add(pointss[i+1]);
        i:=i+2;
    end;

    IT.execute;
    ShowMessage('ccan '+IntToStr(IT.frpt.Count-1));
    for i:=0 to IT.frpt.Count-1 do begin
        Memo1.Lines.Add(IT.frpt[i]);
    end;
    for i:=0 to IT.Vrpt.Count-1 do begin
        Memo1.Lines.Add('valor reemplazado: '+IT.Vrpt[i]);
    end;

    IT.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //EX:= TExtra.create;
  pointss:= TStringList.Create;
end;

destructor TForm1.Destroy;
begin
  //EX.Destroy;
  pointss.Destroy;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin

end;

end.

