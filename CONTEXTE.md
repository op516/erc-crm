# CONTEXTE PROJET — CRM ERC Conseil
*Dernière mise à jour : avril 2026*
*Ce fichier est la source de vérité. Claude le lit en début de chaque session avant tout.*

---

## 1. QUI ET POURQUOI

Olivier Pichon, cabinet ERC Conseil, transmission d'entreprise.
Objectif : apprendre à coder en construisant des vrais outils utiles.
Stack identique à ComptaFlow — réutilisation directe.

---

## 2. STACK FIXE — NE PAS CHANGER

- Base de données : Supabase (PostgreSQL)
- Hébergement : Vercel
- Versionning : GitHub — https://github.com/op516/erc-crm (repo PUBLIC)
- Frontend : HTML / CSS / JS vanilla
- PAS de framework, PAS de librairie externe, PAS de nouveau service
- Supabase CDN : `https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2`
- Typo : DM Sans (Google Fonts)

---

## 3. ARCHITECTURE DÉCIDÉE

- Un fichier HTML par page
- Un seul `supabase-client.js` partagé à la racine
- Un seul `style.css` partagé à la racine
- `index.html` = navigation uniquement
- Pas de router, pas de bundler, pas de build

---

## 4. SÉCURITÉ — RÈGLES ABSOLUES

- Le repo est PUBLIC → aucune clé, aucun secret dans aucun fichier
- `supabase-client.js` contient la clé `anon` Supabase — c'est acceptable
  UNIQUEMENT si RLS (Row Level Security) est activé sur toutes les tables
- RLS doit être activé et configuré AVANT toute page fonctionnelle
- `.env` est dans `.gitignore` — ne jamais le pousser
- Claude ne propose jamais de mettre une clé en dur dans un fichier versionné

---

## 5. ÉTAT ACTUEL DU PROJET

### Base de données Supabase
- Schéma défini dans SCHEMA.sql
- Tables créées dans Supabase : À CONFIRMER PAR OLIVIER
- RLS activé : À CONFIRMER PAR OLIVIER

### Fichiers dans le repo GitHub
- CONTEXTE.md ✓
- SCHEMA.sql ✓
- README.md ✓
- .gitignore ✓
- supabase-client.js : À CONFIRMER
- style.css : À CONFIRMER
- index.html : À CONFIRMER
- deals.html : existe en local, PAS encore pushé sur GitHub
- entreprises.html : version draft produite, à reprendre après lecture de deals.html

### Fichiers existants en local chez Olivier (pas encore sur GitHub)
- deals.html (page fonctionnelle, sert de référence visuelle pour toutes les autres pages)
- Possiblement : supabase-client.js, style.css, index.html

---

## 6. PIPELINE ERC

qualification → diagnostic → valorisation → recherche → négociation → closing → perdu

---

## 7. RÈGLES QUE CLAUDE DOIT RESPECTER

### Avant de coder quoi que ce soit
- Lire CONTEXTE.md et SCHEMA.sql depuis GitHub
- Lire TOUS les fichiers HTML existants dans le repo avant d'en créer un nouveau
- Si un fichier de référence n'est pas sur GitHub → bloquer et demander le push avant de continuer
- Ne jamais inventer un style : copier exactement ce qui existe dans les pages déjà livrées

### Pendant le développement
- Spec de 3 lignes MAX validée par Olivier avant de coder
- Coder uniquement ce qui est dans la spec, rien de plus
- Un seul fichier produit par session
- Si Olivier dit "hors sujet" → arrêt immédiat, retour au cadre
- Pas de nouveaux services sans demande explicite
- Ne jamais proposer une architecture multi-fichiers JS

### Livraison d'une page
- Donner le fichier HTML complet
- Donner les instructions complètes pour que ça marche :
  étapes Supabase si nécessaire, ordre de mise en place, points de vérification
- Ne jamais livrer une page sans que les prérequis soient listés et validés

### Fin de session OBLIGATOIRE
- Produire le CONTEXTE.md mis à jour avec l'état réel du projet
- Olivier pousse ce fichier sur GitHub avant de fermer la session
- Si CONTEXTE.md n'est pas pushé → la session n'est pas terminée

---

## 8. STRATÉGIE DE DÉVELOPPEMENT

- Une conversation = un sujet (ex : "base de données", "deals.html", "entreprises.html")
- Ne pas mélanger les sujets dans une même conversation
- Ordre obligatoire pour chaque nouvelle page :
  1. Lire toutes les pages existantes dans le repo
  2. Valider la spec en 3 lignes
  3. Coder
  4. Livrer avec instructions complètes
  5. Mettre à jour CONTEXTE.md

---

## 9. RÉFÉRENCE VISUELLE

- `deals.html` est la page de référence pour le style de toutes les autres pages
- Toute nouvelle page doit avoir la même nav, les mêmes couleurs, la même typographie
- Claude ne code pas une nouvelle page sans avoir lu deals.html dans le repo

---

## 10. CE QU'ON NE FAIT PAS

- Pas de reporting complexe
- Pas de téléphonie
- Pas de marketplace
- Pas de clone Pipedrive complet
- Pas d'architecture multi-fichiers JS complexe
- Pas de clés API dans le code versionné
- Pas de nouvelle page sans référence visuelle lue
