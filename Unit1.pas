unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  System.Math,   // ��� ��������� �������������� �������, ������������ � �����������
  Vcl.Imaging.jpeg,
  Unit2;   // ��� ������ ����� �� ������ ������

// �������� ������ ������
type
    TStar = class
    private
        FMass: double;
        FFRad: double;
        FIRad: double;
        FPos: TPoint;
        FName: string;
        FColor: TColor;
    public
        const
            ro = 10000000; // ������� ��������� �����
        constructor Create(Mass:double; Name: String; Color: TColor);  // �������� ������� - ������
        Procedure CreatePic(Field: TCanvas);
        property Mass: double read FMass;
        property Rad: double read FFRad;
        property Pos: TPoint read FPos;
        property Name: string read FName;
        property Color: TColor read FColor write FColor;

end;

// �������� ������ ������
type
    TPlanet = class
    private
        FMass: double;
        FFRad: double;
        FIRad: integer;
        FPos: TPoint;
        FName: string;
        FColor: TColor;
        FPoses: array of TPoint;
        FFDist: double;
        FIDist: double;
        FAngle: double;
        FPeriod: double;
        FVelocity: double;
    public
        const
            ro = 5000;
        constructor Create(Mass: double; Name: string; Color: TColor; Dist: Double);   // �������� ������� - �������
        Procedure MovePl(deltaT: double; pl: TPlanet);
        Function CalcVelocity(StarMass: Double; planet: TPlanet): double;
        Function CalcPeriod(planet: TPlanet): double;
        procedure AddNewPoint(cur_x, cur_y: integer);
        Procedure CreatePic(Field: TCanvas);
        property Mass: double read FMass;
        property Pos: TPoint read FPos;
        property Name: string read FName;
        property Color: TColor read FColor write FColor;
        property Dist: double read FFDist write FFDist;
        property Angle: double read FAngle write FAngle;
        property Velocity: double read FVelocity write FVelocity;
        property Period: double read FPeriod write FPeriod;
end;

 // �������� ������ �����
type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    ObjEdit: TMenuItem;
    AddAst: TMenuItem;
    DelAst: TMenuItem;
    EditAst: TMenuItem;
    AddPl: TMenuItem;
    DelPl: TMenuItem;
    EditPl: TMenuItem;
    N6: TMenuItem;
    ParSys: TMenuItem;
    GravConst: TMenuItem;
    ViewSys: TMenuItem;
    SysEdit: TMenuItem;
    ContSys: TMenuItem;
    PauseSys: TMenuItem;
    DefSys: TMenuItem;
    N3: TMenuItem;
    Image1: TImage;
    N1: TMenuItem;
    InfoSys: TMenuItem;
    Help: TMenuItem;
    StartSys: TMenuItem;
    colorAst: TMenuItem;
    colorPl: TMenuItem;
    N5: TMenuItem;
    orbitOn: TMenuItem;
    orbitOff: TMenuItem;
    Timer1: TTimer;
    Speed: TMenuItem;
    Speed5: TMenuItem;
    Speed4: TMenuItem;
    Speed3: TMenuItem;
    Speed2: TMenuItem;
    Speed1: TMenuItem;
    procedure InfoSysClick(Sender: TObject);
    procedure AddAstClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddPlClick(Sender: TObject);
    procedure GravConstClick(Sender: TObject);
    procedure DelAstClick(Sender: TObject);
    procedure PauseSysClick(Sender: TObject);
    procedure StartSysClick(Sender: TObject);
    procedure ContSysClick(Sender: TObject);
    procedure colorAstClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DefSysClick(Sender: TObject);
    procedure orbitOnClick(Sender: TObject);
    procedure orbitOffClick(Sender: TObject);
    Procedure UpdInfo();
    Procedure UpdImageCol();
    procedure colorPlClick(Sender: TObject);
    procedure DelPlClick(Sender: TObject);
    procedure EditPlClick(Sender: TObject);
    procedure EditAstClick(Sender: TObject);
    procedure Speed1Click(Sender: TObject);
    procedure Speed2Click(Sender: TObject);
    procedure Speed3Click(Sender: TObject);
    procedure Speed4Click(Sender: TObject);
    procedure Speed5Click(Sender: TObject);
    procedure HelpClick(Sender: TObject);
  private
    { Private declarations }
    count_of_planets: integer; // ������� ������
    info_flag: boolean; // �������� �� ������������� ������ �������������
    DeltaTime: double; // ������� �� �������
  public
    { Public declarations }
    G: extended; // ����. ���������
end;


var
  Form1: TForm1;
  Form2: TForm2; // ���������� ���������� ��� ������ �� ������ ������ �����
  Star: TStar;  // ���������� ���������� ������
  Planets: array [1..8] of TPlanet; // ���������� ���������� ������� ������

implementation

{$R *.dfm}




