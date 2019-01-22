unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  class_sum;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnExecute: TButton;
    EdiN: TEdit;
    lblResult1: TLabel;
    lblResult2: TLabel;
    lblResult: TLabel;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblResult1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnExecuteClick(Sender: TObject);
var MySum: TsumaN;
begin
  MySum:=TsumaN.Create();
  MySum.n:=StrToInt(ediN.Text);
  lblResult.Caption:=IntToStr(MySum.sum());
  lblResult1.Caption:=IntToStr(MySum.par());
  lblResult2.Caption:=IntToStr(MySum.impar());
  MySum.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.lblResult1Click(Sender: TObject);
begin

end;

end.

