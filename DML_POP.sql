INSERT INTO guest (Indirizzo_IP)
VALUES
    ('192.168.1.1'),
    ('10.0.0.1'),
    ('172.16.0.1'),
    ('192.168.2.1');

INSERT INTO utente_registrato (Nome_utente, Nome, Cognome, Passw, Data_nascita, Fragile, Bits, Numero_telefono, Email)
VALUES
    ('user1', 'Mario', 'Rossi', 'password1', '1990-01-01', FALSE, 100000, '1234567890', NULL),
    ('user2', 'Giulia', 'Bianchi', 'password2', '1995-05-15', TRUE, 100, NULL, 'giulia@gmail.com'),
    ('user3', 'Luca', 'Verdi', 'password3', '1985-11-30', TRUE, 20000, '5556667777', 'luca@email.it'),
    ('user4', 'Paolo', 'Bruni', 'password4', '2000-01-03', FALSE, 3000, '3334445555', NULL),
    ('user5', 'Maria', 'De Giorgi', 'password5', '1997-07-30', TRUE, 2000, '0011155447', 'maria@live.ch'),
    ('user6', 'Antonio', 'Esposito', 'password6', '1975-12-25', FALSE, 200000, '7777777777', 'esposito@aruba.com');

INSERT INTO streamer (Nome_streamer, Affiliate, Numero_follower)
VALUES
    ('user1', TRUE, 1000),
    ('user3', FALSE, 500),
    ('user6', TRUE, 2000);

INSERT INTO canale (Proprietario, Descrizione, Social)
VALUES
    ('user1', 'Canale di user1', 'X, Instagram'),
    ('user3', 'Canale di user3 molto bello', 'Tiktok'),
    ('user6', 'Canale di user6 innovativo', 'Facebook, Discord');

INSERT INTO Amministratore_pagina (Nome, Cognome, Data_nascita)
VALUES
    ('Andrea', 'Marroni', '1975-04-10'),
    ('Gino', 'Bianchi', '1997-07-31');

INSERT INTO gestore (Nome, Cognome, Data_nascita)
VALUES
    ('Luca', 'Neri', '1990-04-17');

INSERT INTO contenuto_multimediale (URL, Titolo, Categoria, Hashtag, Fragili)
VALUES
    ('twitch.tv/Guardiamo_F1','Guardiamo la F1', 'Sport', '#F1', FALSE), --live / video
    ('twitch.tv/Finale_Fifa','Finale mondiale fifa e-sport', 'E-sport', '#e-sport', FALSE), --live / video
    ('twitch.tv/mattino','Chiacchiere del mattino', 'Quattro chiacchiere', '#buongiorno', TRUE), --live / video
    ('twitch.tv/ducking','Wild duckling', 'Animali', '#duck', TRUE), --live / no video
    ('twitch.tv/serata_horror','Serata horror', 'Videogiochi', '#paura', FALSE), --live / video
    ('twitch.tv/epico','Pack opening epico', 'Videogiochi', '#fortuna', FALSE), --live / video
    ('twitch.tv/Met_Gala','Commentiamo il Met Gala', 'Moda', '#cinema', TRUE), --live / no video
    ('twitch.tv/Lego','Costruiamo il nuovo set Lego', 'Quattro chiacchiere', '#lego', FALSE), --live / video
    ('twitch.tv/ultimo_giro','L''ultimo giro di Gara', 'Sport', '#rischio', FALSE), --clip
    ('twitch.tv/premiazione','Premiazione del vincitore', 'Sport', '#festa', FALSE), --clip
    ('twitch.tv/iper_mercato','Costruiamo un Iper mercato', 'Videogiochi', '#supermarketSimulator', FALSE), --live / no video
    ('twitch.tv/ramen','Proviamo i ramen super piccanti', 'Mukbang', '#cibo', FALSE), --live / video
    ('twitch.tv/Eurovision','Watchparty Eurovision', 'Watchparty', '#canzoni', FALSE), --live / no video
    ('twitch.tv/nuovo_gioco','Proviamo il nuovo gioco', 'Videogiochi', '#test', TRUE), --live / no video
    ('twitch.tv/Nurburgring','24h del Nurburgring', 'E-sport', '#iRacing', FALSE), --live / video
    ('twitch.tv/Redline','Vittoria del team Redline', 'E-sport', 'MaxVerstappen', FALSE), --clip
    ('twitch.tv/vincitore_Eurovision','Reazione del vincitore dell''Eurovision', 'Watchparty', '#svizzera', FALSE), --clip
    ('twitch.tv/Milano','In centro a Milano', 'IRL', '#duomo', FALSE), --live / no video
    ('twitch.tv/aggressione','Aggressione in centro', 'IRL', '#crimini', FALSE), --clip
    ('twitch.tv/it_takes_two','Finiamo It Takes Two', 'Videogiochi', '#rabbia', TRUE); --live / video

