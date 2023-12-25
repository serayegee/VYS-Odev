CREATE TABLE film ();
CREATE TABLE filmFormati ();
CREATE TABLE oyuncu ();
CREATE TABLE yonetmen ();
CREATE TABLE gosterimBilgileri ();

ALTER TABLE film ADD COLUMN filmID INT PRIMARY KEY;
ALTER TABLE film ADD COLUMN sure INT;
ALTER TABLE film ADD COLUMN filmAdi VARCHAR(255); 
ALTER TABLE film ADD COLUMN filmFormatID INT;
ALTER TABLE film ADD COLUMN oyuncuid INT;
ALTER TABLE film ADD COLUMN yonetmenid INT;
ALTER TABLE film ADD COLUMN gosterimBilgileri VARCHAR;

ALTER TABLE oyuncu ADD COLUMN oyuncuID INT PRIMARY KEY;
ALTER TABLE oyuncu ADD COLUMN oyuncuAdi VARCHAR;

ALTER TABLE film ADD CONSTRAINT fk_film_oyuncu FOREIGN KEY (oyuncu) REFERENCES oyuncu(oyuncu);

ALTER TABLE yonetmen ADD COLUMN yonetmenID INT PRIMARY KEY;
ALTER TABLE yonetmen ADD COLUMN yonetmenAdi VARCHAR;

ALTER TABLE filmformati ADD COLUMN filmFormatiID INT PRIMARY KEY;
ALTER TABLE filmformati ADD COLUMN formatAdi VARCHAR(35);

CREATE TABLE filmDil();
CREATE TABLE dil ();

ALTER TABLE filmdil ADD COLUMN filmDilID INT PRIMARY KEY;
ALTER TABLE dil ADD COLUMN dilID INT PRIMARY KEY;

CREATE TABLE filmtur ();
CREATE TABLE tur ();

ALTER TABLE filmtur ADD COLUMN filmturid INT PRIMARY KEY;
ALTER TABLE tur ADD COLUMN turid INT PRIMARY KEY;
ALTER TABLE tur ADD COLUMN turadi VARCHAR(20);
ALTER TABLE filmtur ADD COLUMN turid INT;
ALTER TABLE filmtur ADD COLUMN filmid INT;

ALTER TABLE filmtur
ADD CONSTRAINT fk_filmtur_tur
FOREIGN KEY (turid) REFERENCES tur(turid);

ALTER TABLE filmtur
ADD CONSTRAINT fk_filmtur_film
FOREIGN KEY (filmid) REFERENCES film(filmid);

ALTER TABLE film
ADD CONSTRAINT fk_film_oyuncu
FOREIGN KEY (oyuncuid) REFERENCES oyuncu(oyuncuid);

ALTER TABLE film
ADD CONSTRAINT fk_film_yonetmen
FOREIGN KEY (yonetmenid) REFERENCES yonetmen(yonetmenid);

ALTER TABLE filmdil ADD COLUMN dilid INT;
ALTER TABLE filmdil ADD COLUMN filmid INT;

ALTER TABLE filmdil
ADD CONSTRAINT fk_filmdil_film
FOREIGN KEY (filmid) REFERENCES film(filmid);

ALTER TABLE filmdil
ADD CONSTRAINT fk_filmdil_dil
FOREIGN KEY (dilid) REFERENCES dil(dilid);

ALTER TABLE gosterimbilgileri ADD COLUMN gosterimid INT PRIMARY KEY;
ALTER TABLE gosterimbilgileri ADD COLUMN ilkodu INT;

CREATE TABLE il ();
ALTER TABLE il ADD COLUMN ilkodu INT PRIMARY KEY;
ALTER TABLE il ADD COLUMN iladi VARCHAR;
ALTER TABLE il ADD COLUMN subeid INT; 

ALTER TABLE film
ADD CONSTRAINT fk_film_gosterimbilgileri
FOREIGN KEY (gosterimiid) REFERENCES gosterimbilgileri(gosterimid);

ALTER TABLE gosterimbilgileri
ADD CONSTRAINT fk_film_gosterimbilgileri
FOREIGN KEY (gosterimid) REFERENCES film(gosterimid);

