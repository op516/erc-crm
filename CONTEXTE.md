# CONTEXTE PROJET — CRM ERC Conseil

*Dernière mise à jour : avril 2026 — synchronisé avec le code source réel*

---

## 0. LECTURE OBLIGATOIRE EN DÉBUT DE SESSION

Avant tout travail, lire ces fichiers dans l'ordre via `web_fetch` :

1. https://raw.githubusercontent.com/op516/erc-crm/main/CONTEXTE.md
2. https://raw.githubusercontent.com/op516/erc-crm/main/SCHEMA.sql
3. https://raw.githubusercontent.com/op516/erc-crm/main/style.css
4. https://raw.githubusercontent.com/op516/erc-crm/main/deals.html
5. https://raw.githubusercontent.com/op516/erc-crm/main/contacts.html
6. https://raw.githubusercontent.com/op516/erc-crm/main/entreprises.html
7. https://raw.githubusercontent.com/op516/erc-crm/main/activites.html
8. https://raw.githubusercontent.com/op516/erc-crm/main/index.html

Confirmer la lecture de chaque fichier avant de commencer. Ne jamais supposer l'état d'un fichier sans l'avoir lu.

---

## 0bis. PROTOCOLE DE FIN DE SESSION

Quand Olivier signale qu'il quitte, produire :
1. Synthèse de ce qui a été fait
2. CONTEXTE.md mis à jour (refléter l'état réel)
3. Prompt prêt à coller pour la prochaine session
4. Rappel des fichiers à commiter dans GitHub

---

## 1. QUI ET POURQUOI

Olivier Pichon, cabinet ERC Conseil, transmission d'entreprise.
Objectif : apprendre à coder en construisant des outils réels.

---

## 2. STACK FIXE — NE PAS CHANGER

- Base de données : Supabase (PostgreSQL)
- Hébergement : Vercel
- Versionning : GitHub — https://github.com/op516/erc-crm (repo public)
- Frontend : HTML / CSS / JS vanilla
- PAS de framework, PAS de librairie externe, PAS de nouveau service

---

## 3. ARCHITECTURE

- Un fichier HTML par page
- Un seul `supabase-client.js` partagé
- Un seul `style.css` partagé — toutes les pages l'appellent
- `index.html` = tableau de bord
- Pas de router, pas de bundler, pas de build

---

## 4. RÈGLES STRICTES

- Spec 3 lignes MAX avant chaque fonctionnalité
- Coder uniquement ce qui est dans la spec
- Un seul fichier par session
- Ne jamais simplifier une fonctionnalité sans accord explicite d'Olivier
- Fin de session → produire CONTEXTE.md à jour

---

## 5. NAVIGATION — RÉFÉRENCE ABSOLUE

Structure identique sur toutes les pages :

```html
<div class="topbar">
  <div class="topbar-left">
    <h1>ERC CRM</h1>
    <nav class="topbar-nav">
      <a href="index.html">Accueil</a>
      <a href="contacts.html">Contacts</a>
      <a href="entreprises.html">Entreprises</a>
      <a href="deals.html">Deals / Pipelines</a>
      <a href="activites.html">Activités</a>
      <a href="produits.html">Produits</a>
    </nav>
  </div>
  <button class="btn-primary" onclick="...">+ Action</button>
</div>
```

- L'onglet actif prend la classe `active`
- Ne jamais omettre un onglet
- Ne jamais utiliser d'autre structure de nav
- Le lien Deals s'appelle **"Deals / Pipelines"** — conforme dans tous les fichiers

---

## 6. CHARTE CSS — RÈGLES ABSOLUES

### Palette
- Fond topbar / texte principal : `#172b4d`
- Texte secondaire : `#6b778c`
- Bleu action : `#0052cc`
- Fond page : `#f4f5f7`
- Bordures : `#dfe1e6`
- Rouge danger : `#de350b`
- Police : DM Sans 400/500/600

### Fourni par style.css — NE JAMAIS redéfinir dans une page
`body`, reset `*`, `.topbar`, `.topbar-nav`, `.btn-primary`, `.btn-secondary`, `.btn-danger`, `.btn-save`, `.btn-close`, `.btn-reset`, `.toolbar`, `.search-input`, `.filter-select`, `.count-label`, `.table-wrap`, `table`, `thead`, `th`, `tbody tr`, `td`, `.empty-state`, `.avatar`, `.nom-wrap`, `.badge` (+ variantes), `.overlay`, `.drawer` + variantes, `.form-section`, `.form-row`, `.form-group`, `input/select/textarea`, `.field-hint`, `.toast`

### CSS inline autorisé (strict spécifique à la page)
Ce qui n'existe PAS dans style.css : kanban, pipeline selector, subbar, cards grid, view-toggle, badges couleur spécifiques, modals, éditeur d'étapes, color picker, period-tabs, type-filters, act-card, act-table, dashboard layout (kpi-row, dash-row, dash-card, pipeline-row, skel), toggle, etc.

### Convention toolbar
Toutes les pages affichent un `<h1>` avec le nom de la page à gauche de la barre de recherche :
```html
<h1 style="font-size:18px;font-weight:600;color:#172b4d;white-space:nowrap;margin-right:4px">Nom page</h1>
```

---

## 7. ÉTAT DES FICHIERS

| Fichier | État | Notes |
|---|---|---|
| `style.css` | ✓ Référence partagée | Ne pas modifier sans raison globale |
| `contacts.html` | ✓ Livré | Drawer CRUD, modal activité rapide, nav corrigée |
| `activites.html` | ✓ Livré | Vue tableau par défaut, modal unifié, nav corrigée |
| `deals.html` | ✓ Livré | Kanban par défaut, full pipeline system, SELECT nettoyé |
| `entreprises.html` | ✓ Livré | Vue table+cards, contacts liés, modal activité rapide |
| `index.html` | ✓ Livré | Dashboard KPIs, nav corrigée |
| `produits.html` | ✓ Livré | Filtre statut "Actifs" par défaut |
| `login.html` | ✓ Livré | Auth Supabase |
| `leads.html` | ❌ À créer | |

---

## 8. AUTH (à activer en prod)

Guard silencieux en haut du `<script>` de chaque page :
```javascript
(async () => {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) window.location.href = 'login.html';
})();
```

**État réel** : aucune page n'a ce guard pour le moment. `index.html` a uniquement un bouton "Déconnexion" qui appelle `supabase.auth.signOut()`.

---

## 9. DEALS.HTML — DÉTAIL COMPLET

### Tables Supabase (migration avril 2026)
```sql
pipelines (id UUID PK, nom TEXT, created_at)
pipeline_stages (id UUID PK, pipeline_id FK, nom TEXT, couleur TEXT, ordre INT)
deals : pipeline_id UUID FK, stage_id UUID FK (en plus des champs existants)
```

### Pipeline par défaut
Nom : "ERC Transmission"
Étapes : Qualification → Diagnostic → Valorisation → Recherche → Négociation → Closing → Perdu

### Fonctionnalités réelles
- Dropdown pipeline dans toolbar : liste + ✏️ renommage + "＋ Nouveau pipeline"
- Créer pipeline : modal nom + éditeur d'étapes (nom + couleur via color picker)
- Vue Kanban (défaut) + vue liste, toggle
- Subbar onglets par étape (vue liste uniquement)
- Drag & drop kanban avec UPDATE Supabase + rollback optimiste
- Clic carte/ligne → drawer édition deal
- ↗ sur carte/ligne → modal transfert pipeline (reset étape 1 du pipeline cible)
- Recherche texte toolbar (titre + entreprise)
- Bouton "+ Nouveau deal" dans le topbar
- Suppression deal : supprime d'abord les activités liées, puis le deal

### Drawer deal — champs réels
- Affaire : titre*, entreprise, contact, produit, quantité, étape (stage), statut, raison perte (si perdu)
- Financier : valeur HT (auto), remise%, TVA%, valeur TTC (auto), probabilité%
- Dates : date_closing_prevu, date_realisation, date_gain, date_perte
- Notes

### Calcul prix automatique
- Sélection produit → `unitPrice` = `prix_eur`, TVA = `taxe` du produit
- Modification quantité/remise/TVA → recalcul HT et TTC
- `unitPrice` rechargé si deal existant avec produit

### Champs Supabase réels utilisés dans le SELECT
`id, titre, stage_id, statut, valeur, valeur_ht, remise, taux_tva, probabilite, date_closing_prevu, date_realisation, date_gain, date_perte, raison_perte, notes, entreprise_id, contact_id, produit_id, quantite, entreprises(nom)`

### Champs écrits au INSERT/UPDATE
`titre, entreprise_id, contact_id, produit_id, quantite, stage_id, pipeline_id, etape, statut, raison_perte, valeur_ht, remise, taux_tva, valeur, probabilite, date_closing_prevu, date_realisation, date_gain, date_perte, notes, updated_at`

---

## 10. INDEX.HTML (DASHBOARD) — ÉTAT RÉEL

### KPIs affichés
- Deals ouverts (count, statut = 'ouvert')
- Valeur pondérée = somme(valeur × probabilite / 100)
- Activités en retard (faite=false, date_echeance < today)
- Contacts (count)

### Section Pipeline
⚠️ **Hardcodé** : utilise un tableau STAGES fixe avec les clés texte du champ `etape` (qualification, diagnostic, valorisation, recherche, negociation, closing). Ne lit PAS les tables `pipelines` ni `pipeline_stages`. À refactoriser si nécessaire.

### Deals récents
Les 8 derniers deals ouverts, grille 2 colonnes.

### Activités
Activités non faites avec date ≤ aujourd'hui (retard + aujourd'hui), limite 7.