constructor TStar.Create(Mass:double; Name: string; Color: TColor); // ����������� ������
begin
    FMass := Mass * 1.989 * power(10, 30);
    FFRad := power(FMass / ro * 3.0 / (4.0 * pi), 1.0 / 3.0);
    FPos := Point(Form1.Image1.Width div 2, Form1.Image1.Height div 2);
    FName := Name;
    FColor := Color;
    FIRad := 10;
end;


procedure TStar.CreatePic(Field: TCanvas);    // ����� ��������� ������
begin
    with Field do
    begin
        Pen.Color := FColor;
        Brush.Style := bsSolid;
        Brush.Color := FColor;
        Ellipse(Round(FPos.X - FIRad), Round(Pos.Y - FIRad), Round(Pos.X + FIRad), Round(Pos.Y + FIRad));
        Refresh;
    end;
end;




constructor TPlanet.Create(Mass: Double; Name: string; Color: TColor; Dist: Double);  // ����������� �������
begin
    FMass := Mass * 5.98 * power(10, 24);
    FFRad := power(FMass / ro * 3.0 / (4.0 * pi), 1.0 / 3.0);
    FPos := Point(Form1.Image1.Width div 2, Form1.Image1.Height div 2);
    FName := Name;
    FColor := Color;
    FIRad := 5;
    SetLength(FPoses, 1);
    FFDist := Dist * 149600000000;
    FIDist := Dist * 75;
    FPoses[0].X := round(FPos.X + FIDist);
    FPoses[0].Y := round(FPos.Y);
    FAngle := 0;
    if Assigned(Star) then
    begin
        FVelocity := sqrt((Form1.G * Star.FMass) / FFDist);
        FPeriod := (2 * pi * sqrt(power((2 * FFDist) / 2, 3) / (Form1.G * (Star.FMass + FMass)))) / (60 * 60 * 24 * 365);
    end
    else
    begin
        FVelocity := infinity;
        FPeriod := infinity;
    end;
end;

 // ����� ��������� �������
procedure TPlanet.CreatePic(Field: TCanvas);
begin
    with Field do
    begin
        Pen.Color := FColor;
        Brush.Style := bsSolid;
        Brush.Color := FColor;
        Ellipse(Round(FPoses[High(FPoses)].X - FIRad), Round(FPoses[High(FPoses)].Y - FIRad), Round(FPoses[High(FPoses)].X + FIRad), Round(FPoses[High(FPoses)].Y + FIRad));
        Refresh;
    end;
end;

 // ����� ���������� � ������ �����, ��� ���� �������
procedure TPlanet.AddNewPoint(cur_x, cur_y: integer);
begin
    SetLength(FPoses, Length(FPoses) + 1);
    FPoses[High(FPoses)] := Point(cur_x, cur_y);
end;

 // ����� �������� �������� �������
Function TPlanet.CalcVelocity(StarMass: Double; planet: TPlanet): double;
begin
    planet.FVelocity := sqrt((Form1.G * StarMass) / planet.FFDist);
    Result := planet.FVelocity;
end;

 // ����� �������� ������� �������
Function TPlanet.CalcPeriod(planet: TPlanet): Double;
begin
    planet.FPeriod := (2 * pi * sqrt(power((2 * planet.FFDist) / 2, 3) / (Form1.G * (Star.FMass + planet.FMass)))) / (60 * 60 * 24 * 365);
    Result := planet.FPeriod;
end;

 // ����� �������� �������� ������
procedure TPlanet.MovePl(deltaT: double; pl: TPlanet);
begin
    // ������������ ����� ���� � ���������� ��� �������
    pl.FAngle := pl.FAngle + deltaT * 2 * pi / (pl.CalcPeriod(pl) * (24 * 60 * 60));

    // ��������� ����� ���������� �������
    pl.AddNewPoint(round(FPos.X + pl.FIDist * Cos(pl.FAngle)), round(FPos.Y - pl.FIDist * Sin(pl.FAngle)));
end;


 // ��������� ���������� ���������� �� ������ �����
procedure TForm1.UpdInfo();
var
    i, j, k: integer;
begin
    with Form2.StringGrid1 do
    begin
        Cells[3, 1] := FloatToStr(G);  // ������ �������������� ���������
        if Assigned(Star) then
        begin                          // ������ ������ ������
            Cells[0, 1] := Star.FName;
            Cells[1, 1] := FloatToStr(Star.FFRad / 1000);
            Cells[2, 1] := FloatToStr(Star.FMass / (1.989 * power(10, 30)));
        end;
        if count_of_planets <> 0 then  // ������ ������ ������
        begin
            i := 4;
            for k := 1 to count_of_planets do
            begin
                if Assigned(Planets[k]) then
                begin
                    for j := 0 to ColCount - 1 do
                    begin
                    if (j = 0) then
                        Cells[j, i] := Planets[k].FName;   // ������ �����
                    if (j = 1) then
                        Cells[j, i] := FloatToStr(Planets[k].FFRad / 1000);  // ������ ������������ �������
                    if (j = 2) then
                        Cells[j, i] := FloatToStr(Planets[k].FMass / (5.98 * power(10, 24)));  // ������ �����
                    if (j = 3) then
                        Cells[j, i] := FloatToStr(Planets[k].FIDist / 75);  //������ ����������
                    if (j = 4) then
                        Cells[j, i] := FloatToStr(Planets[k].FVelocity); // ������ ��������
                    if (j = 5) then
                        Cells[j, i] := FloatToStr(Planets[k].FPeriod);   // ������ �������
                    end;
                    if i <= RowCount - 1 then
                        i := i + 1;
                end;
            end;
        end;
    end;
