unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  System.Math,   // Для получения математических функций, используемых в вычислениях
  Vcl.Imaging.jpeg,
  Unit2;   // Для работы здесь со второй формой

// Описание класса звезды
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
            ro = 10000000; // Средняя плотность звезд
        constructor Create(Mass:double; Name: String; Color: TColor);  // Создание объекта - Звезда
        Procedure CreatePic(Field: TCanvas);
        property Mass: double read FMass;
        property Rad: double read FFRad;
        property Pos: TPoint read FPos;
        property Name: string read FName;
        property Color: TColor read FColor write FColor;

end;

// Описание класса планет
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
        constructor Create(Mass: double; Name: string; Color: TColor; Dist: Double);   // Создание объекта - планета
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

 // Описание класса формы
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
    count_of_planets: integer; // Счетчик планет
    info_flag: boolean; // Проверка на необходимость вывода характеристик
    DeltaTime: double; // Разница во времени
  public
    { Public declarations }
    G: extended; // Грав. константа
end;


var
  Form1: TForm1;
  Form2: TForm2; // Глобальная переменная для работы со второй формой здесь
  Star: TStar;  // Глобальная переменная звезды
  Planets: array [1..8] of TPlanet; // Глобальная переменная массива планет

implementation

{$R *.dfm}




constructor TStar.Create(Mass:double; Name: string; Color: TColor); // Конструктор звезды
begin
    FMass := Mass * 1.989 * power(10, 30);
    FFRad := power(FMass / ro * 3.0 / (4.0 * pi), 1.0 / 3.0);
    FPos := Point(Form1.Image1.Width div 2, Form1.Image1.Height div 2);
    FName := Name;
    FColor := Color;
    FIRad := 10;
end;


procedure TStar.CreatePic(Field: TCanvas);    // Метод отрисовки звезды
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




constructor TPlanet.Create(Mass: Double; Name: string; Color: TColor; Dist: Double);  // Конструктор планеты
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

 // Метод отрисовки планеты
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

 // Метод добавления в массив точек, где была планета
procedure TPlanet.AddNewPoint(cur_x, cur_y: integer);
begin
    SetLength(FPoses, Length(FPoses) + 1);
    FPoses[High(FPoses)] := Point(cur_x, cur_y);
end;

 // Метод рассчета скорости планеты
Function TPlanet.CalcVelocity(StarMass: Double; planet: TPlanet): double;
begin
    planet.FVelocity := sqrt((Form1.G * StarMass) / planet.FFDist);
    Result := planet.FVelocity;
end;

 // Метод рассчета периода планеты
Function TPlanet.CalcPeriod(planet: TPlanet): Double;
begin
    planet.FPeriod := (2 * pi * sqrt(power((2 * planet.FFDist) / 2, 3) / (Form1.G * (Star.FMass + planet.FMass)))) / (60 * 60 * 24 * 365);
    Result := planet.FPeriod;
end;

 // Метод рассчета движения планет
procedure TPlanet.MovePl(deltaT: double; pl: TPlanet);
begin
    // Рассчитываем новый угол и расстояние для планеты
    pl.FAngle := pl.FAngle + deltaT * 2 * pi / (pl.CalcPeriod(pl) * (24 * 60 * 60));

    // Вычисляем новые координаты планеты
    pl.AddNewPoint(round(FPos.X + pl.FIDist * Cos(pl.FAngle)), round(FPos.Y - pl.FIDist * Sin(pl.FAngle)));
end;


 // Процедура обновления информации во второй форме
procedure TForm1.UpdInfo();
var
    i, j, k: integer;
begin
    with Form2.StringGrid1 do
    begin
        Cells[3, 1] := FloatToStr(G);  // Запись гравитационной константы
        if Assigned(Star) then
        begin                          // Запись данных звезды
            Cells[0, 1] := Star.FName;
            Cells[1, 1] := FloatToStr(Star.FFRad / 1000);
            Cells[2, 1] := FloatToStr(Star.FMass / (1.989 * power(10, 30)));
        end;
        if count_of_planets <> 0 then  // Запись данных планет
        begin
            i := 4;
            for k := 1 to count_of_planets do
            begin
                if Assigned(Planets[k]) then
                begin
                    for j := 0 to ColCount - 1 do
                    begin
                    if (j = 0) then
                        Cells[j, i] := Planets[k].FName;   // Запись имени
                    if (j = 1) then
                        Cells[j, i] := FloatToStr(Planets[k].FFRad / 1000);  // Запись фактического радиуса
                    if (j = 2) then
                        Cells[j, i] := FloatToStr(Planets[k].FMass / (5.98 * power(10, 24)));  // Запись массы
                    if (j = 3) then
                        Cells[j, i] := FloatToStr(Planets[k].FIDist / 75);  //Запись расстояния
                    if (j = 4) then
                        Cells[j, i] := FloatToStr(Planets[k].FVelocity); // Запись скорости
                    if (j = 5) then
                        Cells[j, i] := FloatToStr(Planets[k].FPeriod);   // Запись периода
                    end;
                    if i <= RowCount - 1 then
                        i := i + 1;
                end;
            end;
        end;
    end;