INSERT INTO Contiene (Proprietario, Descrizione, Contenuto)
VALUES
    ('user1', 'Canale di user1', 'twitch.tv/Guardiamo_F1'), 
    ('user1', 'Canale di user1', 'twitch.tv/Finale_Fifa'),
    ('user3', 'Canale di user3 molto bello', 'twitch.tv/mattino'), 
    ('user3', 'Canale di user3 molto bello', 'twitch.tv/ducking'), 
    ('user6', 'Canale di user6 innovativo', 'twitch.tv/serata_horror'), 
    ('user1', 'Canale di user1', 'twitch.tv/epico'), 
    ('user3', 'Canale di user3 molto bello', 'twitch.tv/Met_Gala'), 
    ('user6', 'Canale di user6 innovativo', 'twitch.tv/Lego'), 
    ('user1', 'Canale di user1', 'twitch.tv/ultimo_giro'), 
    ('user1', 'Canale di user1', 'twitch.tv/premiazione'), 
    ('user3', 'Canale di user3 molto bello', 'twitch.tv/iper_mercato'), 
    ('user6', 'Canale di user6 innovativo', 'twitch.tv/ramen'), 
    ('user6', 'Canale di user6 innovativo', 'twitch.tv/Eurovision'),
    ('user1', 'Canale di user1', 'twitch.tv/nuovo_gioco'), 
    ('user1', 'Canale di user1', 'twitch.tv/Nurburgring'), 
    ('user1', 'Canale di user1', 'twitch.tv/Redline'), 
    ('user6', 'Canale di user6 innovativo', 'twitch.tv/vincitore_Eurovision'), 
    ('user6', 'Canale di user6 innovativo', 'twitch.tv/Milano'), 
    ('user6', 'Canale di user6 innovativo', 'twitch.tv/aggressione'), 
    ('user1', 'Canale di user1', 'twitch.tv/it_takes_two'); 

INSERT INTO Gestisce (Amministratore, Proprietario, Descrizione, Ammontare_pagato, Data_ultimo_pagamento)
VALUES
    (1, 'user1', 'Canale di user1', 150, '2024-05-25'),
    (2, 'user3', 'Canale di user3 molto bello', 600, '2024-05-18'),
    (1, 'user6', 'Canale di user6 innovativo', 300, '2024-05-05');

INSERT INTO Blocca (Gestore, Streamer)
VALUES
    (1, 'user6');

INSERT INTO follower (Id_follower, Nome_streamer, Abbonato)
VALUES
    ('user1', 'user3', TRUE),
    ('user2', 'user1', FALSE),
    ('user2', 'user6', FALSE),
    ('user3', 'user1', TRUE),
    ('user4', 'user1', FALSE),
    ('user4', 'user3', TRUE),
    ('user4', 'user6', TRUE),
    ('user5', 'user3', FALSE),
    ('user5', 'user6', TRUE);

INSERT INTO calendario (Streamer, Nome_live, Data_live)
VALUES
    ('user1','Vacanza a Disneyland', '2024-08-24'),
    ('user1','Viaggio al mare', '2024-07-29'),
    ('user6','Finale e-sport', '2025-01-10');