ALTER TABLE film ADD COLUMN gosterimiid INT;

ALTER TABLE gosterimbilgileri
ADD CONSTRAINT fk_gosterimbilgileri_il
FOREIGN KEY (ilkodu) REFERENCES il(ilkodu);

CREATE TABLE sube ();
CREATE TABLE salon ();
CREATE TABLE kisi ();

ALTER TABLE sube ADD COLUMN subeid INT PRIMARY KEY;
ALTER TABLE sube ADD COLUMN subeadi VARCHAR;
ALTER TABLE sube ADD COLUMN salonid INT;
ALTER TABLE sube ADD COLUMN kisino INT;

ALTER TABLE il
ADD CONSTRAINT fk_il_sube
FOREIGN KEY (subeid) REFERENCES sube(subeid);

ALTER TABLE salon ADD COLUMN salonid INT PRIMARY KEY;
ALTER TABLE salon ADD COLUMN salonadi VARCHAR;

ALTER TABLE kisi ADD COLUMN kisino INT PRIMARY KEY;
ALTER TABLE kisi ADD COLUMN kisiadi VARCHAR;

ALTER TABLE sube
ADD CONSTRAINT fk_sube_salon
FOREIGN KEY (salonid) REFERENCES salon(salonid);

ALTER TABLE sube
ADD CONSTRAINT fk_sube_kisi
FOREIGN KEY (kisino) REFERENCES kisi(kisino);

CREATE TABLE "public"."altyazi" ( 
	"filmformatiid" INT,
	CONSTRAINT "altyaziPK" PRIMARY KEY ("filmformatiid")
);

CREATE TABLE "public"."dublaj" ( 
	"filmformatiid" INT,
	CONSTRAINT "dublajPK" PRIMARY KEY ("filmformatiid")
);

ALTER TABLE "public"."altyazi"
ADD CONSTRAINT "altyaziFilmFormati" FOREIGN KEY ("filmformatiid")
REFERENCES "public"."filmformati" (filmformatiid)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE "public"."dublaj"
ADD CONSTRAINT "dublajFilmFormati" FOREIGN KEY ("filmformatiid")
REFERENCES "public"."filmformati" (filmformatiid)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE film
ADD CONSTRAINT fk_film_filmformati
FOREIGN KEY (filmformatiid) REFERENCES filmformati(filmformatiid);


CREATE TABLE "public"."personel" ( 
	"kisino" INT,
	CONSTRAINT "personelPK" PRIMARY KEY ("kisino")
);

CREATE TABLE "public"."musteri" ( 
	"kisino" INT,
	CONSTRAINT "musteriPK" PRIMARY KEY ("kisino")
);

ALTER TABLE "public"."personel"
ADD CONSTRAINT "personelKisi" FOREIGN KEY ("kisino")
REFERENCES "public"."kisi" (kisino)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE "public"."musteri"
ADD CONSTRAINT "musteriKisi" FOREIGN KEY ("kisino")
REFERENCES "public"."kisi" (kisino)
ON DELETE CASCADE
ON UPDATE CASCADE;

CREATE TABLE "public"."bilet"(
"biletno" INT,
CONSTRAINT "biletPK" PRIMARY KEY ("biletno")
);

ALTER TABLE musteri ADD COLUMN biletno INT;

ALTER TABLE musteri
ADD CONSTRAINT fk_musteri_bilet
FOREIGN KEY (biletno) REFERENCES bilet(biletno);

ALTER TABLE film ADD COLUMN puan INT;
ALTER TABLE film ADD COLUMN yassiniri INT;



ALTER TABLE bilet ADD COLUMN biletfiyati INT; 




-----------------------en yüksek puandaki filmi getirme
CREATE OR REPLACE FUNCTION EnYuksekPuandakiFilmleriGetir3()
RETURNS TABLE (filmidd  INT, filmadii VARCHAR(255), puann NUMERIC)
AS 
$$
BEGIN
    RETURN QUERY
    SELECT filmid, filmadi, puan
    FROM film
    WHERE puan = (SELECT MAX(puan) FROM film);
END;
$$
LANGUAGE plpgsql;



