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

### Convention toolbar
```html
<h1 style="font-size:18px;font-weight:600;color:#172b4d;white-space:nowrap;margin-right:4px">Nom page</h1>
```

---

## 7. ÉTAT DES FICHIERS

| Fichier | État | Notes |
|---|---|---|
| `style.css` | ✓ Référence partagée | Ne pas modifier sans raison globale |
| `contacts.html` | ✓ Livré | Auth guard ✓ |
| `activites.html` | ✓ Livré | Auth guard ✓, vue tableau par défaut |
| `deals.html` | ✓ Livré | Auth guard ✓, full pipeline system |
| `entreprises.html` | ✓ Livré | Auth guard ✓ |
| `index.html` | ✓ Livré | Auth guard ✓, bouton déconnexion |
| `produits.html` | ✓ Livré | Auth guard ✓, filtre "Actifs" par défaut |
| `login.html` | ✓ Livré | Gère connexion + définition mot de passe invitation |
| `leads.html` | ❌ À créer | |

---

## 8. AUTH — ÉTAT RÉEL

- Utilisateur Supabase créé (email Olivier)
- `login.html` opérationnel : connexion + invitation
- Guard auth sur toutes les pages (6) :
```javascript
(async () => {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) { window.location.href = 'login.html'; return; }
  document.body.style.visibility = 'visible';
  init(); // ou load() ou loadDashboard()
})();
```
- Supabase URL Configuration : Site URL et Redirect URLs pointent sur `https://crm.erc-conseil.fr/login.html`

### ⚠️ Point en suspens — Sécurité anti-flash
Les pages sont visibles ~500ms avant la vérification auth (flash). Solution propre = middleware Vercel (non implémenté). Décision reportée à l'usage réel. `body { visibility: hidden; }` a été testé et retiré car ralentissait trop la navigation.

---

## 9. SÉCURITÉ SUPABASE — ÉTAT RÉEL

### RLS activé (avril 2026)
Row Level Security activé sur toutes les tables avec policy `auth_only` :
- Accès uniquement aux utilisateurs authentifiés (`TO authenticated`)
- Tables protégées : `entreprises`, `contacts`, `produits`, `leads`, `deals`, `activites`, `notes`, `documents`, `pipelines`, `pipeline_stages`

### GitHub
- Repo toujours **public** — ne contient pas de données sensibles
- Clé Supabase `anon` dans `supabase-client.js` (normal — protégée par RLS)
- `.env` ignoré par `.gitignore`

### À faire
- Passer le repo GitHub en **privé** (décision reportée)

---

## 10. DEALS.HTML — DÉTAIL COMPLET

### Tables Supabase (migration avril 2026)
```sql
pipelines (id UUID PK, nom TEXT, created_at TIMESTAMP)
pipeline_stages (id UUID PK, pipeline_id UUID FK, nom TEXT, couleur TEXT, ordre INT)
deals : pipeline_id UUID FK, stage_id UUID FK
```

### Pipeline par défaut
Nom : "ERC Transmission"
Étapes : Qualification → Diagnostic → Valorisation → Recherche → Négociation → Closing → Perdu

### Fonctionnalités réelles
- Dropdown pipeline : liste + renommage + nouveau pipeline
- Créer pipeline : modal nom + éditeur étapes (nom + couleur)
- Vue Kanban (défaut) + vue liste, toggle
- Subbar onglets par étape (vue liste)
- Drag & drop kanban avec UPDATE Supabase + rollback
- Clic carte/ligne → drawer édition deal
- ↗ transfert pipeline (reset étape 1 du pipeline cible)
- Recherche texte (titre + entreprise)
- Suppression deal : supprime d'abord activités liées

### Drawer deal — champs
- Affaire : titre*, entreprise, contact, produit, quantité, étape, statut, raison perte
- Financier : valeur HT (auto), remise%, TVA%, valeur TTC (auto), probabilité%
- Dates : date_closing_prevu, date_realisation, date_gain, date_perte
- Notes

### Champs SELECT Supabase
`id, titre, stage_id, statut, valeur, valeur_ht, remise, taux_tva, probabilite, date_closing_prevu, date_realisation, date_gain, date_perte, raison_perte, notes, entreprise_id, contact_id, produit_id, quantite, entreprises(nom)`

---

## 11. INDEX.HTML (DASHBOARD) — ÉTAT RÉEL

### KPIs
- Deals ouverts, valeur pondérée (valeur × probabilite / 100), activités en retard, contacts

### Section Pipeline
⚠️ Hardcodé avec tableau STAGES fixe (clés texte `etape`). Ne lit pas `pipelines`/`pipeline_stages`.

### Activités
Non faites avec date ≤ aujourd'hui, limite 7.

### Deals récents
8 derniers deals ouverts, grille 2 colonnes.

---

## 12. ACTIVITES.HTML — DÉTAIL COMPLET

- Vue tableau par défaut
- Toggle cartes / tableau
- Tabs : En retard | Aujourd'hui | Cette semaine | Toutes (défaut)
- Filtres type : Tous | Appel | RDV | Email | Tâche
- Badge rouge onglet "En retard"
- Tri colonnes en vue tableau
- Checkbox "fait" inline → UPDATE immédiat
- Modal unifié création + édition (avec historique notes)
- Note saisie → insérée dans table `notes`

---

## 13. CONTACTS.HTML — DÉTAIL COMPLET

- Vue tableau unique
- Recherche nom, filtres catégorie + origine
- Drawer CRUD : identité, entreprise, coordonnées, adresse, notes
- Bouton "+ Activité" dans drawer (modal rapide)
- Validation email, formatage téléphone

---

## 14. ENTREPRISES.HTML — DÉTAIL COMPLET

- Vue table + cards (toggle)
- Recherche (nom, ville, secteur)
- Drawer CRUD : nom, sigle, secteur, ville, CA, effectif, statut, département, commentaire
- Contacts liés : rattacher/détacher
- Bouton "+ Activité" → modal rapide
- Drawer 560px

### Statuts : prospect / cible / mandat / actif / inactif

---

## 15. PRODUITS.HTML — DÉTAIL COMPLET

- Vue tableau
- Recherche par nom, filtre catégorie, filtre statut ("Actifs" par défaut)
- Drawer CRUD : Identification, Tarification, Références externes, Statut (toggle)
- ⚠️ Champ TVA = `taxe` (pas `taux_tva`)

---

## 16. SCHÉMA — POINTS D'ATTENTION

- Champ TVA produits : `taxe` (pas `taux_tva`)
- Deals : `id, titre, entreprise_id, contact_id, etape, statut, raison_perte, valeur, valeur_ht, remise, taux_tva, probabilite, date_closing_prevu, date_realisation, date_gain, date_perte, notes, produit_id, quantite, pipeline_id, stage_id, updated_at`

---

## 17. PROMPT DE DÉBUT DE SESSION

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
