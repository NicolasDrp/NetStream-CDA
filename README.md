# **NetStream-CDA**
***Dans le cadre de notre formation de Concepteur Développeur d'Applications, nous nous voyons confié le projet suivant :***

En tant que développeur passionné par le cinéma, vous souhaitez créer votre propre plateforme de streaming. Avant de construire le site web, vous devez mettre en place une base de données pour stocker les informations relatives aux films, acteurs, réalisateurs, et utilisateurs.
___
### *Technologies utilisées*

![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
___
## *Installation du projet*
*Commandes à utiliser pour installer le projet*
```
git clone https://github.com/NicolasDrp/NetStream-CDA.git
```

Dans le dossier racine :

```cmd
docker compose up
```

Utiliser un SGBD pour interagir avec la base de données;

Il y a deux roles:

- NetStream -> MDP = Oxymore

- Client  -> MDP = MDPclient


## *Requêtes demandées*

- **Les titres et dates de sortie des films du plus récent au plus ancien**

```sql
SELECT title,year FROM public."Movie" ORDER BY year;
```

- **Les noms, prénoms et âges des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique**

```sql
SELECT firstname, lastname, DATE_PART('year', now()::date) - DATE_PART('year', birthday::date) as age 
FROM public."Actor" WHERE DATE_PART('year', now()::date) - DATE_PART('year', birthday::date) > 30 ORDER BY lastname ASC;
```

- **La liste des acteurs/actrices principaux pour un film donné**

```sql
SELECT lastname,firstname 
FROM public."Actor" INNER JOIN public."Act" on "Actor".id_actor = "Act".id_actor 
WHERE "Act".id_movie IN (SELECT id_movie FROM public."Movie" WHERE title = 'L Odyssée du Futur');
```

- **La liste des films pour un acteur/actrice donné**

```sql
SELECT title 
	FROM public."Movie" 
	INNER JOIN public."Act" on "Movie".id_movie = "Act".id_movie 
	WHERE "Act".id_actor IN 
		(SELECT id_actor FROM public."Actor" 
		 WHERE firstname = 'florian' AND lastname = 'poteaux');
```

- **Ajouter un film**

```sql
INSERT INTO public."Movie"(
	title, duration, year)
	VALUES ('film super', 234, 1989);
```


- **Ajouter un acteur/actrice**

```sql
INSERT INTO public."Actor"(
	firstname, lastname, birthday)
	VALUES ('Phlorient','Pauteau','2013-04-05');
```

- **Modifier un film**

```sql
UPDATE public."Movie"
	SET title='Nouveau Titre', duration=123, year=2014
	WHERE title = 'film super';
```

- **Supprimer un acteur/actrice**

```sql
DELETE FROM public."Actor"
	WHERE id_actor = 13;
```

- **Afficher les 3 derniers acteurs/actrices ajouté(e)s**

```sql
SELECT firstname, lastname,created_at
	FROM public."Actor" ORDER BY created_at DESC LIMIT 3;
```

___
### *Contributeurs*
___ 

-***Drapier Nicolas***

<a href="[https://github.com/NicolasDrp]"><img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white"></img></a>
<a href="[www.linkedin.com/in/nicolas-drapier]"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"></img></a>