--------------------------------oyuncu filmlerini listeleme
CREATE OR REPLACE FUNCTION OyuncununFilmleriniListele(p_oyuncuid INT)
RETURNS TABLE (filmidd INT, filmadii VARCHAR)
AS 
$$
BEGIN
    RETURN QUERY
    SELECT filmid, filmad
    FROM filmoyuncu
    WHERE oyuncuid = p_oyuncuid;
END;
$$
LANGUAGE plpgsql;


SELECT * FROM OyuncununFilmleriniListele(8);
SELECT * FROM EnYuksekPuandakiFilmleriGetir3();


-----------veri girişi
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "oyuncuid", "puan","sure","yassiniri","yonetmenid")
VALUES
('Esaretin Bedeli', 1, 1, 1, 9.3, 2.22, 13,1 );

SELECT * FROM "film";

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(1, 'Tim Robbins');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(2, 'Morgin Freeman');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(3, 'Marlon Brando');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(4, 'Al Pacino');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(5, 'Christian Bale');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(6, 'Heath Ledger');

SELECT * FROM "oyuncu";

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(7, 'Robert De Niro');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(8, 'Kemal Sunal');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(9, 'Münir Özkul');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(10, 'Halit Akçatepe');







INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(11, 'Şener Şen');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(12, 'Adile Naşit');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(13, 'Haluk Bilginer');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(14, 'Melisa Sözen');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(15, 'Demet Akbağ');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(16, 'Yılmaz Erdoğan');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(17, 'Ahmet Mümtaz Taylan');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(18, 'Alper Kul');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(19, 'Sarp Apak');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(20, 'Kıvanç Tatlıtuğ');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(21, 'Farah Zeynep Abdullah');

INSERT INTO "oyuncu"
("oyuncuid", "oyuncuadi")
VALUES
(22, 'Mert Fırat');



INSERT INTO "yonetmen"
("yonetmenid", "yonetmenadi")
VALUES
(1, 'Frank Darabont');

INSERT INTO "yonetmen"
("yonetmenid", "yonetmenadi")
VALUES
(2, 'Francis Ford Coppola');

INSERT INTO "yonetmen"
("yonetmenid", "yonetmenadi")
VALUES
(3, 'Christopher Nolan');

INSERT INTO "yonetmen"
("yonetmenid", "yonetmenadi")
VALUES
(4, 'Ertem Eğilmez');

INSERT INTO "yonetmen"
("yonetmenid", "yonetmenadi")
VALUES
(5, 'Nuri Bilge Ceylan');

INSERT INTO "yonetmen"
("yonetmenid", "yonetmenadi")
VALUES
(6, 'Ali Atay');

INSERT INTO "yonetmen"
("yonetmenid", "yonetmenadi")
VALUES
(7, 'Yılmaz Erdoğan');

SELECT * FROM "yonetmen";

INSERT INTO "filmformati"
("filmformatiid", "formatadi")
VALUES
(1, 'Dublaj');

INSERT INTO "filmformati"
("filmformatiid", "formatadi")
VALUES
(2, 'Altyazı');

SELECT * FROM "film";

INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "oyuncuid", "puan","sure","yassiniri","yonetmenid")
VALUES
('Esaretin Bedeli', 1, 1, 1, 9.3, 2.22, 13,1 );

INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "oyuncuid", "puan","sure","yassiniri","yonetmenid")
VALUES
('Esaretin Bedeli', 1, 1, 1, 9.3, 2.22, 13,1 );

INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "oyuncuid", "puan","sure","yassiniri","yonetmenid")
VALUES
('Esaretin Bedeli', 1, 1, 2, 9.3, 2.22, 13,1 );

CREATE TABLE filmOyuncu (
filmid INT,
oyuncuid INT,

PRIMARY KEY (filmid, oyuncuid),
FOREIGN KEY (filmid) REFERENCES film(filmid),
FOREIGN KEY (oyuncuid) REFERENCES oyuncu(oyuncuid)
);

CREATE TABLE Oyuncu (
    oyuncuid INT PRIMARY KEY
   
);

