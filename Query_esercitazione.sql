/*1 Per ciascun streamer, restituire il numero di live (passate e correnti) raggruppate per categoria.  
Riportare la durata media (AVG(TimeStampFineLivePassata-TimeStampInizioLivePassata)) in minuti delle live passate.*/

SELECT 
	co.proprietario as "Streamer",
	COUNT(lip.url_live_passate) as "Numero live passate",
	ROUND(AVG(EXTRACT(EPOCH FROM AGE(
    lip.data_fine + lip.ora_fine,
    li.data_inizio + li.ora_inizio
	)) / 60)) as "Durata media live passate",
	num_presente.num_live_presente as "Numero live presente"
FROM
	live_passate as lip
INNER JOIN
	live as li ON li.url_live = lip.url_live_passate
INNER JOIN
	contiene as co ON co.contenuto = lip.url_live_passate
LEFT JOIN(
	SELECT 
		co.proprietario,
		COUNT(lipp.url_live_presente) as num_live_presente
	FROM
		live_presente as lipp
	INNER JOIN
		contiene as co ON co.contenuto = lipp.url_live_presente
	GROUP BY
		co.proprietario
) as num_presente ON num_presente.proprietario = co.proprietario
GROUP BY
	co.proprietario,
	num_presente.num_live_presente
ORDER BY
	"Durata media live passate" ASC;

/*2 Selezionare gli streamer di età compresa tra [30<=x<=40] anni (estremi inclusi) 
che stanno trasmettendo almeno 2 live in diretta. 
Ordinare le live in ordine decrescente per data di inizio.*/

SELECT 
	ur.nome as "Nome",
	ur.cognome as "Cognome",
	EXTRACT(year FROM AGE(ur.data_nascita)) as "Età",
	num_live_presente.num_live as "Numero live presente",
	num_live_presente.max_data as "Data inizio live"
FROM
	streamer as st
INNER JOIN
	utente_registrato as ur ON ur.nome_utente = st.nome_streamer
LEFT JOIN(
	SELECT 
		co.proprietario,
		COUNT(lp.url_live_presente) as num_live,
		MAX(li.data_inizio) as max_data
	FROM
		live_presente as lp
	INNER JOIN
		contiene as co ON co.contenuto = lp.url_live_presente
	INNER JOIN
		live as li ON li.url_live = lp.url_live_presente
	GROUP BY
		co.proprietario
) as num_live_presente ON num_live_presente.proprietario = st.nome_streamer
GROUP BY
	ur.nome,
	ur.cognome,
	EXTRACT(year FROM AGE(ur.data_nascita)),
	num_live_presente.num_live,
	num_live_presente.max_data
HAVING
	ROUND(EXTRACT(year FROM AGE(ur.data_nascita))) BETWEEN 30 AND 40 AND
	num_live_presente.num_live >= 2
ORDER BY
	max_data DESC;

/*3 Per ogni streamer, elencare i titolo del video con il relativo numero di visualizzazioni che ha ottenuto la media dei voti (secondo la scala likert [1-10] massimo. 
Ordinare il risultato il ordine decrescente per media dei voti.*/

SELECT 
    s.nome_streamer,
    avg_voti.titolo,
    avg_voti.avg_voto
FROM 
    streamer as s
INNER JOIN (
    SELECT 
        vo.streamer,
        co.titolo,
        ROUND(AVG(voto), 2) AS avg_voto
    FROM
        video_clip AS vc
    LEFT JOIN
        vota AS vo ON vo.contenuto = vc.url_video_clip
    INNER JOIN
        contenuto_multimediale AS co ON co.url = vc.url_video_clip
    WHERE 
        tipologia = false
    GROUP BY
        vo.streamer,
        co.titolo
) AS avg_voti ON s.nome_streamer = avg_voti.streamer
INNER JOIN (
    SELECT 
        streamer,
        MAX(avg_voto) AS max_avg_voto
    FROM (
        SELECT 
            vo.streamer,
            ROUND(AVG(voto), 2) AS avg_voto
        FROM
            video_clip AS vc
        LEFT JOIN
            vota AS vo ON vo.contenuto = vc.url_video_clip
        INNER JOIN
            contenuto_multimediale AS co ON co.url = vc.url_video_clip
        WHERE 
            tipologia = false
        GROUP BY
            vo.streamer,
            co.titolo
    ) AS inner_avg_voti
    GROUP BY
        streamer
) AS max_avg ON avg_voti.streamer = max_avg.streamer AND avg_voti.avg_voto = max_avg.max_avg_voto
ORDER BY 
        avg_voti.avg_voto DESC;