---

## 11. ACTIVITES.HTML — DÉTAIL COMPLET

### Fonctionnalités réelles
- Vue **tableau par défaut** (pas cartes)
- Toggle vue : cartes / tableau
- Tabs période : En retard | Aujourd'hui | Cette semaine | Toutes (défaut)
- Filtres type : Tous | Appel | RDV | Email | Tâche
- Badge rouge sur onglet "En retard" (compte automatique)
- Tri colonnes en vue tableau (type, sujet, lié à, date, heure, fait)
- Checkbox "fait" inline → UPDATE Supabase immédiat
- Suppression inline (bouton ✕)
- Modal unifié création + édition :
  - Création : type*, date*, sujet, heure, lieu, deal, entreprise, contact, note
  - Édition : + checkbox "Activité réalisée" + historique notes (table `notes`)
  - Note saisie → insérée dans table `notes` avec les FKs deal/contact/entreprise

### SELECT Supabase
`activites` jointure `deals(id,titre)`, `entreprises(id,nom)`, `contacts(id,prenom,nom)`

---

## 12. CONTACTS.HTML — DÉTAIL COMPLET

### Fonctionnalités réelles
- Vue tableau (unique)
- Recherche nom, filtres catégorie + origine
- Drawer CRUD : identité, entreprise liée, coordonnées (email avec validation, tel avec formatage), adresse, notes
- Bouton "+ Activité" dans drawer (modal rapide) : type, date, sujet, heure, deal, note → insère dans `activites` + `notes`