CREATE TABLE FilmOyuncu (
    filmoyuncuid INT PRIMARY KEY,
    filmid INT,
    oyuncuid INT,
    FOREIGN KEY (filmid) REFERENCES Film(filmid),
    FOREIGN KEY (oyuncuid) REFERENCES Oyuncu(oyuncuid)
);

INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri","yonetmenid")
VALUES
('Esaretin Bedeli', 1, 1, 9.3, 2.22, 13,1 );

ALTER TABLE gosterimbilgileri ADD COLUMN filmid INT;

ALTER TABLE gosterimbilgileri
ADD CONSTRAINT fk_gosterimbilgileri_film
FOREIGN KEY (filmid) REFERENCES film(filmid);

CREATE TABLE yonetmen (
    yonetmenid INT PRIMARY KEY
   
);

CREATE TABLE FilmYonetmen (
    filmyonetmenid INT PRIMARY KEY,
    filmid INT,
    yonetmenid INT,
    FOREIGN KEY (filmid) REFERENCES Film(filmid),
    FOREIGN KEY (yonetmenid) REFERENCES yonetmen(yonetmenid)
);

ALTER TABLE yonetmen ADD COLUMN yonetmenadi VARCHAR;
ALTER TABLE oyuncu ADD COLUMN oyuncuadi VARCHAR;

---esaretin bedeli başlangıç---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Esaretin Bedeli', 1, 1, 9.3, 2.22, 13 );

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Tim Robbins',1);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(1,1,1);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Morgan Freeman',2);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(1,2,2);
---esaretin bedeli bitiş---


---baba başlangıç---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Baba', 2, 2, 9.2, 175, 18 );

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Marlon Brando',3);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Al Pacino',4);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(2,3,3);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(2,4,4);
---baba bitiş---

---kara şövalye---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Kara Şövalye', 1, 3, 9.0, 152, 16 );

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Christian Bale',5);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Heath Ledger',6);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(3,5,5);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(3,6,6);
---kara şövalye---

---baba 2---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Baba 2', 2, 4, 9.0, 202, 18 );

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Robert De Niro',7);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(4,7,4);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(4,8,7);
---baba 2---

---hababam sınıfı---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Hababam Sınıfı', NULL, 5, 9.2, 87, 18 );

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Kemal Sunal',8);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Münir Özkul',9);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Halit Akçatepe',10);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Şener Şen',11);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Adile Naşit',12);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(5,9,8);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(5,10,9);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(5,11,10);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(5,12,12);
---hababam sınıfı---

---süt kardeşler---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Süt Kardeşler', NULL, 6, 8.8, 80, 7 );

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(6,13,8);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(6,14,10);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(6,15,11);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(6,16,12);
---süt kardeşler---

---kış uykusu---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Kış Uykusu', NULL, 7, 8.0, 196, 18 );

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Haluk Bilginer',13);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Melisa Sözen',14);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Demet Akbağ',15);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(7,17,13);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(7,18,14);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(7,19,15);
---kış uykusu---

---bir zamanlar anadoluda---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Bir Zamanlar Anadoluda', NULL, 8, 7.8, 157, 18 );

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Yılmaz Erdoğan',16);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Ahmet Mümtaz Taylan',17);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(8,20,16);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(8,21,17);
---bir zamanlar anadoluda---

---ölümlü dünya---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Ölümlü Dünya', NULL, 9, 7.8, 107, 15 );

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Feyyaz Yiğit',18);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Sarp Apak',19);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(9,22,17);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(9,23,18);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(9,24,19);
---ölümlü dünya---

---kelebeğin rüyası---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Kelebeğin Rüyası', NULL, 10, 7.7, 88, 7 );

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Kıvanç Tatlıtuğ',20);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Farah Zeynep Abdullah',21);

INSERT INTO "oyuncu"
("oyuncuadi","oyuncuid")
VALUES
('Mert Fırat',22);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(10,25,20);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(10,26,21);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(10,27,22);
---kelebeğin rüyası---

---organize işler---
INSERT INTO "film"
("filmadi", "filmformatiid", "filmid", "puan","sure","yassiniri")
VALUES
('Organize İşler', NULL, 11, 7.4, 104, 108 );

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(11,28,15);