/*4 Per ogni categoria, elencare il numero di video, la durata media (in minuti, AVG(TimeStampFineVideo-TimeStampInizioVideo)) in minuti) 
dei video e il numero di spettatori di quei video. 
Ordinare il risultato in ordine decrescente per numero video.*/

SELECT 
	cm.categoria as "Categoria",
	COUNT(*) as "Numero video",
	SUM(vc.numero_views) AS "Numero spettatori",
	ROUND(AVG(vc.durata_minuti), 0) AS "Durata media video"
FROM 
	video_clip AS vc
INNER JOIN
	contenuto_multimediale AS cm ON url = url_video_clip
WHERE 
	tipologia = false
GROUP BY
	cm.categoria
ORDER BY
	"Numero video" DESC;

/*5 Per ogni streamer che ha creato almeno 2 video, si vuole conoscere la durata media dei suoi video (AVG(TimeStampFineVideo-TimeStampInizioVideo)) in minuti, 
numero di voti e numero totale di commenti. 
Ordinare il risultato in ordine decrescente per età dello streamer.*/

SELECT 
	ur.nome as "Nome", 
	ur.cognome as "Cognome",
	EXTRACT(year FROM AGE(ur.data_nascita)) AS "Età",
	Durata_media_video as "Durata media video",
	numero_commenti as "Numero commenti",
	numero_voti	as "Numero voti"
FROM
	utente_registrato AS ur
INNER JOIN
	streamer AS st ON ur.nome_utente = st.nome_streamer
LEFT JOIN(
	SELECT 
		streamer, 
	 	COUNT(voto) as numero_voti
	FROM
		vota
	GROUP BY
		streamer) AS voti ON st.nome_streamer = voti.streamer
INNER JOIN(
	SELECT 
		co.proprietario,  
		ROUND(AVG(vc.durata_minuti),0) as Durata_media_video
	FROM
		video_clip AS vc
	INNER JOIN
		contiene AS co ON vc.url_video_clip = co.contenuto
	WHERE 
		tipologia = false
	GROUP BY
		co.proprietario
	HAVING
		COUNT(vc.url_video_clip) >= 2
	) AS durata_media ON st.nome_streamer = durata_media.proprietario
LEFT JOIN (
	SELECT 
		co.proprietario,
		COUNT(commento) AS numero_commenti
	FROM
		video_clip AS vc
	INNER JOIN
		commenta as com ON com.contenuto = vc.url_video_clip
	INNER JOIN
		contiene AS co ON vc.url_video_clip = co.contenuto
	WHERE 
		tipologia = false
	GROUP BY
		co.proprietario) AS commenti ON st.nome_streamer = commenti.proprietario

/*6 Per ogni streamer diventato affiliate, si vuole conoscere il numero di video creati, il numero di spettatori (di quei video) 
e l'età media degli spettatori che hanno visualizzato i suoi video, ma che non li hanno votati. 
Restituire il risultato in ordine crescente per NumeroSpettatori.*/

SELECT 
	co.proprietario as "Nome streamer",
	st.affiliate,
	COUNT(url_video_clip) as "Numero video creati",
	SUM(numero_views) as "Numero spettaori",
	eta as "Età media spettatori"
FROM 
	video_clip as vc
INNER JOIN
	contiene as co ON co.contenuto = vc.url_video_clip
LEFT JOIN(
	SELECT 
		co.proprietario,
		ROUND(AVG(EXTRACT(year FROM AGE(ur.data_nascita))),0) as eta
	FROM
		guarda_registrato as gr
	LEFT JOIN
		vota as vo ON vo.follower = gr.utente
	INNER JOIN
		contiene as co ON co.contenuto = gr.contenuto
	INNER JOIN
		utente_registrato as ur ON ur.nome_utente = gr.utente
	INNER JOIN
		video_clip as vc ON vc.url_video_clip = gr.contenuto
	WHERE
		vo.voto IS NULL 
		AND
		vc.tipologia = false
	GROUP BY
		co.proprietario
) as no_voto ON no_voto.proprietario = co.proprietario
INNER JOIN
	streamer AS st ON st.nome_streamer = co.proprietario
WHERE
	tipologia = false AND
	st.affiliate = true
GROUP BY
	co.proprietario,
	st.affiliate,
	eta
ORDER BY
	"Numero spettaori" ASC;

