# CONTEXTE PROJET — CRM ERC Conseil

## 0. LECTURE OBLIGATOIRE EN DÉBUT DE SESSION

Avant tout travail, Claude doit lire ces fichiers dans l'ordre :

1. https://github.com/op516/erc-crm/blob/main/CONTEXTE.md
2. https://github.com/op516/erc-crm/blob/main/SCHEMA.sql
3. https://github.com/op516/erc-crm/blob/main/style.css
4. https://github.com/op516/erc-crm/blob/main/deals.html
5. https://github.com/op516/erc-crm/blob/main/contacts.html
6. https://github.com/op516/erc-crm/blob/main/entreprises.html

Confirmer la lecture avant de commencer.

## 0bis. PROTOCOLE DE FIN DE SESSION

Quand Olivier signale qu'il quitte la conversation, Claude doit systématiquement produire :

1. **Synthèse** de ce qui a été fait dans la session
2. **CONTEXTE.md mis à jour** — refléter l'état réel du projet (fichiers créés, décisions prises, points en suspens)
3. **Prompt prêt à coller** pour la prochaine conversation
4. **Rappel** des fichiers à commiter dans GitHub si nécessaire

*Coller en début de chaque nouvelle conversation avec l'URL du repo*
*Dernière mise à jour : avril 2026*

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
* `index.html` = navigation uniquement
* Pas de router, pas de bundler, pas de build

## 4. RÈGLES QUE CLAUDE DOIT RESPECTER

* Spec de 3 lignes MAX avant chaque fonctionnalité
* Coder uniquement ce qui est dans la spec, rien de plus
* Un seul fichier par session de travail
* Si Olivier dit "hors sujet" → arrêt immédiat, retour au cadre
* Pas de nouveaux services sans demande explicite
* Fin de session → produire la mise à jour de CONTEXTE.md

## 5. ÉTAT ACTUEL DU PROJET

### Fichiers en place
* `SCHEMA.sql` — schéma défini et **exécuté dans Supabase** ✓
* `style.css` — charte graphique partagée ✓
* `supabase-client.js` — client Supabase partagé ✓
* `deals.html` — Kanban + liste, drag & drop, Supabase ✓ (CSS encore intégré, pas encore migré vers style.css)
* `contacts.html` — liste + filtres + drawer CRUD, branché sur style.css ✓

### Pages restantes à construire
* `entreprises.html`
* `activites.html`

## 6. CHARTE GRAPHIQUE — style.css

Toutes les nouvelles pages doivent inclure dans leur `<head>` :
```html
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="style.css" />
```
Aucun bloc `<style>` intégré — sauf CSS strictement spécifique à la page (ex: colonnes Kanban).

### Tokens principaux
* Fond topbar : `#172b4d`
* Bleu action : `#0052cc`
* Fond page : `#f4f5f7`
* Texte principal : `#172b4d`
* Texte secondaire : `#6b778c`
* Police : DM Sans 400/500/600

## 7. PASSE DE COHÉRENCE CSS — À FAIRE EN FIN DE PROJET

Quand toutes les pages seront construites, prévoir une session dédiée pour :
* Migrer `deals.html` vers `style.css` (supprimer son `<style>` intégré)
* Vérifier la cohérence visuelle de toutes les pages
* Livrer tous les fichiers mis à jour en une seule fois

## 8. PIPELINE ERC

qualification → diagnostic → valorisation →
recherche → négociation → closing → perdu

## 9. CE QU'ON NE FAIT PAS

* Pas de reporting complexe
* Pas de téléphonie
* Pas de marketplace
* Pas de clone Pipedrive complet
* Pas d'architecture multi-fichiers .js complexe