end;

 // Процедура обновления канвы
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




 // Процедура добавления звезды в модель
procedure TForm1.AddAstClick(Sender: TObject);
var
    astName, colorName, m, tempName: string;
    astColor: TColor;
    astMass: Double;
    colorDialog: TColorDialog;
    i: integer;
begin
    // Создание экземпляра диалогового окна выбора цвета
    colorDialog := TColorDialog.Create(self);
    try
      // Разрешение на использование диалогового окна настройки цвета
      colorDialog.Options := colorDialog.Options + [cdFullOpen];
      // Задание начального цвета в диалоговом окне
      colorDialog.Color := clYellow;
      // Отображение диалогового окна и проверка результата
      if colorDialog.Execute then
          astColor := colorDialog.Color
      else
          Exit; // Отмена добавления
    finally
        colorDialog.Free;
    end;

    // Вызов диалогового окна ввода данных и сохранение результата - имя
    if InputQuery('Добавление звезды', 'Введите имя здвезды:', astName) then
    begin
        tempName := astName;
        tempName := tempName.Replace(' ', '', [rfReplaceAll]);
        if (tempName <> '') and (astName <> '') then
        begin
            // Вызов диалогового окна ввода данных и сохранение результата - масса
            if InputQuery('Добавление звезды', 'Введите массу звезды (в солнечных массах):', m) then
            begin
                if (TryStrToFloat(m, astMass) = False) then
                begin
                    ShowMessage('Вы ввели неверное значение массы.');
                    Exit
                end
                else
                begin
                    if astMass <= 0 then begin
                        ShowMessage('Вы ввели неверное значение массы.');
                        Exit;
                    end
                    else
                    begin
                        // Отображение сообщения с введенными данными планеты
                        colorName := ColorToString(astColor);
                        colorName := ColorName.Replace('cl', '');
                        ShowMessageFmt('Вы добавили звезду "%s" с массой "%f" с.м. и с цветом "%s"',
                        [astName, astMass, colorName]);

                        // Создание экземпляра класса планеты с указанными свойствами
                        // и добавление его изображения в центре формы
                        Star := TStar.Create(astMass, trim(astName), astColor);  // Создание объекта звезды
                        delAst.Enabled := True;     // Включение кнопки удаления звезды из модели
                        addAst.Enabled := False;    // Выключение кнопки добавления звезды из модели
                        editAst.Enabled := True;    // Вкл кнп изменения характеристик планеты
                        ColorAst.Enabled := True;   // Вкл кнп изменения цвета звезды
                        Star.CreatePic(Image1.Canvas);  // Отрисовка звезды на канве
                        if (Assigned(Star)) and (count_of_planets > 0) then
                        begin
                            StartSys.Enabled := True;    // Вкл кнопки для запуска симуляции, если существует звезда и хотя бы одна планета
                            editPl.Enabled := True;   // Вкл кнп изменения характеристик планет
                        end;
                        // Перерасчет скорости и периода планет
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
            ShowMessage('Вы не ввели имя звезды.');
            Exit;
        end;
    end;
end;

 // Процедура добавления планеты в модель
procedure TForm1.AddPlClick(Sender: TObject);
var
    plName, colorName, m, dist, tempName: string;
    plColor: TColor;
    plMass, plDistance: double;
    colorDialog: TColorDialog;