/*7 Per ogni streamer di età compresa tra [25<=x<=40] anni CHE NON E' AFFILIATE, elencare il numero di video e il totale dei minuti che hanno trasmesso. 
Ordinare il risultato in ordine decrescente di TotaleMinutiTrasmessi.*/

SELECT 
	ur.nome as "Nome",
	ur.cognome as "Cognome",
	EXTRACT(year FROM AGE(ur.data_nascita)) as "Età",
	st.affiliate as "Affiliate?",
	num_video_streamer as "Numero video",
	durata_minuti as "Totale minuti trasmessi"
FROM
	streamer AS st
INNER JOIN
	utente_registrato AS ur ON ur.nome_utente = st.nome_streamer
LEFT JOIN(
	SELECT 
		co.proprietario,
		COUNT(vc.url_video_clip) as num_video_streamer
	FROM
		video_clip AS vc
	INNER JOIN
		contiene as co ON co.contenuto = vc.url_video_clip
	WHERE 
		tipologia = false
	GROUP BY
		co.proprietario) AS num_video ON num_video.proprietario = st.nome_streamer
LEFT JOIN(
	SELECT 
	    co.proprietario,
	    SUM(ROUND(EXTRACT(EPOCH FROM AGE(
	        lip.data_fine + lip.ora_fine,
	        li.data_inizio + li.ora_inizio
	    )) / 60, 0)) AS durata_minuti
	FROM
	    live AS li
	INNER JOIN 
	    contiene AS co ON co.contenuto = li.url_live
	INNER JOIN
	    live_passate AS lip ON lip.url_live_passate = li.url_live
	GROUP BY
	    co.proprietario) AS minuti_live ON minuti_live.proprietario = st.nome_streamer
WHERE 
	affiliate = false AND
	EXTRACT(year FROM AGE(ur.data_nascita)) BETWEEN 25 AND 40
ORDER BY
	durata_minuti DESC
 
/*8 Restituire nome, cognome e età (in anni) degli amministratori di canale che gestiscono almeno 10 canali con al massimo 100 followers. 
Ordinare il risultato in ordine decrescente per totale corrispettivo pagato al provider per il servizio di hosting.*/

SELECT 
	ap.nome,
	ap.cognome,
	EXTRACT(year FROM AGE(ap.data_nascita)) as "Età",
	COUNT(ge.proprietario) as "Numero canali gestititi",
	SUM(selected_streamer.numero_follower),
	SUM(ge.ammontare_pagato) as "Spese totali"
FROM 
	gestisce as ge
INNER JOIN (
	SELECT 
		nome_streamer,
		numero_follower
	FROM 
		streamer
	WHERE
		numero_follower < 3000) as selected_streamer ON selected_streamer.nome_streamer = ge.proprietario 
INNER JOIN
	amministratore_pagina as ap ON ap.id_amministratore = ge.amministratore
GROUP BY
	ap.nome,
	ap.cognome,
	EXTRACT(year FROM AGE(ap.data_nascita))
HAVING
	COUNT(ge.proprietario) >= 2
ORDER BY
	SUM(ge.ammontare_pagato) DESC;

/*9 Restituire nome, cognome e età (in anni) di followers appartenenti alle categorie dei fragili che NON hanno commentato video di affiliate 
di età compresa tra [20<=x<=35] anni (estremi inclusi). 
Per ciascun followers fragile, calcolare l'età media dei membri affiliate (AVG(Affiliate.Età)). 
Ordinare il risultato per numero decrescente di commenti. 
Svolgere la query con gli operatori in/not in.
*/

SELECT 
    ur.nome_utente,
    ur.nome,
    ur.cognome,
	ur.fragile,
    EXTRACT(YEAR FROM AGE(ur.data_nascita)) AS eta,
    (SELECT ROUND(AVG(EXTRACT(YEAR FROM AGE(ur.data_nascita))), 2)
     FROM streamer AS st
     INNER JOIN utente_registrato AS ur ON ur.nome_utente = st.nome_streamer
     WHERE EXTRACT(YEAR FROM AGE(ur.data_nascita)) BETWEEN 20 AND 35
       AND st.affiliate = true) AS eta_media_affiliati,
    (SELECT COUNT(*) 
     FROM commenta AS com
     WHERE com.utente = ur.nome_utente) AS numero_commenti
FROM
    follower AS fo
INNER JOIN
    utente_registrato AS ur ON ur.nome_utente = fo.id_follower