end;

 // ��������� ���������� �����
procedure TForm1.UpdImageCol();
var
    i: integer;
    ImageNew: TBitmap;
begin
    ImageNew := TBitmap.Create;
    ImageNew.Height := Image1.Height;
    ImageNew.Width := Image1.Width;
    ImageNew.LoadFromFile('BackG.bmp');
    if count_of_planets <> 0 then
      for i := 1 to count_of_planets do
          if Assigned(Planets[i]) then
              Planets[i].CreatePic(ImageNew.Canvas);
    if Assigned(Star) then
        Star.CreatePic(ImageNew.Canvas);
    Image1.Canvas.Draw(0, 0, ImageNew);
end;




 // ��������� ���������� ������ � ������
procedure TForm1.AddAstClick(Sender: TObject);
var
    astName, colorName, m, tempName: string;
    astColor: TColor;
    astMass: Double;
    colorDialog: TColorDialog;
    i: integer;
begin
    // �������� ���������� ����������� ���� ������ �����
    colorDialog := TColorDialog.Create(self);
    try
      // ���������� �� ������������� ����������� ���� ��������� �����
      colorDialog.Options := colorDialog.Options + [cdFullOpen];
      // ������� ���������� ����� � ���������� ����
      colorDialog.Color := clYellow;
      // ����������� ����������� ���� � �������� ����������
      if colorDialog.Execute then
          astColor := colorDialog.Color
      else
          Exit; // ������ ����������
    finally
        colorDialog.Free;
    end;

    // ����� ����������� ���� ����� ������ � ���������� ���������� - ���
    if InputQuery('���������� ������', '������� ��� �������:', astName) then
    begin
        tempName := astName;
        tempName := tempName.Replace(' ', '', [rfReplaceAll]);
        if (tempName <> '') and (astName <> '') then
        begin
            // ����� ����������� ���� ����� ������ � ���������� ���������� - �����
            if InputQuery('���������� ������', '������� ����� ������ (� ��������� ������):', m) then
            begin
                if (TryStrToFloat(m, astMass) = False) then
                begin
                    ShowMessage('�� ����� �������� �������� �����.');
                    Exit
                end
                else
                begin
                    if astMass <= 0 then begin
                        ShowMessage('�� ����� �������� �������� �����.');
                        Exit;
                    end
                    else
                    begin
                        // ����������� ��������� � ���������� ������� �������
                        colorName := ColorToString(astColor);
                        colorName := ColorName.Replace('cl', '');
                        ShowMessageFmt('�� �������� ������ "%s" � ������ "%f" �.�. � � ������ "%s"',
                        [astName, astMass, colorName]);

                        // �������� ���������� ������ ������� � ���������� ����������
                        // � ���������� ��� ����������� � ������ �����
                        Star := TStar.Create(astMass, trim(astName), astColor);  // �������� ������� ������
                        delAst.Enabled := True;     // ��������� ������ �������� ������ �� ������
                        addAst.Enabled := False;    // ���������� ������ ���������� ������ �� ������
                        editAst.Enabled := True;    // ��� ��� ��������� ������������� �������
                        ColorAst.Enabled := True;   // ��� ��� ��������� ����� ������
                        Star.CreatePic(Image1.Canvas);  // ��������� ������ �� �����
                        if (Assigned(Star)) and (count_of_planets > 0) then
                        begin
                            StartSys.Enabled := True;    // ��� ������ ��� ������� ���������, ���� ���������� ������ � ���� �� ���� �������
                            editPl.Enabled := True;   // ��� ��� ��������� ������������� ������
                        end;
                        // ���������� �������� � ������� ������
                        if count_of_planets <> 0 then
                            for i := 1 to count_of_planets do
                            begin
                                Planets[i].FVelocity := sqrt((Form1.G * Star.FMass) / Planets[i].FFDist);
                                Planets[i].FPeriod := (2 * pi * sqrt(power((2 * Planets[i].FFDist) / 2, 3) / (Form1.G * (Star.FMass + Planets[i].FMass)))) / (60 * 60 * 24 * 365);
                            end;
                        UpdInfo();
                    end;
                end
            end;
        end
        else
        begin
            ShowMessage('�� �� ����� ��� ������.');
            Exit;
        end;
    end;
