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
  Form2: TForm2;     // ������������ ����, � ������� ����� ������������ ���������� � ������� � StringGrid


implementation

{$R *.dfm}





procedure TForm2.FormCreate(Sender: TObject);
var
    i: integer;
begin
    with StringGrid1 do   // �������� ��������� ����� ��� StringGrid
    begin
        Cells[0, 0] := '��� ������';
        Cells[1, 0] := '������ ��., ��';
        Cells[2, 0] := '����� ��., �.�.';
        Cells[3, 0] := '����. ����������';
        Cells[0, 3] := '��� �������';
        Cells[1, 3] := '������ ��., ��';
        Cells[2, 3] := '����� ��., �.�.';
        Cells[3, 3] := '���. R ��., �.�.';
        Cells[4, 3] := '�������� ��., �/�';
        Cells[5, 3] := '������ ��������� ��., ���';
        for i := 0 to ColCount - 2 do
            Cells[i, 2] := '----------------------------------';
    end;
end;
end.
