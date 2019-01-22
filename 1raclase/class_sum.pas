unit class_sum;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
    TsumaN= class

    private
    public
      n:Integer;
      function sum():Integer;
      function par():Integer;
      function impar():Integer;
end;

implementation
function TsumaN.sum():Integer;
var
  i:Integer;
begin
   //Result:=n*(n+1)/2;
  Result:=0;
  for i:=0 to n do
      Result:=Result+i;
      par();
      impar();
end;

function TsumaN.par():Integer;
var
  i:Integer;
begin
   //Result:=n*(n+1)/2;
  Result:=0;
  for i:=0 to Floor(n/2) do
    //if i%2=0 then
       Result:=Result+i;
end;

function TsumaN.impar():Integer;
var
  i:Integer;
begin
   //Result:=n*(n+1)/2;
  Result:=0;
  for i:=0 to Floor(n/2) do
   // if i%2<>0 then
       Result:=Result+i;

end;
end.