end;

 // ��������� ���������� ������� � ������
procedure TForm1.AddPlClick(Sender: TObject);
var
    plName, colorName, m, dist, tempName: string;
    plColor: TColor;
    plMass, plDistance: double;
    colorDialog: TColorDialog;
begin
// �������� ���������� ����������� ���� ������ �����
    colorDialog := TColorDialog.Create(self);
    try
      // ���������� �� ������������� ����������� ���� ��������� �����
      colorDialog.Options := colorDialog.Options + [cdFullOpen];
      // ������� ���������� ����� � ���������� ����
      colorDialog.Color := clGreen;
      // ����������� ����������� ���� � �������� ����������
      if colorDialog.Execute then
          plColor := colorDialog.Color
      else
          Exit; // ������ ����������
    finally
        colorDialog.Free;
    end;

    // ����� ����������� ���� ����� ������ � ���������� ���������� - ���
    if InputQuery('���������� �������', '������� ��� �������:', plName) then
    begin
        tempName := plName;
        tempName := tempName.Replace(' ', '', [rfReplaceAll]);
        if (tempName <> '') and (plName <> '') then
        begin
        
            // ����� ����������� ���� ����� ������ � ���������� ���������� - �����
            if InputQuery('���������� �������', '������� ����� ������� (� ������ ������):', m) then
            begin
                if (TryStrToFloat(m, plMass) = False) then   // �������� �� ������������ �����
                begin
                    ShowMessage('�� ����� �������� �������� �����.');
                    Exit
                end
                else
                begin
                    if plMass <= 0 then begin
                        ShowMessage('�� ����� �������� �������� �����.');
                        Exit;
                    end
                    else
                    begin  // ���������� ���� �� ��������� ���������� �� ������ �� ��������
                        if InputQuery('���������� �������', '������� ���������� ������� �� ������ (� �.�.):', dist) then
                        begin
                            if (TryStrToFloat(dist, plDistance) = False) then   // �������� �� ������������
                            begin
                                ShowMessage('�� ����� �������� �������� ����������.');
                                Exit
                            end
                            else
                            begin
                                // ����������� ��������� � ���������� ������� �������
                                colorName := ColorToString(plColor);
                                colorName := ColorName.Replace('cl', '');
                                ShowMessageFmt('�� �������� ������� "%s" � ������ "%f" �.�.,������ "%s" � ����������� "%f" �.�. �� ������.',
                                [plName, plMass, colorName, plDistance]);
                                // �������� ���������� ������ ������� � ���������� ����������
                                ColorPl.Enabled := True;  // ��� ��� ��������� ����� ������
                                count_of_planets := count_of_planets + 1; // ���������� �������� ���-�� ������
                                if count_of_planets > 0 then
                                    delPl.Enabled := True;   // ��� ������ �������� �������
                                if count_of_planets = 8 then
                                    addPl.Enabled := False;  // ���� ��� �������� ������
                                Planets[count_of_planets] := TPlanet.Create(plMass, trim(plName), plColor, plDistance);  // �������� ������� �������
                                Planets[count_of_planets].CreatePic(Image1.Canvas);  // ��������� ������� �� �����
                                if (Assigned(Star)) and (count_of_planets > 0) then
                                begin
                                    StartSys.Enabled := True; // ��� ��� ������� ���������, ���� ���������� ������ � ���� �� ���� �������
                                    editPl.Enabled := True;   // ��� ��� ��������� ������������� ������
                                end;
                                UpdInfo();
                            end;
                        end;
                    end;
                end
            end;
        end
        else
        begin
            ShowMessage('�� �� ����� ��� �������.');
            Exit;
        end;
    end;
end;

 // ��������� ��������� ����� ������
procedure TForm1.colorAstClick(Sender: TObject);
var
    astColor: TColor;
    colorDialog: TColorDialog;
    tempName_new, tempName_prev: string;
begin
     colorDialog := TColorDialog.Create(self);
    try
        // ���������� �� ������������� ����������� ���� ��������� �����
        colorDialog.Options := colorDialog.Options + [cdFullOpen];
        // ������� ���������� ����� � ���������� ����
        colorDialog.Color := Star.FColor;
        // ����������� ����������� ���� � �������� ����������
        if colorDialog.Execute then
            astColor := colorDialog.Color
        else
            Exit; // ������ ���������
    finally
        colorDialog.Free;  // ������������ ������ �� ����� ��������� ����
    end;
    tempName_new := ColorToString(astColor);
    tempName_prev := ColorToString(Star.FColor);
    tempName_new := tempName_new.Replace('cl', '');
    TempName_prev := tempName_prev.Replace('cl', '');
    ShowMessageFmt('�� �������� ���� ������: %s ������� �� %s',
    [tempName_prev, tempName_new]);
    Star.FColor := astColor; // ��������� ����� ������
    UpdImageCol(); // ���������� �����
    UpdInfo();
