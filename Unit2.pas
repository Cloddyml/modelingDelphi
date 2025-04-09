unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls,
  System.Math;

type
  TForm2 = class(TForm)
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;     // Иницилизация окна, в котором будет отображаться информация о системе в StringGrid


implementation

{$R *.dfm}





procedure TForm2.FormCreate(Sender: TObject);
var
    i: integer;
begin
    with StringGrid1 do   // Создание начальных ячеек для StringGrid
    begin
        Cells[0, 0] := 'Имя звезды';
        Cells[1, 0] := 'Радиус зв., км';
        Cells[2, 0] := 'Масса зв., с.м.';
        Cells[3, 0] := 'Грав. постоянная';
        Cells[0, 3] := 'Имя планеты';
        Cells[1, 3] := 'Радиус пл., км';
        Cells[2, 3] := 'Масса пл., з.м.';
        Cells[3, 3] := 'Орб. R пл., а.е.';
        Cells[4, 3] := 'Скорость пл., м/с';
        Cells[5, 3] := 'Период обращения пл., год';
        for i := 0 to ColCount - 2 do
            Cells[i, 2] := '----------------------------------';
    end;
end;
end.
