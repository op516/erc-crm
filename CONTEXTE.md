# CONTEXTE PROJET — CRM ERC Conseil

*Dernière mise à jour : avril 2026*

## PROMPT DE DÉMARRAGE — COLLER TEL QUEL EN DÉBUT DE NOUVELLE SESSION

```
Lis ces fichiers dans cet ordre via web_fetch, confirme chaque lecture, puis attends ma prochaine instruction :
https://raw.githubusercontent.com/op516/erc-crm/main/CONTEXTE.md
https://raw.githubusercontent.com/op516/erc-crm/main/SCHEMA.sql
https://raw.githubusercontent.com/op516/erc-crm/main/style.css
https://raw.githubusercontent.com/op516/erc-crm/main/deals.html
https://raw.githubusercontent.com/op516/erc-crm/main/contacts.html
https://raw.githubusercontent.com/op516/erc-crm/main/entreprises.html
https://raw.githubusercontent.com/op516/erc-crm/main/activites.html
```

---

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
* `SCHEMA.sql` — schéma défini et exécuté dans Supabase ✓
* `style.css` — charte graphique partagée ✓
* `supabase-client.js` — client Supabase partagé ✓
* `deals.html` — Kanban + liste, drag & drop ✓ (CSS intégré, pas encore migré vers style.css)
* `contacts.html` — liste + filtres + drawer CRUD, branché sur style.css ✓
* `entreprises.html` — en place, pas encore migré vers style.css
* `activites.html` — agenda commercial ✓ (branché sur style.css)
  - Vue tableau par défaut + vue cartes (toggle)
  - Onglets : En retard / Aujourd'hui / Cette semaine / Toutes
  - Filtres type : Appel / RDV / Email / Tâche
  - Tri par colonne (clic en-tête) dans la vue tableau
  - Drawer d'exécution au clic sur une ligne :
    * Historique notes du dossier lié (table `notes`)
    * Saisie nouvelle note → INSERT dans `notes`
    * "Marquer faite + créer la suivante" → UPDATE faite + ouvre modal pré-rempli
  - Modal création : type (requis), date (requis), sujet (optionnel), heure, deal, entreprise, contact, note
  - Associations : deal_id, entreprise_id, contact_id

### Table `deals` — colonnes ajoutées (ALTER TABLE exécuté en Supabase)
```sql
ALTER TABLE deals
  ADD COLUMN produit_id UUID REFERENCES produits(id),
  ADD COLUMN quantite INTEGER DEFAULT 1,
  ADD COLUMN remise DECIMAL(5,2) DEFAULT 0,
  ADD COLUMN taux_tva DECIMAL(5,2) DEFAULT 20.00,
  ADD COLUMN valeur_ht DECIMAL(12,2),
  ADD COLUMN date_realisation DATE,
  ADD COLUMN probabilite_reussite INTEGER DEFAULT 0;
```
- `valeur` existante = valeur TTC calculée (conservée pour compatibilité affichage actuel)
- `valeur_ht` = saisie manuelle OU calculée depuis produit × quantité × (1 - remise/100)
- `taux_tva` = hérité de `produits.taxe` si produit sélectionné, sinon liste FR (20/10/5.5/2.1/0%)
- Calcul TTC : valeur_ht × (1 - remise/100) × (1 + taux_tva/100)
- `probabilite_reussite` = 0-100, pour stats futures

### Pages restantes à construire
* `leads.html`

### Prochaine étape prioritaire : enrichir `deals.html`
- Cartes Kanban et lignes liste **cliquables** → slide-over (pattern entreprises.html)
- Slide-over deal : infos complètes + produit lié + calcul valeur HT/remise/TVA/TTC
- Onglets dans le slide-over : Activités liées / Notes liées
- Drawer notes/activités : même logique que activites.html

### Passe finale à prévoir (non prioritaire)
* Migrer `deals.html` et `entreprises.html` vers `style.css`
* Vérifier cohérence visuelle de toutes les pages

## 6. CHARTE GRAPHIQUE — style.css

Toutes les nouvelles pages doivent inclure dans leur `<head>` :
```html
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="style.css" />
```
Aucun bloc `<style>` intégré — sauf CSS strictement spécifique à la page.

### Tokens principaux
* Fond topbar : `#172b4d`
* Bleu action : `#0052cc`
* Fond page : `#f4f5f7`
* Texte principal : `#172b4d`
* Texte secondaire : `#6b778c`
* Police : DM Sans 400/500/600

## 7. CYCLE COMMERCIAL ERC

**Lead** → contact + produit potentiel, avant qualification (table `leads`, page `leads.html` à construire)
**Deal** → dossier actif après qualification (table `deals`, `deals.html`)
La table `leads` a un champ `deal_id` pour tracer la conversion lead → deal.
**Ne pas supprimer la table `leads`.**

Pipeline deals : qualification → diagnostic → valorisation → recherche → négociation → closing → perdu

## 8. CE QU'ON NE FAIT PAS

* Pas de reporting complexe
* Pas de téléphonie
* Pas de marketplace
* Pas de clone Pipedrive complet
* Pas d'architecture multi-fichiers .js complexe

## 9. POINTS EN SUSPENS

* **Leads dans activites.html** : la table `activites` n'a pas de `lead_id`.
  Quand on construira `leads.html`, prévoir :
  `ALTER TABLE activites ADD COLUMN lead_id UUID REFERENCES leads(id);`
  et ajouter le dropdown lead dans le modal de création d'activité.