end;

 // ��������� ��������� ����� �������
procedure TForm1.colorPlClick(Sender: TObject);
var
    i: integer;
    plColor: TColor;
    colorDialog: TColorDialog;
    tempName_new, tempName_prev, planetName: string;
    Edited: boolean;
begin                         // ��������� ����� �������, ������� ����� ��������
    Edited := True;
    if InputQuery('��������� ����� �������', '������� ��� �������:', planetName) then
    begin
        Edited := False;
        for i := 1 to count_of_planets do
        begin             // ��������, ��������� �� ��� � �����-���� �� ������
            if LowerCase(Trim(planetName)) = LowerCase(Trim(Planets[i].FName)) then
            begin
                Edited := True;
                colorDialog := TColorDialog.Create(self);
                try
                    // ���������� �� ������������� ����������� ���� ��������� �����
                    colorDialog.Options := colorDialog.Options + [cdFullOpen];
                    // ������� ���������� ����� � ���������� ����
                    colorDialog.Color := Planets[i].FColor;
                    // ����������� ����������� ���� � �������� ����������
                    if colorDialog.Execute then
                    begin
                        plColor := colorDialog.Color

                    end
                    else
                        Exit; // ������ ���������
                finally
                    colorDialog.Free;
                end;
                tempName_new := ColorToString(plColor);
                tempName_prev := ColorToString(Planets[i].FColor);
                tempName_new := tempName_new.Replace('cl', '');
                TempName_prev := tempName_prev.Replace('cl', '');
                ShowMessageFmt('�� �������� ���� ������� "%s": %s ������� �� %s',
                [planetName, tempName_prev, tempName_new]);
                Planets[i].Color := plColor; // ��������� ����� ��������� �������
                UpdImageCol();  // ���������� �����    \
                UpdInfo();
            end;
        end;
    end
    else
        ShowMessage('�� �������� ��������� ����� �������.');
    if Edited = False then
        ShowMessage('������� � ����� ������ �� ����������.');
end;

 // ��������� ������� ������ ������
procedure TForm1.ContSysClick(Sender: TObject);
begin
    Timer1.Enabled := True;  // ��������� �������
    ContSys.Enabled := False;  // ���� ��� ���� ���������
    PauseSys.Enabled := True;  // ��� ��� ��� ��������� �������
end;

// ��������� ������ ������� � ������������ ����
procedure TForm1.DefSysClick(Sender: TObject);
var
buffer_init: TBitmap;
i: integer;
begin
    PauseSys.Enabled := False; // ���� ��� ����� �������
    if (Assigned(Star)) and (count_of_planets <> 0) then
        StartSys.Enabled := True;  // ��� ��� ������� �������
    ContSys.Enabled := False;  // ���� ��� ����������� ������ ���
    DefSys.Enabled := False;   // ���� ��� ������ ������� � ������������ ����
    Timer1.Enabled := False;   // ���� �������
    buffer_init := TBitmap.Create;  // �������� ������� �����������, ��� ����� �������������� ����������� ��� �������
    buffer_init.Width := Image1.Width; // ����������� ������ � �������, ��� ����� ��������� ������
    buffer_init.Height := Image1.Height; // ����������� ������ � �������, ��� ����� ��������� ������
    buffer_init.LoadFromFile('BackG.bmp'); // �������� �� ����� ����
    if Assigned(Star) then
        Star.CreatePic(buffer_init.Canvas); // ��������� ������
    G :=  6.6743e-11; // ������� ������������ �������� �������������� ����������
    if count_of_planets <> 0 then  // ��������� ������
        for i := 1 to count_of_planets do
        begin
            Planets[i].FPoses[0].X := round(Planets[i].FIDist + Planets[i].FPos.X);
            Planets[i].FPoses[0].Y := round(Planets[i].FPos.Y);
            SetLength(Planets[i].FPoses, 1);
            Planets[i].CreatePic(buffer_init.Canvas);
            Planets[i].FAngle := 0;
            if Assigned(Star) then
            begin
                Planets[i].FVelocity := sqrt((Form1.G * Star.FMass) / Planets[i].FFDist);
                Planets[i].FPeriod := (2 * pi * sqrt(power((2 * Planets[i].FFDist) / 2, 3) / (Form1.G * (Star.FMass + Planets[i].FMass)))) / (60 * 60 * 24 * 365);
            end
            else
            begin
                Planets[i].FPeriod := infinity;
                Planets[i].FVelocity := infinity;
            end;
        end;
    Image1.Canvas.Draw(0, 0, buffer_init);  // ����������� �� �������� ������
    buffer_init.Free; // ������������ ������ �� �������
    UpdInfo();
end;

 // ��������� �������� ������
procedure TForm1.DelAstClick(Sender: TObject);
var
    i: integer;