INSERT INTO live (URL_live, Spettatori_medi, Data_inizio, Ora_inizio)
VALUES
    ('twitch.tv/Guardiamo_F1', 140, '2024-06-18', '15:00:00'), 
    ('twitch.tv/Finale_Fifa', 500, '2024-04-14', '20:00:00'), 
    ('twitch.tv/mattino', 10, '2024-06-10', '09:00:00'), 
    ('twitch.tv/ducking', 47, '2024-01-27', '15:00:00'), 
    ('twitch.tv/serata_horror', 4, '2024-05-22', '22:00:00'), 
    ('twitch.tv/epico', 7000, '2024-01-12', '21:30:00'), 
    ('twitch.tv/Met_Gala', 5000, '2024-06-24', '05:30:00'), 
    ('twitch.tv/Lego', 140, '2024-04-30', '15:00:00'),
    ('twitch.tv/iper_mercato', 367, '2024-06-22', '18:30:00'), 
    ('twitch.tv/ramen', 74, '2024-06-06', '20:30:00'), 
    ('twitch.tv/Eurovision', 875, '2024-06-21', '21:00:00'), 
    ('twitch.tv/nuovo_gioco', 45, '2024-06-23', '23:00:00'), 
    ('twitch.tv/Nurburgring', 786, '2024-05-04', '11:00:00'), 
    ('twitch.tv/Milano', 987, '2024-06-23', '23:30:00'), 
    ('twitch.tv/it_takes_two', 6, '2024-06-01', '21:30:00'); 

INSERT INTO live_presente (URL_live_presente)
VALUES
    ('twitch.tv/Met_Gala'), 
    ('twitch.tv/iper_mercato'), 
    ('twitch.tv/Eurovision'), 
    ('twitch.tv/nuovo_gioco'), 
    ('twitch.tv/Milano');

INSERT INTO live_passate (URL_live_passate, Data_fine, Ora_fine)
VALUES
    ('twitch.tv/Guardiamo_F1', '2024-06-18', '17:30:00'), 
    ('twitch.tv/Finale_Fifa', '2024-04-15', '00:00:00'), 
    ('twitch.tv/mattino', '2024-06-10', '11:00:00'), 
    ('twitch.tv/ducking', '2024-02-27', '15:00:00'), 
    ('twitch.tv/serata_horror', '2024-05-23', '04:00:00'), 
    ('twitch.tv/epico', '2024-01-12', '22:30:00'),
    ('twitch.tv/Lego', '2024-05-01', '03:00:00'),
    ('twitch.tv/ramen', '2024-06-06', '22:30:00'), 
    ('twitch.tv/Nurburgring', '2024-05-05', '12:00:00'), 
    ('twitch.tv/it_takes_two', '2024-06-01', '23:15:00'); 

INSERT INTO video_clip (URL_video_clip, Tipologia, Durata_minuti, Numero_views)
VALUES
    ('twitch.tv/ultimo_giro', TRUE, 2, 100),
    ('twitch.tv/premiazione', TRUE, 1, 1020),
    ('twitch.tv/Redline', TRUE, 12, 570),
    ('twitch.tv/vincitore_Eurovision', TRUE, 6, 14000),
    ('twitch.tv/aggressione', TRUE, 1, 57000),
    ('twitch.tv/Guardiamo_F1', FALSE, 150, 1200),
    ('twitch.tv/Finale_Fifa', FALSE, 240, 2000),
    ('twitch.tv/mattino', FALSE, 90, 65),
    ('twitch.tv/serata_horror', FALSE, 360, 41),
    ('twitch.tv/epico', FALSE, 60, 140),
    ('twitch.tv/Lego', FALSE, 720, 35),
    ('twitch.tv/Nurburgring', FALSE, 1500, 874),
    ('twitch.tv/it_takes_two', FALSE, 105, 56);

INSERT INTO chat (Mittente, Destinatario, Contenuto)
VALUES
    ('user1', 'user2', 'Ciao come stai?'),
    ('user2', 'user1', 'Tutto bene graze? A quanto la prossima live?'),
    ('user6', 'user3', 'Come vanno le live?'),
    ('user4', 'user5', 'Hai visto l''ultima live di user1?');

INSERT INTO dona (Mittente, Destinatario, Ammontare)
VALUES
    ('user1', 'user3', 1000),
    ('user4', 'user6', 150),
    ('user5', 'user3', 300);

