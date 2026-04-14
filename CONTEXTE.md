# CONTEXTE PROJET — CRM ERC Conseil

*Dernière mise à jour : avril 2026*

## 0. LECTURE OBLIGATOIRE EN DÉBUT DE SESSION

Avant tout travail, Claude doit lire ces fichiers via `web_fetch` sur les URLs **raw** :

1. https://raw.githubusercontent.com/op516/erc-crm/main/CONTEXTE.md
2. https://raw.githubusercontent.com/op516/erc-crm/main/SCHEMA.sql
3. https://raw.githubusercontent.com/op516/erc-crm/main/style.css
4. https://raw.githubusercontent.com/op516/erc-crm/main/deals.html
5. https://raw.githubusercontent.com/op516/erc-crm/main/contacts.html
6. https://raw.githubusercontent.com/op516/erc-crm/main/entreprises.html
7. https://raw.githubusercontent.com/op516/erc-crm/main/activites.html
8. https://raw.githubusercontent.com/op516/erc-crm/main/index.html

⚠️ `index.html` utilise une URL différente (`refs/heads/main` au lieu de `main`) — toujours utiliser cette URL pour ce fichier.

**Règles strictes :**
- Utiliser exclusivement les URLs `raw.githubusercontent.com`
- Si un fichier échoue → réessayer une fois avant de signaler
- Ne jamais conclure qu'un fichier est absent sans avoir tenté l'URL raw
- Confirmer la lecture de chaque fichier avant de commencer le travail
- Si Olivier colle un fichier directement dans le chat → c'est la version de référence, prioritaire sur GitHub

## 0bis. PROTOCOLE DE FIN DE SESSION

Quand Olivier signale qu'il quitte la conversation, Claude doit systématiquement produire :

1. **Synthèse** de ce qui a été fait dans la session
2. **CONTEXTE.md mis à jour** — refléter l'état réel du projet (fichiers créés, décisions prises, points en suspens)
3. **Prompt prêt à coller** pour la prochaine conversation
4. **Rappel** des fichiers à commiter dans GitHub si nécessaire

## 0ter. RÈGLES DE MISE À JOUR DU CONTEXTE

- Ne jamais noter une page comme "non migrée" ou "à faire" sans avoir vérifié le fichier réel
- Si un doute existe sur l'état d'un fichier → le refetcher depuis GitHub avant de conclure
- Le CSS local dans un fichier HTML n'est PAS une erreur : chaque page a son propre `<style>` pour le CSS spécifique (kanban, slide-over, cards…). Ce n'est pas une migration incomplète.
- La migration vers style.css signifie : `<link rel="stylesheet" href="style.css" />` présent + topbar standard `<div class="topbar">` utilisée

## 1. QUI ET POURQUOI

Olivier Pichon, cabinet ERC Conseil, transmission d'entreprise.
Objectif : apprendre à coder en construisant des vrais outils utiles.
Stack identique à ComptaFlow — réutilisation directe.

## 2. STACK FIXE — NE PAS CHANGER