begin
    Star.Color := clNone;
    FreeAndNil(Star);
    addAst.Enabled := True;
    delAst.Enabled := False;
    editAst.Enabled := False;
    editPl.Enabled := False;
    pauseSys.Enabled := False;
    Timer1.Enabled := False;
    StartSys.Enabled := False;
    ContSys.Enabled := False;
    UpdImageCol();
    With Form2.StringGrid1 do
    begin
        Cells[0, 1] := '';
        Cells[1, 1] := '';
        Cells[2, 1] := '';
    end;
    if count_of_planets <> 0 then
        for i := 1 to count_of_planets do
            begin
                Planets[i].FPeriod := infinity;
                Planets[i].FVelocity := infinity;
            end;
    ShowMessage('�� ������� ������� ������.');
    UpdInfo();
end;

procedure TForm1.DelPlClick(Sender: TObject);
var
    deleted: boolean;
    planetName: string;
    i, mem, j: integer;
begin
    deleted := True;
    if InputQuery('�������� �������', '������� ��� �������:', planetName) then
    begin
        deleted := False;
        for i := 1 to count_of_planets do
        begin
            if LowerCase(Trim(planetName)) = LowerCase(Trim(Planets[i].FName)) then
            begin
                mem := i;
                deleted := True;
                Planets[i].FColor := clNone;
                addPl.Enabled := True;
                for j := mem to count_of_planets - 1 do
                begin
                    Move(Planets[j + 1], Planets[j], SizeOf(Planets[j + 1]));
                    if j = count_of_planets then
                    begin
                        FreeAndNil(Planets[j + 1]);
                    end;
                end;
                count_of_planets := count_of_planets - 1;
                with Form2.StringGrid1 do
                    begin
                        Cells[0, 3 + count_of_planets + 1] := '';
                        Cells[1, 3 + count_of_planets + 1] := '';
                        Cells[2, 3 + count_of_planets + 1] := '';
                        Cells[3, 3 + count_of_planets + 1] := '';
                        Cells[4, 3 + count_of_planets + 1] := '';
                        Cells[5, 3 + count_of_planets + 1] := '';
                    end;
                if count_of_planets = 0 then
                begin
                    delPl.Enabled := False;
                    EditPl.Enabled := False;
                    Timer1.Enabled := False;
                    defSys.Enabled := True;
                    pauseSys.Enabled := False;
                    StartSys.Enabled := False;
                    contSys.Enabled := False;
                end;
                UpdImageCol();
                UpdInfo();
                ShowMessageFmt('�� ������� ������� ������� � ������ "%s".', [planetName]);
            end;
        end;
    end
    else
        ShowMessage('�� �������� �������� �������.');
    if Deleted = False then
        ShowMessage('������� � ����� ������ �� ����������.');
end;

procedure TForm1.EditAstClick(Sender: TObject);
var
    tempName, param, newName, val: string;
    newVal: double;
    i: integer;
begin
    if InputQuery('��������� ��������� ������', '����� �������� ���������� ��������?([mass], [name]):', param) then
    begin
        param := param.Replace('[', '', [rfReplaceAll]);
        param := param.Replace(']', '', [rfReplaceAll]);
        if Trim(LowerCase(param)) = 'name' then
        begin
            if InputQuery('��������� ��������� ������', '������� ����� ��� ������:', newName) then
            tempName := newName;
            tempName := tempName.Replace(' ', '', [rfReplaceAll]);
            if (tempName <> '') and (newName <> '') then
            begin
                ShowMessageFmt('�� �������� ��� ������: "%s" �� "%s"',
                [Star.FName, newName]);
                Star.FName := newName;
            end
            else
            begin
                ShowMessage('�� ����� �������� ���');
                Exit;
            end;
        end
        else if Trim(LowerCase(param)) = 'mass' then
        begin
            if InputQuery('��������� ��������� ������', '������� ����� �������� ����� ������:', val) then
            begin
                if TryStrToFloat(val, newVal) = False then
                begin
                    ShowMessage('�� ����� ����������� �������.');
                    Exit;
                end
                else
                begin
                    ShowMessageFmt('�� �������� ����� ������ � "%f" �� "%f"',
                    [Star.FMass / (1.989 * power(10, 30)), newVal]);
                    Star.FMass := newVal * 1.989 * power(10, 30);
                    Star.FFRad := power(Star.FMass * 3.0 / (4.0 * pi), 1.0 / 3.0);
                    if count_of_planets <> 0 then
                        for i := 1 to count_of_planets do
                        begin
                            Planets[i].FVelocity := sqrt((Form1.G * Star.FMass) / Planets[i].FFDist);
                            Planets[i].FPeriod := (2 * pi * sqrt(power((2 * Planets[i].FFDist) / 2, 3) / (Form1.G * (Star.FMass + Planets[i].FMass)))) / (60 * 60 * 24 * 365);
                        end;
                end;
            end;
        end
        else
        begin
            ShowMessage('�� ����� �������� ��������.');
            Exit;
        end;
    end;
    UpdInfo();