WHERE 
    ur.fragile = true
    AND ur.nome_utente NOT IN (
        SELECT DISTINCT com.utente
        FROM commenta AS com
        INNER JOIN contiene AS co ON com.contenuto = co.contenuto
        WHERE co.proprietario IN (
            SELECT st.nome_streamer
            FROM streamer AS st
            INNER JOIN utente_registrato AS ur ON ur.nome_utente = st.nome_streamer
            WHERE EXTRACT(YEAR FROM AGE(ur.data_nascita)) BETWEEN 20 AND 35
              AND st.affiliate = true
        )
    )
GROUP BY
	ur.nome_utente,
    ur.nome,
    ur.cognome,
	EXTRACT(YEAR FROM AGE(ur.data_nascita))
ORDER BY
    numero_commenti DESC;

/*10 Per ogni administrator, restituire il numero dei canali sospesi i cui proprietari (gli streamers) NON sono affiliate. 
Scrivere la query utilizzando gli operatori insiemistici.*/

SELECT 
    ge.nome,
    ge.cognome,
    COUNT(SUBQUERY.streamer) AS "Numero non affiliate bloccati"
FROM 
    gestore AS ge
LEFT JOIN (
    SELECT 
        bl.gestore,
        bl.streamer
    FROM 
        blocca AS bl
    INTERSECT
    SELECT 
        bl.gestore,
        st.nome_streamer
    FROM 
        blocca AS bl
    JOIN 
        streamer AS st ON bl.streamer = st.nome_streamer
    WHERE 
        st.affiliate = false
) AS subquery ON ge.id_gestore = subquery.gestore
GROUP BY 
    ge.nome, 
    ge.cognome

/*11 Per ogni categoria di video, restituire il numero totale di video, la durata media (in minuti) dei video e 
il numero medio di voti ricevuti per video (secondo la scala likert [1-10]). 
Ordinare il risultato in ordine decrescente per numero totale di video.*/

SELECT 
	cm.categoria as "Categoria",
	COUNT(vc.url_video_clip) as "Numero video",
	ROUND(AVG(vc.durata_minuti),0) as "Durata media",
	ROUND(AVG(avg_voto),2) as "Voto medio"
FROM
	contenuto_multimediale as cm
INNER JOIN
	video_clip as vc ON vc.url_video_clip = cm.url
LEFT JOIN(
	SELECT 
		contenuto,
		ROUND(AVG(voto),2) as avg_voto
	FROM
		vota
	GROUP BY
		contenuto
) as avg_voti ON avg_voti.contenuto = vc.url_video_clip
WHERE
	vc.tipologia = false
GROUP BY
	cm.categoria
ORDER BY
	"Voto medio" DESC;
	
/*12 Per ogni streamer che ha almeno 5 video pubblicati, restituire il nome, cognome, età (in anni), 
numero totale di video pubblicati e il numero medio di commenti per video. 
Ordinare il risultato in ordine decrescente per numero totale di video pubblicati.*/

SELECT 
	ur.nome as "Nome",
	ur.cognome as "Cognome",
	EXTRACT(year FROM AGE(ur.data_nascita))as "Età",
	COUNT(vc.url_video_clip) as "Numero video",
	ROUND(AVG(num_comm),2) as "Media commenti"
FROM
	video_clip as vc
INNER JOIN
	contiene as co ON co.contenuto = vc.url_video_clip
LEFT JOIN(
	SELECT 
		com.contenuto,
		con.proprietario,
		COUNT(com.utente) as num_comm
	FROM 
		commenta as com
	INNER JOIN
		contiene as con ON con.contenuto = com.contenuto
	GROUP BY
		com.contenuto,	
		con.proprietario
) as num_commenti ON num_commenti.proprietario = co.proprietario 
INNER JOIN
	utente_registrato AS ur ON ur.nome_utente = co.proprietario
WHERE
	vc.tipologia = false
GROUP BY
	ur.nome_utente
HAVING
	COUNT(vc.url_video_clip) >= 5
ORDER BY
	"Numero video" DESC;

/*13 Per ogni categoria di video, restituire il numero di video, la durata media (in minuti) dei video 
e il numero medio di spettatori per video. 
Considerare solo le categorie con almeno 2 video pubblicati. 
Ordinare il risultato in ordine decrescente per numero medio di spettatori.*/

SELECT 
	cm.categoria as "Categoria",
	COUNT(vc.url_video_clip) as "Numero di video",
	ROUND(AVG(vc.durata_minuti),0) as "Durata media video",
	ROUND(AVG(vc.numero_views),0) as "Numero medio spettatori"
