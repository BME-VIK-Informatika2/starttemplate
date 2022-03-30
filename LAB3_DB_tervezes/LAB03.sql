-- Stefán Erik Ede
-- 2022.03.30
-- INFO2_3.labor

-- 5.,
insert into Termek("idTermek","Nev","Keszlet")
values(1, "Tegla", 500);
insert into Vevo("idVevo", "Nev")
values(1, "Erik");
insert into Telephely("idTelephely", "Vevo_idVevo")
values(1, 1);
insert into Megrendeles("Termek_idTermek", "Telephely_idTelephely", "MennyiTermek")
values(1, 1, 40);

-- 6.,
update Megrendeles 
set MennyiTermek = 50
where MennyiTermek = 40;

-- 7.,
select*
from Termek
where Keszlet > 200;

-- 9.,
insert into Targy("idTargy", "Kod", "Nev")
values(1, "BMEVIAUAB01", "Informatika 2");
insert into Diak("Nev", "idDiak")
values("Erik", 1);
update Targy
set Diak_idDiak = 1
where Nev = "Erik";

-- 10.,
update Targy
set Nev = "Info2"
where Nev = "Informatika 2";

-- 11.,
select*
from Oktato
where Nev is not null;

-- 12.,
select*
from Oktato
where Nev like 'V%';

-- 13.,
update Targy
set Dika_idDiak = 0
where Nev = "Erik";

-- 14.,
select*
from Targy
where Leiras is null;
