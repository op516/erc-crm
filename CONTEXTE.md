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

## 0bis. PROTOCOLE DE FIN DE SESSION

Quand Olivier signale qu'il quitte la conversation, Claude doit produire :

1. **Synthèse** de ce qui a été fait
2. **CONTEXTE.md mis à jour**
3. **Prompt prêt à coller** pour la prochaine conversation
4. **Rappel** des fichiers à commiter dans GitHub

## 1. QUI ET POURQUOI

Olivier Pichon, cabinet ERC Conseil, transmission d'entreprise.
Objectif : apprendre à coder en construisant des vrais outils utiles.

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
* **Outil create_file UNIQUEMENT pour écrire les fichiers HTML** — ne jamais utiliser bash heredoc pour du HTML (bloque)
* Fin de session → produire la mise à jour de CONTEXTE.md

## 5. ÉTAT ACTUEL DU PROJET

### Fichiers livrés et commitables
* `SCHEMA.sql` — schéma défini et **exécuté dans Supabase** ✓
* `style.css` — charte graphique partagée ✓
* `supabase-client.js` — client Supabase partagé ✓
* `contacts.html` — liste + filtres + drawer CRUD, branché sur style.css ✓
* `activites.html` — vue tableau + vue cartes, drawer exécution, branché sur style.css ✓
* `entreprises.html` — liste + cards + slide-over, CSS encore intégré (pas migré vers style.css)

### deals.html — état détaillé ✓
- Kanban + liste, drag & drop entre étapes, Supabase UPDATE optimiste
- Toggle vue Kanban / Liste
- Subbar filtres par étape (vue liste)
- **Slide-over éditable** au clic sur carte ou ligne :
  - Champs éditables : titre du deal, étape, statut, probabilité, valeur HT, closing (renommé "Échéance"), date réalisation, note interne
  - Calcul TVA 20% et TTC en temps réel
  - Onglet Activités : liste des activités liées
  - Onglet Notes : liste + ajout de note
  - Bouton Enregistrer → UPDATE Supabase + fermeture automatique
- **Migré vers style.css** : topbar, reset, body, toast (override position bottom-right)
- CSS inline réduit au strict spécifique deals (kanban, slide-over, badges à dots)
- **⚠️ deals → contacts et entreprises NON encore liés** (en cours, voir §6)

### Pages restantes à construire
* `produits.html` — catalogue missions + actifs en vente (voir §7)
* `leads.html` — **décision : ne pas construire** (usage couvert par étape Qualification des deals)

### Passe finale à prévoir
* Migrer `entreprises.html` vers `style.css`
* **Harmoniser les menus** sur toutes les pages dans cet ordre : **Contacts · Entreprises · Deals · Activités**

## 6. TRAVAIL EN COURS — deals.html

### Lier deals → contacts + entreprises
À faire dans le slide-over de deals.html :
- Ajouter deux selects : "Entreprise" et "Contact" (chargés depuis Supabase)
- Inclure `entreprise_id` et `contact_id` dans le payload de `saveDeal()`
- Afficher en lecture le nom entreprise + contact déjà liés (contexte en haut du slide-over)
- La requête principale charge déjà `entreprises(nom)` et `contacts(prenom,nom,fonction)` → à enrichir

### Requête actuelle dans `loadDeals()`
```js
sb.from('deals')
  .select('id,titre,etape,statut,valeur,probabilite,date_closing_prevu,date_gain,entreprises(nom)')
```
→ Ajouter `contact_id, entreprise_id, contacts(prenom,nom)` au select principal

## 7. PRODUITS — DÉCISIONS MÉTIER

Deux usages distincts, un seul champ `categorie` dans la table `produits` :

| categorie | Usage |
|-----------|-------|
| `'mission'` | Prestations catalogue : valorisation, préparation de cession, classeur d'urgence, audit… |
| `'actif'` | Une société en vente = un enregistrement produit. Permet de regrouper tous les deals acquéreurs sur un même mandat en filtrant par produit. |

→ Pas de modification du schéma nécessaire, `categorie TEXT` suffit.
→ `produits.html` à construire avec deux sections visuelles distinctes (missions / actifs).

## 8. PIPELINE ERC

qualification → diagnostic → valorisation →
recherche → négociation → closing → perdu

La première étape "Qualification" fait office de sas de leads. `leads.html` ne sera pas construite.

## 9. CHARTE GRAPHIQUE — style.css

Toutes les pages doivent inclure dans leur `<head>` :
```html
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style.css" />
```

### Tokens principaux
* Fond topbar : `#172b4d`
* Bleu action : `#0052cc`
* Fond page : `#f4f5f7`
* Texte principal : `#172b4d`
* Texte secondaire : `#6b778c`
* Police : DM Sans 400/500/600

### Menu de navigation — ordre imposé sur toutes les pages
```
Contacts · Entreprises · Deals · Activités
```

## 10. CE QU'ON NE FAIT PAS

* Pas de reporting complexe
* Pas de téléphonie
* Pas de marketplace
* Pas de clone Pipedrive complet
* Pas d'architecture multi-fichiers .js complexe
* Pas de `leads.html`
