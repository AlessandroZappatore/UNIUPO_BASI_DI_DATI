/* Restituire nome, cognome ed età dell'utente follower più vecchio 
(quello che ha l'età anagrafica maggiore di tutti gli altri followers). 
Scrivere la query senza l'utilizzo dell'operatore aggregato di MAX e senza l'operatore LIMIT.*/

/* Come l'ho fatta io */
SELECT 
    ur.nome as "Nome",
    ur.cognome as "Cognome",
    EXTRACT(year FROM AGE(ur.data_nascita)) as "Età"
FROM
    utente_registrato ur
WHERE
    ur.data_nascita = (
        SELECT MIN(ur1.data_nascita)
        FROM utente_registrato ur1
        INNER JOIN follower f1 ON ur1.nome_utente = f1.id_follower
    );

SELECT MIN(ur1.data_nascita)
        FROM utente_registrato ur1
        INNER JOIN follower f1 ON ur1.nome_utente = f1.id_follower

/* Come mi è stata chiesta all'orale */
SELECT 
    ur.nome as "Nome",
    ur.cognome as "Cognome",
    EXTRACT(year FROM AGE(ur.data_nascita)) as "Età"
FROM
    utente_registrato ur
WHERE
    ur.data_nascita <= all(
        SELECT 
            ur1.data_nascita
        FROM 
            utente_registrato ur1
        INNER JOIN 
            follower f1 ON ur1.nome_utente = f1.id_follower
    )

