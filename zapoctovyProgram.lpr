program zapoctovyProgram;
var
  index, vstup : Text;
  slovo : string;
  znak : char;
  bolDiv, specDiv, bolaBodkociarka, priznakBodkociarkyPredKomentarom, zatvorkovyKomentar, mnozinovyKomentar, otvaraciaZatvorka, zatvaraciaHviezdicka, retazec : boolean;
procedure zapisZaciatokHTML;
begin
  writeln(index, '<html>');
  writeln(index, '<head>');
  writeln(index, '<link rel="stylesheet" href="styles.css">');
  writeln(index, '</head>');
  writeln(index, '<body>');
  writeln(index, '<code>');
end;
procedure zapisKoniecHTML;
begin
  writeln(index, '</code>');
  writeln(index, '</body>');
  writeln(index, '</html>');
end;
procedure pridajZnakSlovu;
begin
  if slovo = '' then slovo := znak
                else slovo := slovo + znak;
end;
procedure zapisEnter;
begin
  if specDiv then
        begin
          write(index, '<div class="posun">');
          specDiv := false;
        end;
  if not bolDiv then write(index, '<br>', chr(10))
                else bolDiv := false;
end;
procedure vypisSlovo;
begin
  if mnozinovyKomentar or zatvorkovyKomentar or retazec then write(index, slovo)
  else
    begin
      if slovo <> '' then
      case slovo of
{znacenie podpogramov}
        'begin'
               : begin
                    write(index, '<output class="system">', slovo,'</output>', '<div class ="posun">');
                    bolDiv := true;
                    bolaBodkociarka := true;
                  end;
        'end', 'end.'
               : begin
                  write(index, '</div>', '<output class="system">', slovo, '</output>');
                  bolDiv := false;
                end;
{operatory}
        'mod', 'div', 'shl', 'shr'
               : write(index, '<output class="znamienko">', slovo, '</output>');

{casto pouzivane funkcie}
        'write', 'writeln', 'read', 'readln', 'new', 'dispose', 'ord', 'chr'
               : write(index, '<output class="funkcie">', slovo, '</output>');

{vetvenie}
        'if', 'then', 'not', 'and', 'or', 'else', 'xor'
               : write(index, '<output class="podmienka">', slovo, '</output>');

        'case'
               : begin
                   write(index, '<output class="podmienka">', slovo,'</output>');
                   specDiv := true;
                   bolDiv := true;
               end;
{cykly}
        'repeat'
               : begin
                 write(index, '<output class="cyklus">', slovo,'</output>', '<div class="posun">');
                 bolDiv := true;
                 bolaBodkociarka := true;
               end;
        'until'
               : begin
                 write(index, '</div>', '<output class="cyklus">', slovo, '</output>');
                 bolDiv := false;
               end;

        'while', 'for', 'to', 'downto', 'do', 'break', 'continue', 'goto'
               :  begin
                  write(index,'<output class="cyklus">',  slovo,'</output>');
               end;

{znacenie programov a podprogramov v programe}
        'procedure', 'function', 'program'
               : write(index, '<output class="system">', slovo, '</output>');

{deklaracia alebo datova struktura}
        'var', 'const', 'type', 'record', 'array', 'set', 'file'
               : write(index, '<output class="spec">', slovo, '</output>');

{typy premennych}
        'integer', 'cardinal', 'shortint', 'smallint', 'longint', 'int64', 'byte', 'word', 'longword',
        'real', 'single', 'double',  'extended', 'comp', 'currency',
        'boolean', 'bytebool', 'wordbool', 'longbool',
        'char', 'character', 'string', 'widechar', 'shortstring', 'ansistring', 'widestring'
               : write(index,'<output class="premenna">',  slovo, '</output>');
{hodnoty T/F, nil, NIL}
        'TRUE', 'True', 'true', 'FALSE', 'False', 'false', 'NIL', 'nil'
               : write(index, '<output class="hodnotaTF">', slovo, '</output>');
{ine slova}
        else write(index, '<output>', slovo, '</output>');
      end;
    end;
  slovo := '';
end;
procedure posudLF;
begin
  zapisEnter;
  if bolaBodkociarka then bolaBodkociarka := false;
end;
procedure zapisRetazec;
begin
  if not retazec then
    begin
      if zatvorkovyKomentar or mnozinovyKomentar then write(index, chr(39))
      else
        begin
          write(index, '<output class="retazec">', chr(39));
          retazec := true;
        end
    end
  else
    begin
      write(index, chr(39), '</output>');
      retazec := false;
    end;
end;
procedure zaciatokMnozinovehoKomentaru;
begin
  if not retazec then
    if zatvorkovyKomentar = false then
      if mnozinovyKomentar = false then
        begin
          mnozinovyKomentar := true;
          if zatvorkovyKomentar = false then write(index, '<output class="komentar">');
        end;
  write(index, '{');
end;
procedure koniecMnozinovehoKomentaru;
begin
  write(index, '}');
  if not retazec then
    if zatvorkovyKomentar = false then
        if mnozinovyKomentar = true then
          begin
            mnozinovyKomentar := false;
            write(index, '</output>');
          end;
end;