---

## 13. ENTREPRISES.HTML — DÉTAIL COMPLET

### Fonctionnalités réelles
- Vue table + cards (toggle)
- Recherche (nom, ville, secteur)
- Drawer CRUD : nom, sigle, secteur, ville, CA, effectif, statut, département, commentaire
- Section contacts liés (visible en édition) : rattacher/détacher contacts via UPDATE entreprise_id
- Bouton "+ Activité" → modal rapide (type, date, sujet, heure, deal, note)
- Drawer plus large : 560px (override style.css)

### Statuts entreprise
prospect / cible / mandat / actif / inactif

---

## 14. PRODUITS.HTML — DÉTAIL COMPLET

### Fonctionnalités réelles
- Vue tableau
- Recherche par nom
- Filtre catégorie : Cession, Acquisition, Conseil, Diagnostic, Valorisation, Autre
- Filtre statut : **"Actifs" sélectionné par défaut**
- Drawer CRUD : Identification, Tarification, Références externes, Statut (toggle actif/inactif)
- Suppression directe (confirm simple)

### Points d'attention schema
- Le champ TVA s'appelle `taxe` (pas `taux_tva`)
- Champs clés : `id, nom, prix_eur, taxe, actif`

---

## 15. SCHÉMA — POINTS D'ATTENTION

### Table `produits`
⚠️ Le champ TVA s'appelle `taxe` (pas `taux_tva`)

### Table `deals` — champs réels utilisés
`id, titre, entreprise_id, contact_id, etape, statut, raison_perte, valeur, valeur_ht, remise, taux_tva, probabilite, date_closing_prevu, date_realisation, date_gain, date_perte, notes, produit_id, quantite, pipeline_id, stage_id, updated_at`

### Tables pipeline (migration avril 2026)
```sql
pipelines (id UUID PK, nom TEXT, created_at TIMESTAMP)
pipeline_stages (id UUID PK, pipeline_id UUID FK, nom TEXT, couleur TEXT, ordre INT)
```

---

## 16. PROMPT DE DÉBUT DE SESSION

```
Lis ces fichiers dans cet ordre via web_fetch, confirme chaque lecture,
puis attends ma prochaine instruction.
Utilise ces URLs avec paramètre cache-busting (timestamp du jour) :
1. https://raw.githubusercontent.com/op516/erc-crm/main/CONTEXTE.md?cb=AAAAMMJJ
2. https://raw.githubusercontent.com/op516/erc-crm/main/SCHEMA.sql?cb=AAAAMMJJ
3. https://raw.githubusercontent.com/op516/erc-crm/main/style.css?cb=AAAAMMJJ
4. https://raw.githubusercontent.com/op516/erc-crm/main/deals.html?cb=AAAAMMJJ
5. https://raw.githubusercontent.com/op516/erc-crm/main/contacts.html?cb=AAAAMMJJ
6. https://raw.githubusercontent.com/op516/erc-crm/main/entreprises.html?cb=AAAAMMJJ
7. https://raw.githubusercontent.com/op516/erc-crm/main/activites.html?cb=AAAAMMJJ
8. https://raw.githubusercontent.com/op516/erc-crm/main/index.html?cb=AAAAMMJJ
```