end;

procedure TForm1.EditPlClick(Sender: TObject);
var
    i: integer;
    tempName, planetName, param, newName, val: string;
    newVal: double;
    edited: boolean;
begin
    edited := True;
    if InputQuery('��������� ��������� �������', '������� ��� �������:', planetName) then
    begin
        edited := False;
        for i := 1 to count_of_planets do
        begin
            if LowerCase(Trim(planetName)) = LowerCase(Trim(Planets[i].FName)) then
            begin
                edited := True;
                if InputQuery('��������� ��������� �������', '����� �������� ���������� ��������?([dist], [mass], [name]):', param) then
                begin
                    param := param.Replace('[', '', [rfReplaceAll]);
                    param := param.Replace(']', '', [rfReplaceAll]);
                    if Trim(LowerCase(param)) = 'dist' then
                    begin
                        if InputQuery('��������� ��������� �������', '������� ����� �������� ���������� �� ������:', val) then
                        begin
                            if TryStrToFloat(val, newVal) = False then
                            begin
                                ShowMessage('�� ����� ����������� �������.');
                                Exit;
                            end
                            else
                            begin
                                ShowMessageFmt('�� �������� ���������� ������� �� ������ � "%f" �� "%f"',
                                [Planets[i].FIDist / 75, newVal]);
                                Planets[i].FFDist := newVal * 149600000000;
                                Planets[i].FIDist := newVal * 75;
                                Planets[i].FPoses[0].X := round(Planets[i].FPos.X + Planets[i].FIDist);
                                Planets[i].FPoses[0].Y := round(Planets[i].FPos.Y);
                                Planets[i].FVelocity := sqrt((Form1.G * Star.FMass) / Planets[i].FFDist);
                                Planets[i].FPeriod := (2 * pi * sqrt(power((2 * Planets[i].FFDist) / 2, 3) / (Form1.G * (Star.FMass + Planets[i].FMass)))) / (60 * 60 * 24 * 365);
                                UpdImageCol();
                            end;
                        end;
                    end
                    else if Trim(LowerCase(param)) = 'name' then
                    begin
                        if InputQuery('��������� ��������� �������', '������� ����� ��� �������:', newName) then
                        tempName := newName;
                        tempName := tempName.Replace(' ', '', [rfReplaceAll]);
                        if (tempName <> '') and (newName <> '') then
                        begin
                            ShowMessageFmt('�� �������� ��� �������: "%s" �� "%s"',
                            [Planets[i].FName, newName]);
                            Planets[i].FName := newName;
                        end
                        else
                        begin
                            ShowMessage('�� ����� �������� ���');
                            Exit;
                        end;
                    end
                    else if Trim(LowerCase(param)) = 'mass' then
                    begin
                        if InputQuery('��������� ��������� �������', '������� ����� �������� ����� ������� (� ������ �����):', val) then
                        begin
                            if TryStrToFloat(val, newVal) = False then
                            begin
                                ShowMessage('�� ����� ����������� �������.');
                                Exit;
                            end
                            else
                            begin
                                ShowMessageFmt('�� �������� ����� ������� � "%f" �� "%f"',
                                [Planets[i].FMass / (5.98 * power(10, 24)), newVal]);
                                Planets[i].FMass := newVal * 5.98 * power(10, 24);
                                Planets[i].FFRad := power(Planets[i].FMass * 3.0 / (4.0 * pi), 1.0 / 3.0);
                                Planets[i].FVelocity := sqrt((Form1.G * Star.FMass) / Planets[i].FFDist);
                                Planets[i].FPeriod := (2 * pi * sqrt(power((2 * Planets[i].FFDist) / 2, 3) / (Form1.G * (Star.FMass + Planets[i].FMass)))) / (60 * 60 * 24 * 365);
                            end;
                        end;
                    end
                    else
                    begin
                        ShowMessage('�� ����� �������� ��������.');
                        Exit;
                    end;
                end;
                UpdInfo();
            end
        end;
    end
    else
        ShowMessage('�� �������� ��������� ��������� �������.');
    if edited = False then
        ShowMessage('������� � ����� ������ �� ����������.');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    ShowMessage('����� ������� ������������� ��������� ����������� �������� �������!');
    G :=  6.6743e-11;
    DeltaTime := 60 * 60 * 24; // ������� ������� � ��������
    count_of_planets := 0;
    info_flag := False;
    Form2 := TForm2.Create(self);
    Form2.Hide;
end;

procedure TForm1.GravConstClick(Sender: TObject);
var
    getG: extended;
    temp: string;
    i: integer;
