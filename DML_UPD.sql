--Op9 Aggiungere un nuovo utente
INSERT INTO utente_registrato (Nome_utente, Nome, Cognome, Passw, Data_nascita, Email, Numero_telefono)
VALUES ('nuovo_utente', 'NomeNuovo', 'CognomeNuovo', 'password', '2000-01-01', 'nuovo@example.com', '1234567890');

--Op10 Inserire un nuovo contenuto
INSERT INTO contenuto_multimediale (URL, Titolo, Categoria, Hashtag, Fragili)
VALUES
    ('twitch.tv/Celebrity_Hunted','Watchparty Celebrity Hunted', 'Watchparty', '#PrimeVideo', FALSE);

INSERT INTO Contiene (Proprietario, Descrizione, Contenuto)
VALUES
    ('user1', 'Canale di user1', 'twitch.tv/Celebrity_Hunted');

--Op11 Modificare un utente
UPDATE utente_registrato
SET Nome = 'NuovoNome', Cognome = 'NuovoCognome', Passw = 'NuovaPassword', Data_nascita = '2001-03-04', Fragile = true, Bits = 10, Numero_telefono = '9876543210', Email = 'nuova@email.com'
WHERE Nome_utente = 'user4';

--Op12 Modificare un canale
UPDATE canale
SET Descrizione = 'NuovaDescrizione', Social = 'NuoviSocial'
WHERE Proprietario = 'user3' AND Descrizione = 'Canale di user3 molto bello';

--Op13 Inserire una live al calendario
INSERT INTO calendario (Streamer, Nome_live, Data_live)
VALUES
    ('user6','Vacanza a Ibiza', '2025-08-24');

--Op17 Inserire un nuovo follower
INSERT INTO follower (Id_follower, Nome_streamer, Abbonato)
VALUES
    ('user6', 'user3', TRUE);