FROM 
	video_clip as vc
INNER JOIN
	contenuto_multimediale as cm ON cm.url = vc.url_video_clip
WHERE 
	vc.tipologia = false
GROUP BY
	cm.categoria
HAVING 
	COUNT(vc.url_video_clip) >=2
ORDER BY
	"Numero medio spettatori" DESC;

/*14 Per ogni streamer di età inferiore ai 40 anni che ha almeno 3 video pubblicati, restituire il nome, cognome, età (in anni), 
numero totale di video pubblicati e il numero medio di visualizzazioni per video. 
Ordinare il risultato in ordine crescente per età.*/

SELECT 
    ur.nome AS "Nome",
    ur.cognome AS "Cognome",
    EXTRACT(year FROM AGE(ur.data_nascita)) AS "Età",
    num_video.num_vid AS "Numero di video pubblicati",
    num_video.num_view AS "Numero medio di visualizzazioni per video"
FROM
    streamer AS st
INNER JOIN
    utente_registrato AS ur ON ur.nome_utente = st.nome_streamer
LEFT JOIN (
    SELECT 
        co.proprietario,
        COUNT(vc.url_video_clip) AS num_vid,
        ROUND(AVG(vc.numero_views)) AS num_view
    FROM
        video_clip AS vc
    INNER JOIN
        contiene AS co ON co.contenuto = vc.url_video_clip
    WHERE
        vc.tipologia = false
    GROUP BY
        co.proprietario
) AS num_video ON num_video.proprietario = st.nome_streamer
WHERE 
    EXTRACT(year FROM AGE(ur.data_nascita)) < 40
GROUP BY
    ur.nome,
    ur.cognome,
    ur.data_nascita,
    num_video.num_vid,
    num_video.num_view
HAVING
    num_video.num_vid >= 3
ORDER BY
    "Età" ASC;

/*15 Per ogni streamer che ha almeno 2 video con una media di voti superiore a 8, restituire il nome, cognome, età (in anni), 
numero di video con media di voti > 8 e la media delle medie di voti dei suoi video. 
Ordinare il risultato in ordine decrescente per numero di video con media di voti > 8.*/

SELECT 
	ur.nome as "Nome",
	ur.cognome as "Cognome",
	EXTRACT(year FROM AGE(ur.data_nascita)) as "Età",
	ROUND(AVG(voti_alti.avg_voto),2) as "Voto medio",
	COUNT(voti_alti.avg_voto) as "Numero di voti > 8"
FROM
	streamer as st
INNER JOIN 
	utente_registrato as ur ON st.nome_streamer = ur.nome_utente
INNER JOIN (
	SELECT 
		vo.streamer,
		vo.contenuto,
		ROUND(AVG(voto),2) avg_voto
	FROM 
		vota as vo
	INNER JOIN
		video_clip as vc ON vc.url_video_clip = vo.contenuto
	WHERE
		vc.tipologia = false
	GROUP BY
		vo.streamer,
		vo.contenuto
	HAVING
		ROUND(AVG(voto),2) > 8
) as voti_alti ON voti_alti.streamer = st.nome_streamer
GROUP BY
	st.nome_streamer,
	ur.nome,
	ur.cognome,
	EXTRACT(year FROM AGE(ur.data_nascita))
HAVING
	COUNT(voti_alti.avg_voto) > 2
ORDER BY
	COUNT(voti_alti.avg_voto) DESC;

/*16 Restituire il nome e cognome degli streamer che hanno pubblicato almeno un video ma non hanno ricevuto nessun voto.
Usare gli operatori insiemistici.*/

SELECT 
	ur.nome as "Nome",
	ur.cognome as "Cognome"
FROM
	streamer as st
INNER JOIN
	utente_registrato as ur ON ur.nome_utente = st.nome_streamer
INNER JOIN(
	SELECT 
		co.proprietario,
		COUNT(vc.url_video_clip) as num_vid
	FROM
		video_clip as vc
	INNER JOIN
		contiene as co ON co.contenuto = vc.url_video_clip
	WHERE 
		vc.tipologia = false
	GROUP BY
		co.proprietario
) as num_video ON num_video.proprietario = st.nome_streamer
GROUP BY
	ur.nome,
	ur.cognome,
	num_video.num_vid
HAVING 
	num_video.num_vid >= 1
EXCEPT
SELECT 
	ur.nome as "Nome",
	ur.cognome as "Cognome"