INSERT INTO "filmoyuncu"
("filmid", "filmoyuncuid", "oyuncuid")
VALUES
(11,29,16);
---organize işler---
SELECT *FROM "film";

--YÖNETMENLER--
INSERT INTO "yonetmen"
("yonetmenadi", "yonetmenid")
VALUES
('Frank Darabont',1);

INSERT INTO "yonetmen"
("yonetmenadi", "yonetmenid")
VALUES
('Francis Ford Coppola',2);

INSERT INTO "yonetmen"
("yonetmenadi", "yonetmenid")
VALUES
('Christopher Nolan',3);

INSERT INTO "yonetmen"
("yonetmenadi", "yonetmenid")
VALUES
('Ertem Eğilmez',4);

INSERT INTO "yonetmen"
("yonetmenadi", "yonetmenid")
VALUES
('Nuri Bilge Ceylan',5);

INSERT INTO "yonetmen"
("yonetmenadi", "yonetmenid")
VALUES
('Ali Atay',6);

INSERT INTO "yonetmen"
("yonetmenadi", "yonetmenid")
VALUES
('Yılmaz Erdoğan',7);


INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(1,1,1);

INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(2,2,2);

INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(3,3,3);

INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(4,4,2);
---------
INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(5,5,4);

INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(6,6,4);

INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(7,7,5);

INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(8,8,5);

INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(9,9,6);

INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(10,10,7);

INSERT INTO "filmyonetmen"
("filmyonetmenid", "filmid", "yonetmenid")
VALUES
(11,11,7);

SELECT * FROM "altyazi";

ALTER TABLE dil ADD COLUMN diladi VARCHAR;
 
 INSERT INTO "dil"
 ("dilid","diladi")
 VALUES
 (1,'Türkçe');
 
  INSERT INTO "dil"
 ("dilid","diladi")
 VALUES
 (2,'İngilizce');
 
 INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (1,2,1)
 ----
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (2,2,2);
 
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (3,2,3);
 
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (4,2,4)
 ------------------
 
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (5,1,5);
 
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (6,1,6);
 
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (7,1,7);
 
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (8,1,8);
 
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (9,1,9);
 
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (10,1,10);
 
  INSERT INTO "filmdil"
 ("filmdilid","dilid","filmid")
 VALUES
 (11,1,11);
 
 
 ---tür---
 INSERT INTO "tur"
 ("turid","turadi")
 VALUES
 (1,'Suç');
 
 INSERT INTO "tur"
 ("turid","turadi")
 VALUES
 (2,'Aksiyon');
 
 INSERT INTO "tur"
 ("turid","turadi")
 VALUES
 (3,'Komedi');
 
 INSERT INTO "tur"
 ("turid","turadi")
 VALUES
 (4,'Dram');
 
 INSERT INTO "tur"
 ("turid","turadi")
 VALUES
 (5,'Romantik');
 
 INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (1,1,1);
 
 INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (2,1,2);
 
  INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (3,2,3);
 
  INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (4,1,4); 
 
  INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (5,3,5);
 
  INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (6,3,6);
 
  INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (7,4,7);
 
  INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (8,1,8);
 
  INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (9,3,9);
 
  INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (10,5,10);
 
  INSERT INTO "filmtur"
 ("filmturid","turid","filmid")
 VALUES
 (11,3,11);
 
SELECT * FROM "salon";

ALTER TABLE kisi
ADD CONSTRAINT fk_kisi_sube
FOREIGN KEY (subeid) REFERENCES sube(subeid);

ALTER TABLE kisi ADD COLUMN subeid INT;
ALTER TABLE salon ADD COLUMN subeid INT;

ALTER TABLE salon
ADD CONSTRAINT fk_salon_sube
FOREIGN KEY (subeid) REFERENCES sube(subeid);

ALTER TABLE sube ADD COLUMN ilkodu INT;
ALTER TABLE il ADD COLUMN ilid INT PRIMARY KEY;
ALTER TABLE sube
ADD CONSTRAINT fk_il_sube
FOREIGN KEY (ilkodu) REFERENCES il(ilkodu);

ALTER TABLE bilet ADD COLUMN kisino INT;