* Base de données : Supabase (PostgreSQL)
* Hébergement : Vercel
* Versionning : GitHub (https://github.com/op516/erc-crm)
* Frontend : HTML / CSS / JS vanilla
* PAS de framework, PAS de librairie externe, PAS de nouveau service

## 3. ARCHITECTURE DÉCIDÉE

* Un fichier HTML par page
* Un seul `supabase-client.js` partagé
* Un seul `style.css` partagé — toutes les pages doivent l'appeler
* Chaque page peut avoir un bloc `<style>` local pour son CSS spécifique — c'est normal et intentionnel
* `index.html` = tableau de bord (dashboard)
* Pas de router, pas de bundler, pas de build

## 4. RÈGLES QUE CLAUDE DOIT RESPECTER

* Spec de 3 lignes MAX avant chaque fonctionnalité
* Coder uniquement ce qui est dans la spec, rien de plus
* Un seul fichier par session de travail
* Si Olivier dit "hors sujet" → arrêt immédiat, retour au cadre
* Pas de nouveaux services sans demande explicite
* Fin de session → produire la mise à jour de CONTEXTE.md

## 5. ÉTAT ACTUEL DU PROJET

### Fichiers en place — TOUS MIGRÉS vers style.css ✓

* `SCHEMA.sql` — schéma défini et exécuté dans Supabase ✓
* `style.css` — charte graphique partagée ✓
* `supabase-client.js` — client Supabase partagé ✓
* `login.html` — page d'authentification Supabase, gère la redirection si déjà connecté ✓
* `index.html` — tableau de bord (dashboard) ✓ — voir section 7 — **à recommitter (écrasé)**
* `contacts.html` — liste + filtres + drawer CRUD ✓
* `entreprises.html` — liste (table + cards) + drawer CRUD complet + contacts liés + modal activité rapide ✓ — **mis à jour cette session**
* `deals.html` — Kanban + liste + slide-over édition complète + modal nouveau deal + modal activité ✓
* `activites.html` — agenda + filtres période/type + vue tableau + drawer exécution ✓
* `produits.html` — liste + filtres + drawer CRUD + toggle actif/inactif ✓

### Pages décidées comme non nécessaires
* `leads.html` — décision de ne pas utiliser les leads

## 6. CE QUI A CHANGÉ DANS ENTREPRISES.HTML (cette session)

L'ancien slide-over lecture seule + la modal de création simplifiée (7 champs) ont été **remplacés** par un **drawer CRUD unique** sur le modèle de `contacts.html` :

- Clic sur une ligne → `openDrawer(id)` : formulaire pré-rempli
- Bouton "+ Ajouter" → `openDrawer(null)` : formulaire vide
- **Champs** : Nom*, Sigle, Secteur, Ville, CA annuel, Effectif, Statut, Département, Commentaire (= les 9 champs de l'ancienne modal, pas plus)
- **Header drawer** : titre dynamique + bouton "+ Activité" (masqué en création) + Supprimer (masqué en création) + Enregistrer + ×
- **Section "Contacts liés"** (visible uniquement en édition) : affiche les contacts avec `entreprise_id = currentId`, bouton × pour détacher, select + bouton "Rattacher" pour lier un contact existant
- **Modal activité rapide** : conservée à l'identique
- **Toolbar** : `h1` conservé, search ramené à gauche (suppression du `flex:1` sur h1)
- `allContacts` chargé au `init()` en parallèle des entreprises pour alimenter la section contacts liés sans requête supplémentaire à l'ouverture du drawer

## 7. NAVIGATION — ÉTAT FINAL

Toutes les pages ont la même topbar avec la nav complète dans cet ordre :

```
Accueil · Contacts · Entreprises · Deals · Activités · Produits
```

Chaque page a `class="active"` sur son propre lien.
`index.html` a `class="active"` sur Accueil.
Le bouton Déconnexion est présent uniquement sur `index.html` (topbar droite).

## 8. DASHBOARD index.html

Construit avec 4 zones :

**KPI cards (cliquables)** :
- Deals ouverts → liens vers deals.html
- Valeur pondérée (valeur × probabilité / 100 — 0 si non renseigné) → deals.html
- Activités en retard (rouge si > 0) → activites.html
- Contacts → contacts.html

**Pipeline deals** (cliquable → deals.html) :
- Barre horizontale par étape avec couleurs du Kanban
- Valeur pondérée par étape
- Exclut l'étape "perdu"

**Activités urgentes** (cliquable → activites.html) :
- En retard + aujourd'hui, max 7
- Date en rouge si retard

**Deals récents** (cliquable → deals.html) :
- 8 derniers deals ouverts sur 2 colonnes

## 9. AUTHENTIFICATION — À ACTIVER EN PROD

`login.html` est créée et fonctionnelle. Pour activer en prod :

1. Créer l'utilisateur dans Supabase : Authentication → Users → Invite user
2. Ajouter ce guard silencieux en haut du `<script>` de chaque page (index, contacts, entreprises, deals, activites, produits) :

```js
(async () => {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) window.location.href = 'login.html';
})();
```

`login.html` gère déjà la redirection automatique si déjà connecté.

## 10. PIPELINE ERC

qualification → diagnostic → valorisation →
recherche → négociation → closing → perdu

## 11. CHARTE GRAPHIQUE — style.css

Toutes les pages incluent dans leur `<head>` :
```html
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="style.css" />
```

### Tokens principaux
* Fond topbar : `#172b4d`
* Bleu action : `#0052cc`
* Fond page : `#f4f5f7`
* Texte principal : `#172b4d`
* Texte secondaire : `#6b778c`
* Police : DM Sans 400/500/600

## 12. CE QU'ON NE FAIT PAS

* Pas de reporting complexe
* Pas de téléphonie
* Pas de marketplace
* Pas de clone Pipedrive complet
* Pas d'architecture multi-fichiers .js complexe
* Pas de leads (décision prise)