begin
// Создание экземпляра диалогового окна выбора цвета
    colorDialog := TColorDialog.Create(self);
    try
      // Разрешение на использование диалогового окна настройки цвета
      colorDialog.Options := colorDialog.Options + [cdFullOpen];
      // Задание начального цвета в диалоговом окне
      colorDialog.Color := clGreen;
      // Отображение диалогового окна и проверка результата
      if colorDialog.Execute then
          plColor := colorDialog.Color
      else
          Exit; // Отмена добавления
    finally
        colorDialog.Free;
    end;

    // Вызов диалогового окна ввода данных и сохранение результата - имя
    if InputQuery('Добавление планеты', 'Введите имя планеты:', plName) then
    begin
        tempName := plName;
        tempName := tempName.Replace(' ', '', [rfReplaceAll]);
        if (tempName <> '') and (plName <> '') then
        begin
        
            // Вызов диалогового окна ввода данных и сохранение результата - масса
            if InputQuery('Добавление планеты', 'Введите массу планеты (в земных массах):', m) then
            begin
                if (TryStrToFloat(m, plMass) = False) then   // Проверка на корректность массы
                begin
                    ShowMessage('Вы ввели неверное значение массы.');
                    Exit
                end
                else
                begin
                    if plMass <= 0 then begin
                        ShowMessage('Вы ввели неверное значение массы.');
                        Exit;
                    end
                    else
                    begin  // Диалоговое окно на получение расстояния от звезды до планетвы
                        if InputQuery('Добавление планеты', 'Введите расстояние планеты до звезды (в а.е.):', dist) then
                        begin
                            if (TryStrToFloat(dist, plDistance) = False) then   // Проверка па корректность
                            begin
                                ShowMessage('Вы ввели неверное значение расстояния.');
                                Exit
                            end
                            else
                            begin
                                // Отображение сообщения с введенными данными планеты
                                colorName := ColorToString(plColor);
                                colorName := ColorName.Replace('cl', '');
                                ShowMessageFmt('Вы добавили планету "%s" с массой "%f" з.м.,цветом "%s" и расстоянием "%f" а.е. до звезды.',
                                [plName, plMass, colorName, plDistance]);
                                // Создание экземпляра класса планеты с указанными свойствами
                                ColorPl.Enabled := True;  // Вкл кнп изменения цвета планет
                                count_of_planets := count_of_planets + 1; // Увелечение счетчика кол-ва планет
                                if count_of_planets > 0 then
                                    delPl.Enabled := True;   // Вкл кнопки удаления планеты
                                if count_of_planets = 8 then
                                    addPl.Enabled := False;  // Выкл кнп создания планет
                                Planets[count_of_planets] := TPlanet.Create(plMass, trim(plName), plColor, plDistance);  // Создание объекта планеты
                                Planets[count_of_planets].CreatePic(Image1.Canvas);  // Отрисовка планеты на канве
                                if (Assigned(Star)) and (count_of_planets > 0) then
                                begin
                                    StartSys.Enabled := True; // Вкл кнп запуска симуляции, если существует звезда и хотя бы одна планета
                                    editPl.Enabled := True;   // Вкл кнп изменения характеристик планет
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
            ShowMessage('Вы не ввели имя планеты.');
            Exit;
        end;
    end;
end;

 // Процедура изменения цвета звезды
procedure TForm1.colorAstClick(Sender: TObject);
var
    astColor: TColor;
    colorDialog: TColorDialog;
    tempName_new, tempName_prev: string;
begin
     colorDialog := TColorDialog.Create(self);
    try
        // Разрешение на использование диалогового окна настройки цвета
        colorDialog.Options := colorDialog.Options + [cdFullOpen];
        // Задание начального цвета в диалоговом окне
        colorDialog.Color := Star.FColor;
        // Отображение диалогового окна и проверка результата
        if colorDialog.Execute then
            astColor := colorDialog.Color
        else
            Exit; // Отмена изменения
    finally
        colorDialog.Free;  // Освобождения памяти от этого диалогого окна
    end;
    tempName_new := ColorToString(astColor);
    tempName_prev := ColorToString(Star.FColor);
    tempName_new := tempName_new.Replace('cl', '');
    TempName_prev := tempName_prev.Replace('cl', '');
    ShowMessageFmt('Вы изменили цвет звезды: %s изменен на %s',
    [tempName_prev, tempName_new]);
    Star.FColor := astColor; // Изменение цвета звезды
    UpdImageCol(); // Обновление канвы
    UpdInfo();
end;

 // Процедура изменения цвета планеты
procedure TForm1.colorPlClick(Sender: TObject);
var
    i: integer;
    plColor: TColor;
    colorDialog: TColorDialog;
    tempName_new, tempName_prev, planetName: string;
    Edited: boolean;