procedure posudOtvaraciuZatvorku;
begin
  if retazec or mnozinovyKomentar or zatvorkovyKomentar then write(index, '(');
  if not retazec and not mnozinovyKomentar and not zatvorkovyKomentar then otvaraciaZatvorka := true;

  {if retazec then write(index, '(')
  else if mnozinovyKomentar = true then write(index, '(')
       else if zatvorkovyKomentar = true then write(index, '(')
            else otvaraciaZatvorka := true;}
end;
procedure zaznacZnamienko;
begin
  if mnozinovyKomentar or zatvorkovyKomentar or retazec then write(index, znak)
  else write(index, '<output class="znamienko">', znak, '</output>');
end;
procedure posudHviezdicku;
begin
  if not retazec then
    if mnozinovyKomentar = false then
      if zatvorkovyKomentar = false then
        if otvaraciaZatvorka = true then
          begin
            write(index, '<output class="komentar">', '(', '*');
            zatvorkovyKomentar := true;
            otvaraciaZatvorka := false;
          end
        else
          begin
            zatvaraciaHviezdicka := true;
            zaznacZnamienko;
          end
      else
        begin
          zatvaraciaHviezdicka := true;
          write(index, '*');
        end
    else write(index, '*')
  else write(index, '*');
end;
procedure posudZatvaraciuZatvorku;
begin
  if not retazec and not mnozinovyKomentar and not zatvorkovyKomentar then zaznacZnamienko
  else
    begin
      write(index, ')');
      if zatvaraciaHviezdicka then
        begin
          write(index,'</output>');
          zatvorkovyKomentar := false;
          zatvaraciaHviezdicka := false;
        end;
    end;
end;
procedure posudBodkociarku;
begin
  if mnozinovyKomentar or zatvorkovyKomentar or retazec then write(index, znak)
  else
    begin
      bolaBodkociarka := true;
      zaznacZnamienko;
    end
end;


begin
  assign(index, 'index.html');
  rewrite(index);
  assign(vstup, 'vstup.txt');
  reset(vstup);
  mnozinovyKomentar := false;
  zatvorkovyKomentar := false;
  retazec := false;
  otvaraciaZatvorka := false;
  zatvaraciaHviezdicka := false;

  zapisZaciatokHTML;

  read(vstup, znak);

  while not seekEOF(vstup) do
    begin
      if (otvaraciaZatvorka = true) and (znak <> '*') then
        begin
          otvaraciaZatvorka := false;
          write(index, '<output class="znamienko">' + '(' + '</output>');
        end;

      if zatvaraciaHviezdicka and (znak <> ')') then zatvaraciaHviezdicka := false;

      if not (ord(znak) in [46, 65..90, 94, 95, 97..122]) then vypisSlovo;


      case ord(znak) of
        {znak znaci koniec riadku }
        13: posudLF;

        {znak je ' ' }
        32: write(index, ' ');

        {znak je ' }
        39: zapisRetazec;

        {znak je '(' }
        40:
          begin
            posudOtvaraciuZatvorku;
            if bolaBodkociarka then
            begin
              bolaBodkociarka := false;
              priznakBodkociarkyPredKomentarom := true;
            end
          end;

        {znak je ')' }
        41:
        begin
          posudZatvaraciuZatvorku;
          if priznakBodkociarkyPredKomentarom and not (mnozinovyKomentar or zatvorkovyKomentar) then
            begin
              bolaBodkociarka := true;
              priznakBodkociarkyPredKomentarom := false;
            end;
        end;

        {znak je '*' }
        42: posudHviezdicku;

        {znak je jedno zo znamienok + , - / : < = > [ ] ` }
        43..45, 47, 58, 60..62, 91, 93, 96 :
        begin
          if bolaBodkociarka then
            begin
              zapisEnter;
              bolaBodkociarka := false;
            end;
          zaznacZnamienko;
        end;

        {znak je ';'}
        59: posudBodkociarku;

        {znak je . ^ _ alebo jedno z malych alebo VELKYCH pismen }
        46, 65..90, 94, 95, 97..122 :
        if bolaBodkociarka then
            begin
              zapisEnter;
              pridajZnakSlovu;
              bolaBodkociarka := false;
            end
          else pridajZnakSlovu;

        {znak je otvaracia mnozinova zatvorka}
        123:
        begin
          zaciatokMnozinovehoKomentaru;
          if bolaBodkociarka then
            begin
              bolaBodkociarka := false;
              priznakBodkociarkyPredKomentarom := true;
            end;
        end;

        {znak je zatvaracia mnozinova zatvorka }
        125:
        begin
          koniecMnozinovehoKomentaru;
          if priznakBodkociarkyPredKomentarom and not (mnozinovyKomentar or zatvorkovyKomentar) then
            begin
              bolaBodkociarka := true;
              priznakBodkociarkyPredKomentarom := false;
            end;
        end

        else if bolaBodkociarka then
            begin
              zapisEnter;
              write(index, znak);
              bolaBodkociarka := false;
            end
          {znak je z ascii tabulky a nie je to znak z pripadov popisanych vyssie}
          else write(index, znak);
      end;
      read(vstup, znak);
    end;

  pridajZnakSlovu;
  vypisSlovo; {vypisanie posledneho slova}

  zapisKoniecHTML;

  close(index);
  close(vstup);
end.
