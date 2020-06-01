unit punto3V3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

Const
LONGITUDMET=20;
type
  TForm1 = class(TForm)
    CargaArchivo: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    ABM: TGroupBox;
    ArchivoNuevo: TGroupBox;
    Label2: TLabel;
    Edit2: TEdit;
    Principal: TGroupBox;
    Label3: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button12: TButton;
    Button13: TButton;
    Button10: TButton;
    Button11: TButton;
    StringGrid1: TStringGrid;
    mostrar_grilla: TGroupBox;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  bdt:TextFile;
  archivo,direccion,ccs:string;
  cc,ver:integer;
  nom_met: array of string;
  lon_met:array of integer;
implementation

{$R *.dfm}


function suma_valores():integer;
var
i,suma:integer;
begin
suma:=0;
for i:=0 to cc-1 do
    suma:= suma + lon_met[i];
suma_valores:=suma;
end;

function posicionar(posicion:integer):integer;
var
inicio_datos,a:integer;
begin
  inicio_datos:=(cc*(LONGITUDMET+2))+2;
  a:= inicio_datos + ((posicion-1)*suma_valores) + (posicion-1);
  posicionar:=a;
end;



function completar_espacios(nombre_a_completar:string; valor:integer):string;    //relleno espacios
var
j:integer;
begin
  if (length(nombre_a_completar) < valor) then
          begin
            for j:= 1 to (valor-(length(nombre_a_completar))) do
              begin
                nombre_a_completar:= nombre_a_completar + ' ';
              end;
          end;
  if(length(nombre_a_completar)>valor) then
    ShowMessage('Atención, se va a acortar el texto ingresado');
  completar_espacios:=copy(nombre_a_completar,1,valor);
end;

procedure leer_metadata();
var
i,j,longitud,nombre:integer;
lon,nom:string;
begin
longitud:=LONGITUDMET+2;
nombre:=2;
cc:=strtoint(archivo[1]);
setlength(nom_met,cc);
setlength(lon_met,cc);
  for i:=0 to cc-1 do
    begin
      if (archivo[i+longitud] = ' ') then
          lon_met[i]:=strtoint(archivo[i+longitud+1])
      else
        begin
          lon:=archivo[i+longitud] + archivo[i+longitud+1];
          lon_met[i]:=strtoint(lon);
        end;
      longitud:=longitud+(LONGITUDMET+1);
        for j:=i+nombre to (i+nombre+(LONGITUDMET-1)) do
          begin
            nom:=nom + archivo[j];
          end;
        nombre:=nombre+LONGITUDMET+1;
        nom_met[i]:=nom;
        nom:='';
    end;
end;

function cantidad_registros():integer;
begin
leer_metadata;
cantidad_registros:=trunc((length(archivo))-(posicionar(1)-1)/suma_valores);
end;

procedure menu_opcion1();
var
i:integer;
nombre_campo,tamanio_campo:string;
begin
  ccs:=form1.Edit2.text;
  cc:=strtoint(ccs);
  setlength(nom_met,cc);
  setlength(lon_met,cc);
  archivo:=archivo + ccs;
      for i:=0 to cc-1 do
        begin
          nombre_campo:=InputBox('Carga metadata','Ingrese nombre del campo','');
          archivo:=archivo + completar_espacios(nombre_campo,LONGITUDMET);
          nom_met[i]:=nombre_campo;
          tamanio_campo:=InputBox('Carga metadata','Ingrese longitud del campo','');
            if (length(tamanio_campo) < 2) then
              begin
                tamanio_campo:= ' ' + tamanio_campo;
              end;
          lon_met[i]:=strtoint(tamanio_campo);
          archivo:=archivo + tamanio_campo;
        end;
ShowMessage('¡Metadata cargada!');
form1.Button2.Enabled:=false;
form1.ArchivoNuevo.Visible:=false;
form1.Principal.Visible:=true;
end;

procedure alta();
var
j:integer;
begin
leer_metadata;
  archivo:=archivo + '1';
  for j:=0 to cc-1 do
      archivo:=(archivo + completar_espacios(InputBox('Alta', nom_met[j], ''),lon_met[j]));
  ShowMessage('¡Cargado con éxito!');
end;

procedure baja();
var
baja:integer;
begin
leer_metadata;
  baja:=StrToInt(InputBox('Baja','¿Qué registro desea borrar?',''));
  if (archivo[posicionar(baja)] = '1') then
    begin
      archivo[posicionar(baja)]:='0';
      ShowMessage('El registro ' + inttostr(baja) + ' dado de baja');
    end
  else
    ShowMessage('No existe el registro');
end;

