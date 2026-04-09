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
- `index.html` = navigation
