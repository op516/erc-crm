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

**Règles strictes :**
- Utiliser exclusivement les URLs `raw.githubusercontent.com`
- Si un fichier échoue → réessayer une fois avant de signaler
- Confirmer la lecture de chaque fichier avant de commencer le travail
- **Toujours utiliser `create_file` pour écrire du HTML** — ne jamais utiliser bash heredoc (bloque)

## 0bis. PROTOCOLE DE FIN DE SESSION

Quand Olivier signale qu'il quitte, Claude produit :
1. CONTEXTE.md mis à jour
2. Prompt prêt à coller pour la prochaine session
3. Rappel des fichiers à commiter

## 1. QUI ET POURQUOI

Olivier Pichon, cabinet ERC Conseil, transmission d'entreprise.
Objectif : apprendre à coder en construisant des vrais outils utiles.

## 2. STACK FIXE — NE PAS CHANGER

- Base de données : Supabase (PostgreSQL)
- Hébergement : Vercel
- Versionning : GitHub (https://github.com/op516/erc-crm)
- Frontend : HTML / CSS / JS vanilla
- PAS de framework, PAS de librairie externe, PAS de nouveau service

## 3. ARCHITECTURE DÉCIDÉE

- Un fichier HTML par page
- Un seul `supabase-client.js` partagé
- Un seul `style.css` partagé — toutes les pages doivent l'appeler
- Pas de router, pas de bundler, pas de build

## 4. RÈGLES QUE CLAUDE DOIT RESPECTER

- Spec de 3 lignes MAX avant chaque fonctionnalité
- Coder uniquement ce qui est dans la spec, rien de plus
- Un seul fichier par session de travail si possible
- Fin de session → produire la mise à jour de CONTEXTE.md

## 5. ÉTAT ACTUEL DU PROJET

### Fichiers livrés — à commiter si pas encore fait
- `deals.html` ✓
- `contacts.html` ✓
- `entreprises.html` ✓
- `activites.html` ✓

### deals.html — fonctionnalités complètes
- Kanban + liste, drag & drop, Supabase UPDATE optimiste
- Toggle vue Kanban / Liste
- Subbar filtres par étape (vue liste)
- Recherche globale (titre, entreprise, contact)
- Bouton **"+ Nouveau deal"** → modal création (titre, étape, entreprise, contact, valeur)
- **Slide-over éditable** au clic sur carte ou ligne :
  - Titre modifiable dans le header
  - Section Interlocuteurs : selects Entreprise + Contact (pré-remplis si déjà liés)
  - Section Pipeline : Étape, Statut, Probabilité
  - Section Financier : Valeur HT, TVA 20% calculée live, TTC
  - Section Dates : Échéance, Date réalisation
  - Note interne
  - Bouton **"+ Activité"** dans le header meta (accès direct sans scroll)
  - Onglet Activités : liste + bouton "+ Créer une activité" en haut
  - Onglet Notes : liste + textarea ajout note
  - Enregistrer → UPDATE Supabase + fermeture + rafraîchissement liste/kanban avec joins
- Migré vers style.css, CSS inline réduit au strict spécifique

### contacts.html — fonctionnalités complètes
- Liste + filtres (catégorie, origine) + recherche
- Drawer CRUD complet (créer, modifier, supprimer)
- Bouton **"+ Activité"** dans le drawer (visible sur contact existant uniquement)
- Modal activité : type, date, sujet, heure, deal associé, note
- Branché sur style.css

### entreprises.html — fonctionnalités complètes
- Liste + cards, toggle vue, recherche
- Slide-over détail complet (infos, coordonnées, CRM, flags, contacts liés)
- Modal ajout entreprise
- Bouton **"+ Activité"** dans le header du slide-over
- Modal activité : type, date, sujet, heure, deal associé, note
- Migré vers style.css

### activites.html — fonctionnalités complètes
- Vue tableau (défaut) + vue cartes
- **Filtre par défaut : "Toutes"** (pas "En retard")
- Tabs période : En retard / Aujourd'hui / Cette semaine / Toutes
- Filtres type : Appel / RDV / Email / Tâche
- Recherche (sujet, deal, contact, entreprise)
- **Modal unifié création + modification** : tous champs éditables dont la date
- Mode édition : case "Activité réalisée" + historique notes liées
- Bouton Supprimer dans le modal (mode édition)
- Branché sur style.css

### Pages restantes à construire
- `produits.html` — **prochaine étape**
- `leads.html` — **décision : ne pas construire** (qualification = sas de leads)

### Passe à prévoir plus tard
- Harmonisation visuelle des menus (Olivier pas 100% satisfait, à préciser)
- Migration `entreprises.html` CSS (partiellement fait)

## 6. PRODUITS — DÉCISIONS MÉTIER

Deux usages, un seul champ `categorie` dans la table `produits` :

| categorie | Usage |
|-----------|-------|
| `'mission'` | Prestations catalogue : valorisation, préparation de cession, classeur d'urgence, audit… |
| `'actif'` | Une société en vente = un enregistrement produit. Regroupe les deals acquéreurs sur un même mandat. |

Le deal reste centré sur l'acquéreur (contact principal), le produit identifie l'actif qui l'intéresse.
Pas de modification du schéma nécessaire, `categorie TEXT` suffit.

### produits.html — spec à implémenter
- Liste des produits avec deux sections visuelles : Missions | Actifs en vente
- Filtrage par catégorie
- Formulaire création/modification (nom, categorie, description, prix_eur, taxe, actif)
- Possibilité de lier un produit à un deal depuis deals.html (à faire après produits.html)

## 7. PIPELINE ERC

qualification → diagnostic → valorisation →
recherche → négociation → closing → perdu

## 8. CHARTE GRAPHIQUE — style.css

```html
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style.css" />
```

### Tokens principaux
- Fond topbar : `#172b4d`
- Bleu action : `#0052cc`
- Fond page : `#f4f5f7`
- Texte principal : `#172b4d`
- Texte secondaire : `#6b778c`
- Police : DM Sans 400/500/600

### Menu de navigation — ordre sur toutes les pages
```
Contacts · Entreprises · Deals · Activités
```

## 9. CE QU'ON NE FAIT PAS

- Pas de reporting complexe
- Pas de téléphonie
- Pas de `leads.html`
- Pas d'architecture multi-fichiers .js complexe
- Pas de nouveaux services sans demande explicite
