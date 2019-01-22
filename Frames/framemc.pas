unit framemc;

{$mode objfpc}{$H+}

interface

uses
  //Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ExtCtrls, Grids;
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, class_mc;
type

  { TTheFrame2 }

  TTheFrame2 = class(TFrame)
    a_: TEdit;
    Button1: TButton;
    b_: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
  Frame2: TTheFrame2;

implementation
 const
 col_pos = 0;
 col_a = 1;
 col_b = 2;
 col_suc = 3;
 col_sig = 4;
 col_err = 5;
{$R *.lfm}

{ TForm1 }

procedure TTheFrame2.CalculateErrors;
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
     signo:=  Cells[ col_sig, iRow - 1];
     if (signo='-') then begin
        Cells[ col_a, iRow] := FloatToStr(xn);
        Cells[ col_b, iRow] := FloatToStr(xn);
     end
     else   Cells[ col_b, iRow] := FloatToStr(xn);
     Cells[ col_err, iRow ]:= FloatToStr( abs( xant - xn ) );
  {
     Cells[ col_err2, iRow ]:= FloatToStr( abs( (xant - xn)/ xn ) );
     Cells[ col_err3, iRow ]:= FloatToStr( round( abs( (xant - xn)/ xn )*CantDecimals )/CantDecimals ) + '%';
  }
  end;

end;

procedure TTheFrame2.CleanStringGrid;
begin
  with StringGrid1 do begin
    Clean;
    RowCount:= 1;
    Columns[ col_pos ].Title.Caption:= 'n';
    Columns[ col_a ].Title.Caption:= 'a';
    Columns[ col_b ].Title.Caption:= 'b';
    Columns[ col_suc ].Title.Caption:= 'Xn';
    Columns[ col_sig ].Title.Caption:= 'signo';
    Columns[ col_err ].Title.Caption:= '|Xn+1 - Xn|';
  end;
end;

procedure TTheFrame2.Button1Click(Sender: TObject);
var MC: TMC;
begin
  CleanStringGrid;
  MC:= TMC.create;
  MC.MCType:= RadioGroup1.ItemIndex;
  MC.a:= StrToFloat( a_.Text );
  MC.b:= StrToFloat( b_.Text );
  MC.Error:= StrToFloat( Edit2.Text );
  {Label1.Caption:= RadioGroup1.Items[ RadioGroup1.ItemIndex ] +
                   '( ' + a_.Text + ' ) = ' +
                   FloatToStr(  MC.execute ); }
  MC.execute;
  StringGrid1.RowCount:= MC.Lxn.Count;
  ShowMessage(MC.Lxn[0]);
  StringGrid1.Cols[ col_suc ].Assign( MC.Lxn );
  StringGrid1.Cols[ col_sig ].Assign( MC.Lsig );
  CalculateErrors;
  MC.Destroy;

end;

procedure TTheFrame2.FormCreate(Sender: TObject);
begin
  CleanStringGrid;
end;

procedure TTheFrame2.RadioGroup1Click(Sender: TObject);
begin

end;

end.