procedure modificar();
var
modificar,j,i:integer;
modifico:string;
begin
leer_metadata;
modifico:='';
  modificar:=StrToInt(InputBox('Modificar','¿Qué registro desea modificar?',''));
  if (archivo[posicionar(modificar)] = '1') then
    begin
      for i:=0 to cc-1 do
          modifico:=modifico + completar_espacios(InputBox('Modificar', nom_met[i], ''),lon_met[i]);
      for j:=1 to length(modifico) do
          archivo[posicionar(modificar)+j]:=modifico[j];
      ShowMessage('El registro '+ inttostr(modificar) + ' fue modificado');
    end
  else
    ShowMessage('No existe el registro');
end;

procedure limpiar_tabla();
var
i,j:integer;
begin
  with Form1.StringGrid1 do
    begin
      for i:=0 to ColCount do
        for j:=0 to RowCount do
          cells[i,j]:='';
    end;
end;

procedure creo_tabla(registro:integer);
var
i,j,posicion:integer;
escribo:string;
begin
leer_metadata;
posicion:=posicionar(registro);
for i:=0 to cc-1 do
  begin
    escribo:='';
    with Form1.StringGrid1 do
      begin
        ColCount:=cc+1;
        RowCount:=registro+1;
        cells[0,0]:='Registro';
        cells[(i+1),0]:=nom_met[i];
        FixedRows:=1;
        FixedCols:=0;
        ShowScrollBar(Handle, SB_VERT, True);
        ShowScrollBar(handle,SB_HORZ,True);
          for j:=(posicion+1) to (posicion+lon_met[i]-1) do
              escribo:= escribo + archivo[j];
        cells[0,registro]:=inttostr(registro);
        cells[i+1,registro]:=escribo;
        posicion:=posicion+lon_met[i];
      end;
  end;

end;

procedure mostrar(ver: integer);
begin
leer_metadata;
if (posicionar(ver) < length(archivo)) then
  begin
    if (archivo[posicionar(ver)] = '1') then
      begin
        creo_tabla(ver);
      end;
  end;
end;

procedure mostrar_todos();
var
i:integer;
begin
  for i:=1 to cantidad_registros do
    mostrar(i);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
        direccion:=Form1.Edit1.Text;
        CargaArchivo.Visible:=false;
        principal.Visible:=true;
        AssignFile(bdt, direccion);
          {$I-} reset(bdt); {$I+}
              if ioresult <> 0 then
                begin
                  rewrite(bdt); //Preg si existe sino crearlo
                end
              else
                  readln(bdt, archivo);
        closeFile(bdt);
        if (length(archivo)<1) then
          begin
            form1.button3.Enabled:=false;
            form1.Button10.Enabled:=false;
            form1.Button11.Enabled:=false;
            form1.Button2.Enabled:=true;
          end
        else
          form1.Button2.Enabled:=false;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  CargaArchivo.Visible:=true;
  ArchivoNuevo.Visible:=false;
  Principal.Visible:=false;
  ABM.Visible:=false;
  mostrar_grilla.Visible:=false;
  button1.Enabled:=false;
  form1.AutoSize:=false;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
menu_opcion1();
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
abm.Visible:=true;
principal.Visible:=false;
end;


procedure TForm1.Button7Click(Sender: TObject);
begin
alta;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
ArchivoNuevo.Visible:=true;
Principal.Visible:=false;
form1.button3.Enabled:=true;
form1.Button10.Enabled:=true;
form1.Button11.Enabled:=true;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
rewrite(bdt);
write(bdt,archivo);
closeFile(bdt);
Close;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
baja;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
modificar;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
mostrar(strtoint(InputBox('Mostrar','¿Que registro desea ver?','')));
mostrar_grilla.Visible:=true;
Principal.Visible:=false;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
mostrar_todos;
Principal.Visible:=false;
mostrar_grilla.Visible:=true;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
mostrar_grilla.Visible:=false;
Principal.Visible:=true;
limpiar_tabla;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
abm.Visible:=false;
Principal.Visible:=true;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
ShowMessage('No se guardará ningún cambio');
close;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
rewrite(bdt);
write(bdt,archivo);
closeFile(bdt);
close;
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
rewrite(bdt);
write(bdt,archivo);
closeFile(bdt);
reset(bdt);
readln(bdt,archivo);
closeFile(bdt);
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
rewrite(bdt);
write(bdt,archivo);
closeFile(bdt);
reset(bdt);
readln(bdt,archivo);
closeFile(bdt);
end;

procedure TForm1.Button18Click(Sender: TObject);
var
  selectedFile: string;
  dlg: TOpenDialog;
begin
  selectedFile := '';
  dlg := TOpenDialog.Create(nil);
  try
    dlg.InitialDir := 'C:\';
    dlg.Filter := 'All files (*.*)|*.*';
    if dlg.Execute() then
      selectedFile := dlg.FileName;
  finally
    dlg.Free;
  end;

  if selectedFile <> '' then
    form1.Edit1.Text:=selectedFile;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  if edit1.Text = '' then
    form1.Button1.Enabled:=false
  else
    form1.Button1.Enabled:=true;
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
ShowMessage('No se guardará ningún cambio');
close;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
ShowMessage('No se guardará ningún cambio');
close;
end;



end.
