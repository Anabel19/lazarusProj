unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, class_ma;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    x_: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private

    procedure CleanStringGrid;
    procedure CalculateErrors;

  public

  end;

var
  Form1: TForm1;

implementation
const
 col_pos = 0;
 col_suc = 1;
 col_err = 2;

{$R *.lfm}

{ TForm1 }

procedure TForm1.CalculateErrors;
var iRow: Integer;
    //CantDecimals: Integer;
    xn,
    xant:real;
    signo: String;
begin
//CantDecimals:= trunc( 1 / StrToFloat( Edit2.Text ) );
   with StringGrid1 do
   for iRow:= 2 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );
     xn:= StrToFloat( Cells[ col_suc,  iRow ] );
     xant:= StrToFloat( Cells[ col_suc,  iRow - 1 ] );

     Cells[ col_err, iRow ]:= FloatToStr( abs( xn - xant ) );

  end;

end;

procedure TForm1.CleanStringGrid;
begin
  with StringGrid1 do begin
    Clean;
    RowCount:= 1;
    Columns[ col_pos ].Title.Caption:= 'n';
    Columns[ col_suc ].Title.Caption:= 'Xn';
    Columns[ col_err ].Title.Caption:= '|Xn+1 - Xn|[Error]';
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var MA: TMA;
begin
  CleanStringGrid;
  MA:= TMA.create;
  MA.MAType:= RadioGroup1.ItemIndex;
  MA.xi:= StrToFloat( x_.Text );
  MA.Error:= StrToFloat( Edit2.Text );
  {Label1.Caption:= RadioGroup1.Items[ RadioGroup1.ItemIndex ] +
                   '( ' + x_.Text + ' ) = ' +
                   FloatToStr(  MC.execute ); }
  MA.execute;
  StringGrid1.RowCount:= MA.Lxn.Count;
  //MA.Lxn.Add('hola');
  //ShowMessage(MA.Lxn[0]);
  StringGrid1.Cols[ col_suc ].Assign( MA.Lxn );
  CalculateErrors;
  MA.Destroy;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CleanStringGrid;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin

end;

end.

