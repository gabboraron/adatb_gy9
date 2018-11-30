insert into dolgozo (dkod, dnev, belepes, fizetes, oazon)
    VALUES (1,'Kovacs', SYSDATE, (Select avg (fizetes) from dolgozo where oazon=10), 10);
    
select * from dolgozo;

update dolgozo set fizetes=fizetes*1.2
    where oazon = 20;
    
delete from dolgozo where dkod = 1;


/* ***** */


create or replace function osszeg(kifejezes VARCHAR2) return int is 
    tmp VARCHAR2(10) := '';
    eredmeny int := 0;
begin
    for i in 1..length(kifejezes) loop
        if (SUBSTR(kifejezes, i, 1) = '+') then
            eredmeny := eredmeny + TO_NUMBER(tmp);
            tmp := '';
        else
            tmp := tmp || SUBSTR(kifejezes, i, 1);
        end if;
    end loop;
    eredmeny := eredmeny + TO_NUMBER(tmp);
    return eredmeny;
end osszeg;



/****** */
ACCEPT valtozonev CHAR PROMPT 'Add meg a valtozo erteket';

select * from dolgozo where dnev = '&valtozonev';
 
 /* *** */
 
CREATE OR REPLACE FUNCTION kat_atlag(n integer) RETURN number IS
    cursor curs1 is select * from dolgozo
                    join fiz_kategoria on fizetes between also and felso
                    where kategoria = n;
    rec curs1%ROWTYPE;
    osszeg int := 0;
    db int := 0;
begin    
    for rec in curs1 loop
        osszeg := osszeg + rec.fizetes;
        db := db +1;
    end loop;
    return osszeg/db;
end kat_atlag;    

select kat_atlag(4) from dual;

/* *** */
select * from dolgozo ORDER BY dnev;

CREATE OR REPLACE PROCEDURE proc9 IS
    cursor curs1 is select * from dolgozo ORDER BY dnev;
    rec curs1%ROWTYPE;
    idx int := 1;
begin
    for rec in curs1 loop
        if(mod(idx, 2) = 0) then
            DBMS_OUTPUT.PUT_LINE(rec.dnev || ' - ' || rec.fizetes);
        end if;
        idx := idx +1;
    end loop;
end proc9;


-- Tesztelés:
set serveroutput on
call proc9();



/* *** */
CREATE OR REPLACE PROCEDURE procNevsor IS
    cursor curs1 is select * from dolgozo ORDER BY dnev;
    rec curs1%ROWTYPE;
    fiz int := 0;
begin
    for rec in curs1 loop
        if(rec.fizetes>fiz) then
            DBMS_OUTPUT.PUT_LINE(rec.dnev);
        end if;
        fiz:=rec.fizetes;
    end loop;
end procNevsor;
--Tesztelés:
set serveroutput on
call procNevsor();


/* **** */

select * from osztaly;
select * from dolgozo;

select * from dolgozo natural join osztaly;

ACCEPT kezdobetu CHAR PROMPT 'Add meg az osztály kezdõbetût';
DECLARE
    cursor curs1 is select * from dolgozo natural join osztaly
                    where onev like '&kezdobetu%';
    rtec curs1%ROWTYPE;                    
    cursor curs2 is select * from dolgozo natural join osztaly
                    where onev like '&kezdobetu%';
    rtec curs2%ROWTYPE;
    db int := 0;
BEGIN
    for rec in  curs2 loop
        db := db +1;
    end loop;
    for rec in  curs1 loop
        dbms_output.put_line(rec.dnev || ' - ' || rec.belepes);
    end loop;
    if db = 0 then
        dbms_output.put_line('nincs ilyen osztaly');
    end if;
    
END;

