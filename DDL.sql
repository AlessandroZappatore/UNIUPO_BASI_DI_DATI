CREATE TABLE
    guest (
        Indirizzo_IP varchar(12),
        constraint guest_pk primary key (Indirizzo_IP)
    );

CREATE TABLE
    utente_registrato (
        Nome_utente varchar(50),
        Nome varchar(50) not null,
        Cognome varchar(50) not null,
        Passw varchar(20) not null,
        Data_nascita date not null,
        Fragile boolean default False,
        Bits integer default 0,
        Numero_telefono varchar(10),
        Email varchar(40) UNIQUE,
        constraint utente_pk primary key (Nome_utente)
    );

CREATE TABLE
    streamer (
        Nome_streamer varchar(50),
        Affiliate boolean default False,
        Numero_follower integer default 0,
        constraint streamer_pk primary key (Nome_streamer),
        constraint streamer_fk_utente foreign key (Nome_streamer) references utente_registrato (Nome_utente) on delete cascade on update cascade
    );

CREATE TABLE
    follower (
        Id_follower varchar(50),
        Nome_streamer varchar(50),
        Abbonato boolean default False,
        constraint follower_pk primary key (Id_follower, Nome_streamer),
        constraint follower_fk_utente foreign key (Id_follower) references utente_registrato (Nome_utente) on delete cascade on update cascade,
        constraint follower_fk_streamer foreign key (Nome_streamer) references streamer (Nome_streamer) on delete cascade on update cascade
    );

CREATE TABLE
    gestore (
        Id_gestore SERIAL,
        Nome varchar(50) not null,
        Cognome varchar(50) not null,
        Data_nascita date not null,
        constraint gestore_pk primary key (Id_gestore)
    );

CREATE TABLE
    calendario (
        Streamer varchar(50),
        Nome_live varchar(60),
        Data_live date not null,
        constraint calendario_pk primary key (Streamer, Nome_live, Data_live),
        constraint streamer_calendario foreign key (Streamer) references streamer (Nome_streamer) on delete cascade on update cascade
    );

CREATE TABLE
    canale (
        Proprietario varchar(50),
        Descrizione varchar(100),
        Social varchar(100),
        constraint canale_pk primary key (Proprietario, Descrizione),
        constraint canale_fk_streamer foreign key (Proprietario) references streamer (Nome_streamer) on delete cascade on update cascade
    );

CREATE TABLE
    amministratore_pagina (
        Id_amministratore SERIAL,
        Nome varchar(50) not null,
        Cognome varchar(50) not null,
        Data_nascita date not null,
        constraint amministratore_pk primary key (Id_amministratore)
    );

CREATE TABLE
    contenuto_multimediale (
        URL varchar(100),
        Titolo varchar(60) not null,
        Categoria varchar(50) default 'Non categorizzato',
        Hashtag  varchar(60),
        Fragili boolean default False,
        constraint contenuto_pk primary key (URL)
    );

CREATE TABLE
    live (
        URL_live varchar(100),
        Spettatori_medi integer default 0,
        Data_inizio date not null,
        Ora_inizio time not null,
        constraint live_pk primary key (URL_live),
        constraint live_fk_contenuto foreign key (URL_live) references contenuto_multimediale (URL) on delete cascade on update cascade
    );

CREATE TABLE
    live_passate (
        URL_live_passate varchar(100),
        Data_fine date not null,
        Ora_fine time not null,
        constraint live_passate_pk primary key (URL_live_passate),
        constraint live_passate_fk_contenuto foreign key (URL_live_passate) references contenuto_multimediale (URL) on delete cascade on update cascade
    );

CREATE TABLE
    live_presente (
        URL_live_presente varchar(100),
        constraint live_presente_pk primary key (URL_live_presente),
        constraint live_presente_fk_contenuto foreign key (URL_live_presente) references contenuto_multimediale (URL) on delete cascade on update cascade
    );

CREATE TABLE
    video_clip (
        URL_video_clip varchar(100),
        Tipologia boolean default False, --False video, True clip
        Durata_minuti integer not null,
        Numero_views integer default 0,
        constraint video_clip_pk primary key (URL_video_clip),
        constraint video_clip_fk_contenuto foreign key (URL_video_clip) references contenuto_multimediale (URL) on delete cascade on update cascade
    );

CREATE TABLE
    chat (
        Mittente varchar(50),
        Destinatario varchar(50),
        Contenuto varchar(200),
        constraint chat_pk primary key (Mittente, Destinatario),
        constraint chat_fk1_utente foreign key (Mittente) references utente_registrato (Nome_utente) on delete cascade on update cascade,
        constraint chat_fk2_utente foreign key (Destinatario) references utente_registrato (Nome_utente) on delete cascade on update cascade
    );

CREATE TABLE
    dona (
        Mittente varchar(50),
        Destinatario varchar(50),
        Ammontare integer not null,
        constraint dona_pk primary key (Mittente, Destinatario),
        constraint dona_fk_utente foreign key (Mittente) references utente_registrato (Nome_utente) on update cascade on delete cascade,
        constraint dona_fk_streamer foreign key (Destinatario) references streamer (Nome_streamer) on update cascade on delete cascade
    );

CREATE TABLE
    Blocca (
        Gestore integer,
        Streamer varchar(50),
        constraint blocca_pk primary key (Gestore, Streamer),
        constraint blocca_fk_gestore foreign key (Gestore) references gestore (Id_gestore) on delete cascade on update cascade,
        constraint blocca_fk_streamer foreign key (Streamer) references streamer (Nome_streamer) on delete cascade on update cascade
    );

