# CONTEXTE PROJET — CRM ERC Conseil

*Coller en début de chaque nouvelle conversation avec l'URL du repo*
*Dernière mise à jour : avril 2026*

## 1. QUI ET POURQUOI

Olivier Pichon, cabinet ERC Conseil, transmission d'entreprise.
Objectif : apprendre à coder en construisant des vrais outils utiles.
Stack identique à ComptaFlow — réutilisation directe.

## 2. STACK FIXE — NE PAS CHANGER

* Base de données : Supabase (PostgreSQL)
* Hébergement : Vercel
* Versionning : GitHub (ce repo : https://github.com/op516/erc-crm)
* Frontend : HTML / CSS / JS vanilla
* PAS de framework, PAS de librairie externe, PAS de nouveau service

## 3. ARCHITECTURE DÉCIDÉE

* Un fichier HTML par page
* Un seul supabase-client.js partagé (pas encore créé — les clés sont inline pour l'instant)
* Un seul style.css (pas encore créé — styles inline pour l'instant)
* index.html = navigation uniquement (pas encore créé)
* Pas de router, pas de bundler, pas de build

## 4. ACCÈS PROJET

* **GitHub** : https://github.com/op516/erc-crm
* **Site en production** : https://crm.erc-conseil.fr
* **Supabase URL** : https://vwlwureqwskxpsihxewr.supabase.co
* **Supabase KEY** : sb_publishable_hOaMcxwQoXVt7PBcdLzWlg_zgiJ4T8a
* **Vercel** : projet connecté au repo GitHub, déploiement automatique sur push main

## 5. RÈGLES QUE CLAUDE DOIT RESPECTER

* Spec de 3 lignes MAX avant chaque fonctionnalité
* Coder uniquement ce qui est dans la spec, rien de plus
* Un seul fichier par session de travail
* Si Olivier dit "hors sujet" → arrêt immédiat, retour au cadre
* Pas de nouveaux services sans demande explicite
* Fin de session → produire la mise à jour de CONTEXTE.md
* Toujours donner le code directement dans le chat, pas de fichier à télécharger

## 6. ÉTAT ACTUEL DU PROJET

### Fichiers en production
* **deals.html** ✅ — Kanban drag & drop par étape pipeline, toggle vue liste/kanban, connexion Supabase, mise à jour étape en base sur drop, toast notifications, rollback sur erreur

### Fichiers à créer
* entreprises.html
* contacts.html
* activites.html
* index.html (navigation)

### Base de données
* Schéma créé dans Supabase ✅
* RLS désactivé sur toutes les tables ✅
* Données : vide pour l'instant (1 deal de test)
* Données Pipedrive : exportées en CSV, en attente d'import

## 7. PIPELINE ERC

qualification → diagnostic → valorisation →
recherche → négociation → closing → perdu

## 8. DESIGN SYSTEM EN PLACE (deals.html comme référence)

* Fond : #eeece8
* Surface : #ffffff
* Typographie : DM Sans + DM Mono (Google Fonts)
* Couleurs étapes : qualification #3b82f6, diagnostic #8b5cf6, valorisation #ec4899, recherche #f97316, negociation #eab308, closing #22c55e, perdu #ef4444
* Topbar sticky blanche avec logo ERC, toggle vue, chip compteur
* Cards blanches avec border #e2ddd8 et ombre légère
* Badges étapes : pastels colorés avec point de couleur

## 9. CE QU'ON NE FAIT PAS

* Pas de reporting complexe
* Pas de téléphonie
* Pas de marketplace
* Pas de clone Pipedrive complet
* Pas d'architecture multi-fichiers .js complexe
* Pas de dark mode