begin                         // Получение имени планеты, которую нужно изменить
    Edited := True;
    if InputQuery('Изменение цвета планеты', 'Введите имя планеты:', planetName) then
    begin
        Edited := False;
        for i := 1 to count_of_planets do
        begin             // Проверка, совпадает ли имя с какой-либо из планет
            if LowerCase(Trim(planetName)) = LowerCase(Trim(Planets[i].FName)) then
            begin
                Edited := True;
                colorDialog := TColorDialog.Create(self);
                try
                    // Разрешение на использование диалогового окна настройки цвета
                    colorDialog.Options := colorDialog.Options + [cdFullOpen];
                    // Задание начального цвета в диалоговом окне
                    colorDialog.Color := Planets[i].FColor;
                    // Отображение диалогового окна и проверка результата
                    if colorDialog.Execute then
                    begin
                        plColor := colorDialog.Color

                    end
                    else
                        Exit; // Отмена изменения
                finally
                    colorDialog.Free;
                end;
                tempName_new := ColorToString(plColor);
                tempName_prev := ColorToString(Planets[i].FColor);
                tempName_new := tempName_new.Replace('cl', '');
                TempName_prev := tempName_prev.Replace('cl', '');
                ShowMessageFmt('Вы изменили цвет планеты "%s": %s изменен на %s',
                [planetName, tempName_prev, tempName_new]);
                Planets[i].Color := plColor; // Изменение цвета выбранной планеты
                UpdImageCol();  // Обновление канвы    \
                UpdInfo();
            end;
        end;
    end
    else
        ShowMessage('Вы отменили изменение цвета планеты.');
    if Edited = False then
        ShowMessage('Планеты с таким именем не существует.');
end;

 // Процедура запуска модели заново
procedure TForm1.ContSysClick(Sender: TObject);
begin
    Timer1.Enabled := True;  // Включение таймера
    ContSys.Enabled := False;  // Выкл кнп этой процедуры
    PauseSys.Enabled := True;  // Вкл кнп для остановки системы
end;

// Процедура сброса системы к изначальному виду
procedure TForm1.DefSysClick(Sender: TObject);
var
buffer_init: TBitmap;
i: integer;
begin
    PauseSys.Enabled := False; // Выкл кнп паузы системы
    if (Assigned(Star)) and (count_of_planets <> 0) then
        StartSys.Enabled := True;  // Вкл кнп запуска системы
    ContSys.Enabled := False;  // Выкл кнп продолжения работы сим
    DefSys.Enabled := False;   // Выкл кнп сброса системы к изначальному виду
    Timer1.Enabled := False;   // Выкл таймера
    buffer_init := TBitmap.Create;  // Создание объекта изображения, где будет отрисовываться изначальный вид системы
    buffer_init.Width := Image1.Width; // Копирование ширины с объекта, где будет находится модель
    buffer_init.Height := Image1.Height; // Копирование высоты с объекта, где будет находится модель
    buffer_init.LoadFromFile('BackG.bmp'); // Загрузка на буфер фона
    if Assigned(Star) then
        Star.CreatePic(buffer_init.Canvas); // Отрисовка звезды
    G :=  6.6743e-11; // Задание стандартного значения гравитационной постоянной
    if count_of_planets <> 0 then  // Отрисовка планет
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
    Image1.Canvas.Draw(0, 0, buffer_init);  // Перерисовка на основной объект
    buffer_init.Free; // Освобождение памяти от объекта
    UpdInfo();
end;

 // Процедура удаления звезды
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
    ShowMessage('Вы успешно удалили звезду.');
    UpdInfo();
end;

procedure TForm1.DelPlClick(Sender: TObject);
var
    deleted: boolean;
    planetName: string;
    i, mem, j: integer;
begin
    deleted := True;
    if InputQuery('Удаление планеты', 'Введите имя планеты:', planetName) then
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
                ShowMessageFmt('Вы успешно удалили планету с именем "%s".', [planetName]);
            end;
        end;
    end
    else
        ShowMessage('Вы отменили удаление планеты.');
    if Deleted = False then
        ShowMessage('Планеты с таким именем не существует.');
end;

procedure TForm1.EditAstClick(Sender: TObject);
var
    tempName, param, newName, val: string;
    newVal: double;
    i: integer;