CREATE TABLE
    Vota (
        Follower varchar(50),
        Streamer varchar(50),
        Contenuto varchar(100),
        Voto smallint not null check (
            Voto >= 0
            and Voto <= 10
        ),
        constraint vota_pk primary key (Follower, Streamer, Contenuto),
        constraint vota_fk_follower foreign key (Follower, Streamer) references follower (Id_follower, Nome_streamer) on delete cascade on update cascade,
        constraint vota_fk_contenuto foreign key (Contenuto) references contenuto_multimediale (URL) on delete cascade on update cascade
    );

CREATE TABLE
    Commenta (
        Utente varchar(50),
        Contenuto varchar(100),
        Commento varchar(100) not null,
        constraint commenta_pk primary key (Utente, Contenuto),
        constraint commenta_fk_utente foreign key (Utente) references utente_registrato (Nome_utente) on delete cascade on update cascade,
        constraint commenta_fk_contenuto foreign key (Contenuto) references contenuto_multimediale (URL) on delete cascade on update cascade
    );

CREATE TABLE
    Guarda_registrato (
        Utente varchar(50),
        Contenuto varchar(100),
        constraint guarda_registrato_pk primary key (Utente, Contenuto),
        constraint guarda_registrato_fk_utente foreign key (Utente) references utente_registrato (Nome_utente) on delete cascade on update cascade,
        constraint guarda_registrato_fk_contenuto foreign key (Contenuto) references contenuto_multimediale (URL) on delete cascade on update cascade
    );

CREATE TABLE
    Guarda_anonimo (
        Guest varchar(12),
        Contenuto varchar(100),
        constraint guarda_anonimo_pk primary key (Guest, Contenuto),
        constraint guarda_anonimo_fk_utente foreign key (Guest) references guest (Indirizzo_IP) on delete cascade on update cascade,
        constraint guarda_anonimo_fk_contenuto foreign key (Contenuto) references contenuto_multimediale (URL) on delete cascade on update cascade
    );

CREATE OR REPLACE FUNCTION validate_follower_content_vote()
RETURNS TRIGGER AS $$
BEGIN
  IF (NOT EXISTS (SELECT 1 FROM follower
                  WHERE follower.id_follower = NEW.follower
                  AND follower.nome_streamer = NEW.streamer)) THEN
    RAISE EXCEPTION 'L''utente % deve seguire lo streamer % per votare un suo contenuto', NEW.follower, NEW.streamer;
  END IF;

  IF (NOT EXISTS (SELECT 1 FROM contenuto_multimediale
                  WHERE url = NEW.contenuto
                  AND proprietario = NEW.streamer)) THEN
    RAISE EXCEPTION 'Il contenuto % non è stato creato dallo streamer %', NEW.contenuto, NEW.streamer;
  END IF;

  RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE TABLE
    Contiene (
        Proprietario varchar(50),
        Descrizione varchar(100),
        Contenuto varchar(100),
        constraint contiene_pk primary key (Proprietario, Descrizione, Contenuto),
        constraint contiene_fk_canale foreign key (Proprietario, Descrizione) references canale (Proprietario, Descrizione) on delete cascade on update cascade,
        constraint contiene_fk_contenuto foreign key (Contenuto) references contenuto_multimediale (URL) on delete cascade on update cascade
    );

CREATE TABLE
    Gestisce (
        Amministratore integer,
        Proprietario varchar(50),
        Descrizione varchar(100),
        Ammontare_pagato decimal(8,2) not null,
        Data_ultimo_pagamento date not null,
        constraint gestisce_pk primary key (Amministratore, Proprietario, Descrizione),
        constraint gestisce_fk_amministratore foreign key (Amministratore) references Amministratore_pagina (Id_amministratore) on delete cascade on update cascade,
        constraint gestisce_fk_canale foreign key (Proprietario, Descrizione) references Canale (Proprietario, Descrizione) on delete cascade on update cascade
    );


CREATE OR REPLACE FUNCTION validate_follower_content_vote()
RETURNS TRIGGER AS $$
BEGIN
  IF (NOT EXISTS (SELECT 1 FROM follower
                  WHERE follower.id_follower = NEW.follower
                  AND follower.nome_streamer = NEW.streamer)) THEN
    RAISE EXCEPTION 'L''utente % deve seguire lo streamer % per votare un suo contenuto', NEW.follower, NEW.streamer;
  END IF;

  IF (NOT EXISTS (SELECT 1 FROM Contiene
                  WHERE Contiene.Contenuto = NEW.contenuto
                  AND Contiene.Proprietario = NEW.streamer)) THEN
    RAISE EXCEPTION 'Il contenuto % non è stato creato dallo streamer %', NEW.contenuto, NEW.streamer;
  END IF;

  RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER validate_vote_follower BEFORE INSERT ON Vota
FOR EACH ROW
EXECUTE PROCEDURE validate_follower_content_vote();


CREATE OR REPLACE FUNCTION update_streamer_follower_count() 
RETURNS TRIGGER AS $$
BEGIN
  UPDATE streamer
  SET numero_follower = numero_follower + 1
  WHERE nome_streamer = NEW.nome_streamer;
  RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER update_follower_count AFTER INSERT ON follower
FOR EACH ROW
EXECUTE PROCEDURE update_streamer_follower_count();

CREATE OR REPLACE FUNCTION decrement_follower_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE streamer
  SET numero_follower = numero_follower - 1
  WHERE nome_streamer = OLD.nome_streamer;
  RETURN OLD;
END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER update_follower_count_after_delete
AFTER DELETE ON follower
FOR EACH ROW
EXECUTE PROCEDURE decrement_follower_count();