begin
    if InputQuery('��������� �������������� ����������', '������� ����� �������� �������������� ����������:', temp) then
    begin
        if (TryStrToFloat(temp, getG) = True) then
        begin
            if G > 0 then
            begin
                ShowMessageFmt('�� ����� ����� �������� �������������� ���������� ������ %f �� %f.',
                [G, getG]);
                G := getG;
                if (count_of_planets <> 0) and (Assigned(Star)) then
                    for i := 1 to count_of_planets do
                    begin
                        Planets[i].FVelocity := sqrt((Form1.G * Star.FMass) / Planets[i].FFDist);
                        Planets[i].FPeriod := (2 * pi * sqrt(power((2 * Planets[i].FFDist) / 2, 3) / (Form1.G * (Star.FMass + Planets[i].FMass)))) / (60 * 60 * 24 * 365);
                    end;
                UpdInfo();
            end
            else
            begin
                ShowMessage('�� ����� �������� �������� ���������.');
                Exit;
            end;
        end
        else
        begin
            ShowMessage('�� ����� �������� �������� ���������.');
            Exit;
        end;
    end;

end;


procedure TForm1.HelpClick(Sender: TObject);
begin
    HtmlHelp(Application.Handle, PChar(ExtractFilePath(Application.ExeName) + 'HelpPlSys.chm'), HH_DISPLAY_TOPIC, HelpContext);
end;


procedure TForm1.InfoSysClick(Sender: TObject); // ����� ���� � ����������� � �������
begin
    try
        UpdInfo();
        info_flag := True;
        Form2.Show;
    finally
        info_flag := False;
    end;
end;

procedure TForm1.orbitOffClick(Sender: TObject);
begin
    orbitOff.Enabled := False;
    orbitOn.Enabled := True;
end;

procedure TForm1.orbitOnClick(Sender: TObject);
begin
    orbitOff.Enabled := True;
    orbitOn.Enabled := False;
end;

procedure TForm1.PauseSysClick(Sender: TObject);
begin
    Timer1.Enabled := False;
    ContSys.Enabled := True;
    PauseSys.Enabled := False;
end;

procedure TForm1.Speed1Click(Sender: TObject);
begin
    Timer1.Interval := 50;
    Speed1.Enabled := False;
    Speed2.Enabled := True;
    Speed3.Enabled := True;
    Speed4.Enabled := True;
    Speed5.Enabled := True;
end;

procedure TForm1.Speed2Click(Sender: TObject);
begin
    Timer1.Interval := 40;
    Speed1.Enabled := True;
    Speed2.Enabled := False;
    Speed3.Enabled := True;
    Speed4.Enabled := True;
    Speed5.Enabled := True;
end;

procedure TForm1.Speed3Click(Sender: TObject);
begin
    Timer1.Interval := 30;
    Speed1.Enabled := True;
    Speed2.Enabled := True;
    Speed3.Enabled := False;
    Speed4.Enabled := True;
    Speed5.Enabled := True;
end;

procedure TForm1.Speed4Click(Sender: TObject);
begin
    Timer1.Interval := 20;
    Speed1.Enabled := True;
    Speed2.Enabled := True;
    Speed3.Enabled := True;
    Speed4.Enabled := False;
    Speed5.Enabled := True;
end;

procedure TForm1.Speed5Click(Sender: TObject);
begin
    Timer1.Interval := 10;
    Speed1.Enabled := True;
    Speed2.Enabled := True;
    Speed3.Enabled := True;
    Speed4.Enabled := True;
    Speed5.Enabled := False;
end;

procedure TForm1.StartSysClick(Sender: TObject);
begin
    Timer1.Enabled := True;
    PauseSys.Enabled := True;
    DefSys.Enabled := True;
    StartSys.Enabled := False;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
    i, j: integer;
    buffer: TBitmap;
begin
    Buffer := TBitmap.Create;
    Buffer.Width := Image1.Width;
    Buffer.Height := Image1.Height;
    Buffer.LoadFromFile('BackG.bmp');
    // ��������� ������� � �������� ������
    for i := 1 to count_of_planets do
    begin
        Planets[i].MovePl(DeltaTime, Planets[i]);
        Planets[i].CreatePic(Buffer.Canvas);
        if orbitOff.Enabled = True then
        begin
            Buffer.Canvas.MoveTo(Planets[i].FPoses[0].X, Planets[i].FPoses[0].Y);
            for j := 1 to High(Planets[i].FPoses) do
                Buffer.Canvas.LineTo(Planets[i].FPoses[j].X, Planets[i].FPoses[j].Y);
        end
        else
        begin
            Planets[i].FPoses[0] := Planets[i].FPoses[High(Planets[i].FPoses)];
            SetLength(Planets[i].FPoses, 1);
        end;
    end;
    if info_flag = True then
        UpdInfo();
    Star.CreatePic(Buffer.Canvas);
    Image1.Canvas.Draw(0, 0, Buffer);
    Buffer.Assign(nil);
end;

end.