FROM
	streamer as st
INNER JOIN
	utente_registrato as ur ON ur.nome_utente = st.nome_streamer
INNER JOIN (
	SELECT 
		streamer,
		COUNT(voto)
	FROM
		vota
	INNER JOIN
		video_clip ON video_clip.url_video_clip = vota.contenuto
	WHERE 
		video_clip.tipologia = false
	GROUP BY
		streamer
) as streamer_votati ON streamer_votati.streamer = st.nome_streamer

/*17 Restituire il nome e cognome degli utenti che hanno votato video solo di utenti che sono affiliati 
e hanno pubblicato almeno 5 video.
Usare gli operatori insiemistici.*/

SELECT
    ur.nome,
    ur.cognome
FROM
    utente_registrato AS ur
INNER JOIN (
    SELECT 
        vo.follower
    FROM
        vota AS vo
    INNER JOIN
        streamer AS st ON st.nome_streamer = vo.streamer
    INNER JOIN (
        SELECT 
            co.proprietario,
            COUNT(vc.url_video_clip) AS num_vid
        FROM
            video_clip AS vc
        INNER JOIN
            contiene AS co ON co.contenuto = vc.url_video_clip
        WHERE
            vc.tipologia = false
        GROUP BY
            co.proprietario
        HAVING
            COUNT(vc.url_video_clip) >= 5
    ) AS st_5video ON st_5video.proprietario = st.nome_streamer
    WHERE
        st.affiliate = true
    GROUP BY
        vo.follower
) AS valid_voters ON valid_voters.follower = ur.nome_utente
EXCEPT
SELECT
    ur.nome,
    ur.cognome
FROM
    utente_registrato AS ur
INNER JOIN (
    SELECT 
        vo.follower
    FROM
        vota AS vo
    LEFT JOIN (
        SELECT 
            st.nome_streamer,
            st.affiliate,
            COUNT(vc.url_video_clip) AS num_vid
        FROM
            streamer AS st
        LEFT JOIN
            contiene AS co ON co.proprietario = st.nome_streamer
        LEFT JOIN
            video_clip AS vc ON vc.url_video_clip = co.contenuto
        WHERE
            vc.tipologia = false
        GROUP BY
            st.nome_streamer,
            st.affiliate
    ) AS streamer_videos ON streamer_videos.nome_streamer = vo.streamer
    WHERE
        streamer_videos.affiliate = false OR streamer_videos.num_vid < 5
    GROUP BY
        vo.follower
) AS invalid_voters ON invalid_voters.follower = ur.nome_utente;

/*18 Restituire il nome e cognome degli utenti che hanno votato almeno un video con un voto di 10 
e hanno commentato almeno un video.
Usare gli operatori insiemistici.*/

SELECT 
    ur.nome,
    ur.cognome
FROM
    utente_registrato AS ur
WHERE
    ur.nome_utente IN (
        SELECT DISTINCT
            vo.follower
        FROM
            vota AS vo
        WHERE
            vo.voto = 10
    )
INTERSECT
SELECT 
    ur.nome,
    ur.cognome
FROM
    utente_registrato AS ur
WHERE
    ur.nome_utente IN (
        SELECT DISTINCT
            com.utente
        FROM
            commenta AS com
    );

/*Per ogni streamer restituire il follower più giovane e abbonato. Ordinare in ordine decrescente di età del follower
Usare gli operatori insiemistici.*/

SELECT 
    st.nome_streamer,
    ef.id_follower,
    ef.eta
FROM
    streamer as st
INNER JOIN (
    SELECT 
        fo.nome_streamer,
        fo.id_follower,
        EXTRACT(YEAR FROM AGE(ur.data_nascita)) as eta
    FROM
        follower as fo
    INNER JOIN 
        utente_registrato as ur ON ur.nome_utente = fo.id_follower
    WHERE
        fo.abbonato = true
) as ef ON st.nome_streamer = ef.nome_streamer
INNER JOIN (
    SELECT 
        fo.nome_streamer,
        MIN(EXTRACT(YEAR FROM AGE(ur.data_nascita))) as min_eta
    FROM
        follower as fo
    INNER JOIN 
        utente_registrato as ur ON ur.nome_utente = fo.id_follower
    WHERE
        fo.abbonato = true
    GROUP BY
        fo.nome_streamer
) as mef ON ef.nome_streamer = mef.nome_streamer AND ef.eta = mef.min_eta
ORDER BY
    ef.eta DESC;




