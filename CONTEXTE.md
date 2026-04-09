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
- PAS de framework, PAS de bundler, PAS de build step
- Supabase CDN : `https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2`
- Typo : DM Sans (Google Fonts)

---

## 3. ARCHITECTURE DÉCIDÉE

- Un fichier HTML par page
- Un seul `supabase-client.js` partagé à la racine
- Un seul `style.css` partagé à la racine (pas encore créé)
- `index.html` = navigation uniquement (pas encore créé)
- Pas de router, pas de bundler, pas de build step

### Ordre des scripts dans chaque HTML — CRITIQUE
```html
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="supabase-client.js"></script>
```
Le CDN doit toujours être chargé AVANT supabase-client.js.

---

## 4. SÉCURITÉ

### État actuel (phase développement — Olivier seul utilisateur)
- Les clés Supabase sont en clair dans supabase-client.js
- RLS activé sur entreprises avec politique "acces_total"
- C'est acceptable tant qu'Olivier est le seul utilisateur
- La clé utilisée est la clé `publishable` (anon) — conçue pour être exposée

### ⚠️ AVANT D'OUVRIR À D'AUTRES UTILISATEURS
- Revoir les politiques RLS table par table (restreindre par user_id)
- Mettre en place l'authentification Supabase
- Évaluer si le repo doit passer privé

### Règle absolue
- Claude ne propose jamais de mettre une clé service_role dans le code
- La clé publishable/anon est la seule acceptable dans le frontend

---

## 5. ÉTAT ACTUEL DU PROJET

### Fichiers dans le repo GitHub
- `.gitignore` ✓
- `CONTEXTE.md` ✓
- `README.md` ✓
- `SCHEMA.sql` ✓
- `supabase-client.js` ✓ (clés en clair, acceptable en dev)
- `deals.html` ✓ (fonctionnel, clés Supabase en dur dedans — à migrer vers supabase-client.js)
- `entreprises.html` ✓ (fonctionnel, connecté Supabase, testé)
- `style.css` : pas encore créé
- `index.html` : pas encore créé

### Base de données Supabase
- Table `entreprises` : créée ✓, RLS activé ✓, testé ✓
- Tables restantes à créer : `contacts`, `produits`, `leads`, `deals`, `activites`, `notes`, `documents`

### Maquette de référence
- `entreprises.html` est la maquette de référence visuelle pour toutes les pages suivantes
- Toute nouvelle page copie exactement son style (nav, couleurs, typo, composants)
- `deals.html` sera adapté au style d'entreprises.html lors d'une prochaine session

---

## 6. PIPELINE ERC

qualification → diagnostic → valorisation → recherche → négociation → closing → perdu

---

## 7. RÈGLES QUE CLAUDE DOIT RESPECTER

### En début de chaque session
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
- Donner les instructions complètes dans l'ordre pour que ça marche
- Lister tous les prérequis Supabase (table créée ? RLS activé ?)
- Ne jamais livrer une page sans que les prérequis soient validés

### Fin de session — OBLIGATOIRE
- Produire le CONTEXTE.md mis à jour avec l'état réel du projet
- Olivier pousse ce fichier sur GitHub avant de fermer la session
- Si CONTEXTE.md n'est pas pushé → la session n'est pas terminée

---

## 8. STRATÉGIE DE DÉVELOPPEMENT

- Une conversation = un sujet
- Ne pas mélanger les sujets dans une même conversation
- Ordre obligatoire pour chaque nouvelle page :
  1. Lire CONTEXTE.md et SCHEMA.sql
  2. Lire toutes les pages HTML existantes dans le repo
  3. Valider la spec en 3 lignes avec Olivier
  4. Vérifier les prérequis Supabase
  5. Coder
  6. Livrer avec instructions complètes
  7. Pousser CONTEXTE.md mis à jour

---

## 9. CE QU'ON NE FAIT PAS

- Pas de reporting complexe
- Pas de téléphonie
- Pas de marketplace
- Pas de clone Pipedrive complet
- Pas d'architecture multi-fichiers JS complexe
- Pas de clé service_role dans le code
- Pas de nouvelle page sans avoir lu les pages existantes dans le repo
- Pas de timing promis
