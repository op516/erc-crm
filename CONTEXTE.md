# CONTEXTE PROJET — CRM ERC Conseil
*Coller en début de chaque nouvelle conversation avec l'URL du repo*
*Dernière mise à jour : avril 2026*

## 1. QUI ET POURQUOI
Olivier Pichon, cabinet ERC Conseil, transmission d'entreprise.
Objectif : apprendre à coder en construisant des vrais outils utiles.
Stack identique à ComptaFlow — réutilisation directe.
Projets prévus après le CRM : à définir.

## 2. STACK FIXE — NE PAS CHANGER
- Base de données : Supabase (PostgreSQL)
- Hébergement : Vercel
- Versionning : GitHub (ce repo : https://github.com/op516/erc-crm)
- Frontend : HTML / CSS / JS vanilla
- PAS de framework, PAS de librairie externe, PAS de nouveau service

## 3. ARCHITECTURE DÉCIDÉE
- Un fichier HTML par page
- Un seul supabase-client.js partagé
- Un seul style.css
- index.html = navigation uniquement
- Pas de router, pas de bundler, pas de build

## 4. RÈGLES QUE CLAUDE DOIT RESPECTER
- Spec de 3 lignes MAX avant chaque fonctionnalité
- Coder uniquement ce qui est dans la spec, rien de plus
- Un seul fichier par session de travail
- Si Olivier dit "hors sujet" → arrêt immédiat, retour au cadre
- Pas de nouveaux services sans demande explicite
- Fin de session → produire la mise à jour de CONTEXTE.md

## 5. ÉTAT ACTUEL DU PROJET
- Schéma base de données : défini dans SCHEMA.sql, pas encore créé dans Supabase
- Fichiers HTML : aucun créé
- Données Pipedrive : exportées en CSV, en attente d'import
- Prochaine étape : récupérer les en-têtes CSV Pipedrive pour valider le schéma

## 6. PIPELINE ERC
qualification → diagnostic → valorisation →
recherche → négociation → closing → perdu

## 7. CE QU'ON NE FAIT PAS
- Pas de reporting complexe
- Pas de téléphonie
- Pas de marketplace
- Pas de clone Pipedrive complet
- Pas d'architecture multi-fichiers .js complexe