begin
    if InputQuery('Изменение параметра звезды', 'Какой параметр необходимо изменить?([mass], [name]):', param) then
    begin
        param := param.Replace('[', '', [rfReplaceAll]);
        param := param.Replace(']', '', [rfReplaceAll]);
        if Trim(LowerCase(param)) = 'name' then
        begin
            if InputQuery('Изменение параметра звезды', 'Введите новое имя звезды:', newName) then
            tempName := newName;
            tempName := tempName.Replace(' ', '', [rfReplaceAll]);
            if (tempName <> '') and (newName <> '') then
            begin
                ShowMessageFmt('Вы поменяли имя звезды: "%s" на "%s"',
                [Star.FName, newName]);
                Star.FName := newName;
            end
            else
            begin
                ShowMessage('Вы ввели неверное имя');
                Exit;
            end;
        end
        else if Trim(LowerCase(param)) = 'mass' then
        begin
            if InputQuery('Изменение параметра звезды', 'Введите новое значение массы звезды:', val) then
            begin
                if TryStrToFloat(val, newVal) = False then
                begin
                    ShowMessage('Вы ввели некорректое значние.');
                    Exit;
                end
                else
                begin
                    ShowMessageFmt('Вы поменяли массу звезды с "%f" на "%f"',
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
            ShowMessage('Вы ввели неверный параметр.');
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
    if InputQuery('Изменение параметра планеты', 'Введите имя планеты:', planetName) then
    begin
        edited := False;
        for i := 1 to count_of_planets do
        begin
            if LowerCase(Trim(planetName)) = LowerCase(Trim(Planets[i].FName)) then
            begin
                edited := True;
                if InputQuery('Изменение параметра планеты', 'Какой параметр необходимо изменить?([dist], [mass], [name]):', param) then
                begin
                    param := param.Replace('[', '', [rfReplaceAll]);
                    param := param.Replace(']', '', [rfReplaceAll]);
                    if Trim(LowerCase(param)) = 'dist' then
                    begin
                        if InputQuery('Изменение параметра планеты', 'Введите новое значение расстояния до звезды:', val) then
                        begin
                            if TryStrToFloat(val, newVal) = False then
                            begin
                                ShowMessage('Вы ввели некорректое значние.');
                                Exit;
                            end
                            else
                            begin
                                ShowMessageFmt('Вы поменяли расстояние планеты до звезды с "%f" на "%f"',
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
                        if InputQuery('Изменение параметра планеты', 'Введите новое имя планеты:', newName) then
                        tempName := newName;
                        tempName := tempName.Replace(' ', '', [rfReplaceAll]);
                        if (tempName <> '') and (newName <> '') then
                        begin
                            ShowMessageFmt('Вы поменяли имя планеты: "%s" на "%s"',
                            [Planets[i].FName, newName]);
                            Planets[i].FName := newName;
                        end
                        else
                        begin
                            ShowMessage('Вы ввели неверное имя');
                            Exit;
                        end;
                    end
                    else if Trim(LowerCase(param)) = 'mass' then
                    begin
                        if InputQuery('Изменение параметра планеты', 'Введите новое значение массы планеты (в земной массе):', val) then
                        begin
                            if TryStrToFloat(val, newVal) = False then
                            begin
                                ShowMessage('Вы ввели некорректое значние.');
                                Exit;
                            end
                            else
                            begin
                                ShowMessageFmt('Вы поменяли массу планеты с "%f" на "%f"',
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
                        ShowMessage('Вы ввели неверный параметр.');
                        Exit;
                    end;
                end;
                UpdInfo();
            end
        end;
    end
    else
        ShowMessage('Вы отменили изменение параметра планеты.');
    if edited = False then
        ShowMessage('Планеты с таким именем не существует.');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    ShowMessage('Перед началом использования программы обязательно прочтите справку!');
    G :=  6.6743e-11;
    DeltaTime := 60 * 60 * 24; // разница времени в секундах
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
    if InputQuery('Изменение гравитационной постоянной', 'Введите новое значение гравитационной постоянной:', temp) then
    begin
        if (TryStrToFloat(temp, getG) = True) then
        begin
            if G > 0 then
            begin
                ShowMessageFmt('Вы ввели новое значение гравитационной постоянной вместо %f на %f.',
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
                ShowMessage('Вы ввели неверное значение константы.');
                Exit;
            end;
        end
        else
        begin
            ShowMessage('Вы ввели неверное значение константы.');
            Exit;
        end;
    end;

end;


procedure TForm1.HelpClick(Sender: TObject);
begin
    HtmlHelp(Application.Handle, PChar(ExtractFilePath(Application.ExeName) + 'HelpPlSys.chm'), HH_DISPLAY_TOPIC, HelpContext);
end;


procedure TForm1.InfoSysClick(Sender: TObject); // Вызов окна с информацией о системе
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
    // обновляем позиции и скорости планет
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