ALTER TABLE bilet
ADD CONSTRAINT fk_bilet_musteri
FOREIGN KEY (kisino) REFERENCES musteri(kisino);



---------------------------indirimli fiyat hesapla

CREATE OR REPLACE FUNCTION indirimli_fiyat_hesapla(bilet_fiyati NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
    indirim_orani NUMERIC := 0.10;
    indirimli_fiyat NUMERIC;
BEGIN

    indirimli_fiyat := bilet_fiyati - (bilet_fiyati * indirim_orani);

    RETURN indirimli_fiyat;
END;
$$ LANGUAGE plpgsql;

SELECT indirimli_fiyat_hesapla(500);

ALTER TABLE filmoyuncu ADD COLUMN filmad VARCHAR;


------------------çocuk bilet fiyatı
CREATE OR REPLACE FUNCTION cocuk_bilet_fiyati_hesapla(yas INT)
RETURNS NUMERIC AS $$
DECLARE
    cocuk_yas_siniri INT := 12;
    cocuk_indirim_orani NUMERIC := 0.50;
    birim_fiyat NUMERIC := 100;
    toplam_fiyat NUMERIC;
BEGIN
  
    IF yas <= cocuk_yas_siniri THEN
        toplam_fiyat := birim_fiyat * (1 - cocuk_indirim_orani);
    ELSE
       
        toplam_fiyat := birim_fiyat;
    END IF;

    RETURN toplam_fiyat;
END;
$$ LANGUAGE plpgsql;

SELECT cocuk_bilet_fiyati_hesapla(10);
SELECT cocuk_bilet_fiyati_hesapla(20);

ALTER TABLE film ADD COLUMN filmdili VARCHAR;




ALTER TABLE personel ADD COLUMN cinsiyet VARCHAR(10);



-- Bilet 
CREATE TABLE bilet (
    bilet_id SERIAL PRIMARY KEY,
    musteri_id INT
);


CREATE TABLE bilet_log (
    log_id SERIAL PRIMARY KEY,
    bilet_id INT,
    tarih TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_yeni_bilet()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO bilet_log (bilet_id, tarih)
  VALUES (NEW.bilet_id, NOW());
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER yeni_bilet_trigger
AFTER INSERT ON bilet
FOR EACH ROW
EXECUTE FUNCTION log_yeni_bilet();

INSERT INTO bilet (musteri_id) VALUES (1);


SELECT * FROM bilet_log;

INSERT INTO bilet (musteri_id) VALUES (2);

-------------------------------iptal
CREATE TABLE bilet_iptal (
    iptal_id SERIAL PRIMARY KEY,
    bilet_id INT
);


CREATE OR REPLACE FUNCTION log_bilet_iptal()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO bilet_iptal (bilet_id)
  VALUES (OLD.bilet_id);
  
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bilet_iptal_trigger
BEFORE DELETE ON bilet
FOR EACH ROW
EXECUTE FUNCTION log_bilet_iptal();

DELETE FROM bilet WHERE bilet_id = 1;

SELECT * FROM bilet_iptal;

DELETE  FROM bilet WHERE bilet_id=2;


-----------------personel ekleme trigger


CREATE TABLE personel_log (
    log_id SERIAL PRIMARY KEY,
    kisino INT
);

CREATE OR REPLACE FUNCTION log_yeni_personel_ekleme()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO personel_log (kisino)
  VALUES (NEW.kisino);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER yeni_personel_ekleme_trigger
AFTER INSERT ON personel
FOR EACH ROW
EXECUTE FUNCTION log_yeni_personel_ekleme();

INSERT INTO personel (kisino) VALUES (1);

SELECT * FROM personel_log;


--------------------personel silme trigger
CREATE TABLE silinen_personel_log (
    log_id SERIAL PRIMARY KEY,
    kisino INT
);

CREATE OR REPLACE FUNCTION log_silinen_personel()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO silinen_personel_log (kisino)
  VALUES (OLD.kisino);
  
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER silinen_personel_trigger
BEFORE DELETE ON personel
FOR EACH ROW
EXECUTE FUNCTION log_silinen_personel();

DELETE  FROM personel WHERE kisino=1;

SELECT*FROM silinen_personel_log;