INSERT INTO Commenta (Utente, Contenuto, Commento)
VALUES
    ('user1', 'twitch.tv/mattino', 'Buongiorno come va?'),
    ('user4', 'twitch.tv/aggressione', 'Pazzesco non si è mai al sicuro'),
    ('user5', 'twitch.tv/iper_mercato', 'Come si chiama il gioco?'),
    ('user6', 'twitch.tv/premiazione', 'Fortissimo'),
    ('user4', 'twitch.tv/Milano', 'Attento che Milano è pericolosa ultimamente'),
    ('user3', 'twitch.tv/ultimo_giro', 'Da brividi'),
    ('user6', 'twitch.tv/ultimo_giro', 'Non ce la puo'' fare');

INSERT INTO Guarda_registrato (Utente, Contenuto)
VALUES
    ('user1', 'twitch.tv/mattino'),
    ('user1', 'twitch.tv/ducking'),
    ('user1', 'twitch.tv/aggressione'),
    ('user2', 'twitch.tv/Guardiamo_F1'),
    ('user2', 'twitch.tv/aggressione'),
    ('user2', 'twitch.tv/Milano'),
    ('user3', 'twitch.tv/ultimo_giro'),
    ('user3', 'twitch.tv/epico'),
    ('user3', 'twitch.tv/Nurburgring'),
    ('user3', 'twitch.tv/premiazione'),
    ('user4', 'twitch.tv/Guardiamo_F1'),
    ('user4', 'twitch.tv/aggressione'),
    ('user4', 'twitch.tv/ramen'),
    ('user4', 'twitch.tv/Milano'),
    ('user4', 'twitch.tv/vincitore_Eurovision'),
    ('user4', 'twitch.tv/it_takes_two'),
    ('user5', 'twitch.tv/serata_horror'),
    ('user5', 'twitch.tv/iper_mercato'),
    ('user5', 'twitch.tv/Redline'),
    ('user5', 'twitch.tv/mattino'),
    ('user5', 'twitch.tv/Lego'),
    ('user5', 'twitch.tv/Milano'),
    ('user5', 'twitch.tv/Finale_Fifa'),
    ('user6', 'twitch.tv/vincitore_Eurovision'),
    ('user6', 'twitch.tv/premiazione'),
    ('user6', 'twitch.tv/Finale_Fifa'),
    ('user6', 'twitch.tv/iper_mercato'),
    ('user6', 'twitch.tv/Redline'),
    ('user6', 'twitch.tv/ultimo_giro'),
    ('user6', 'twitch.tv/ducking');

INSERT INTO Guarda_anonimo (Guest, Contenuto)
VALUES
    ('192.168.1.1', 'twitch.tv/Guardiamo_F1'),
    ('192.168.1.1', 'twitch.tv/premiazione'),
    ('10.0.0.1', 'twitch.tv/aggressione'),
    ('10.0.0.1', 'twitch.tv/Nurburgring'),
    ('10.0.0.1', 'twitch.tv/epico'),
    ('172.16.0.1', 'twitch.tv/ramen'),
    ('172.16.0.1', 'twitch.tv/aggressione'),
    ('192.168.2.1', 'twitch.tv/ultimo_giro'),
    ('192.168.2.1', 'twitch.tv/aggressione'),
    ('192.168.1.1', 'twitch.tv/ramen');
    
INSERT INTO Vota (Follower, Streamer, Contenuto, Voto)
VALUES
    ('user2', 'user1', 'twitch.tv/Guardiamo_F1', 8),
    ('user4', 'user1', 'twitch.tv/Guardiamo_F1', 9),
    ('user5', 'user6', 'twitch.tv/serata_horror', 5),
    ('user3', 'user1', 'twitch.tv/ultimo_giro', 10),
    ('user4', 'user6', 'twitch.tv/ramen', 7),
    ('user4', 'user6', 'twitch.tv/aggressione', 10),
    ('user4', 'user6', 'twitch.tv/Milano', 9),
    ('user3', 'user1', 'twitch.tv/epico', 8),
    ('user5', 'user3', 'twitch.tv/iper_mercato', 3),
    ('user2', 'user6', 'twitch.tv/aggressione', 9),
    ('user2', 'user6', 'twitch.tv/Milano', 8);








































UPDATE Commenta
SET Commento = CONCAT(Commento, ' | ', 'Altro testo da aggiungere')
WHERE Utente = 'user1' AND Contenuto = 'twitch.tv/mattino';
