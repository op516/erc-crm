# CONTEXTE PROJET — CRM ERC Conseil

*Dernière mise à jour : avril 2026*

---

## 0. LECTURE OBLIGATOIRE EN DÉBUT DE SESSION

Avant tout travail, lire ces fichiers dans l'ordre via `web_fetch` (URLs raw uniquement) :

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

---

## 6. CHARTE CSS — RÈGLES ABSOLUES

### Palette (style.css — utiliser ces valeurs partout)
- Fond topbar / texte principal : `#172b4d`
- Texte secondaire : `#6b778c`
- Bleu action : `#0052cc`
- Fond page : `#f4f5f7`
- Bordures : `#dfe1e6`
- Rouge danger : `#de350b`
- Police : DM Sans 400/500/600

### Fourni par style.css — NE JAMAIS redéfinir dans une page
`body`, reset `*`, `.topbar`, `.topbar-nav`, `.btn-primary`, `.btn-secondary`, `.btn-danger`, `.btn-save`, `.btn-close`, `.btn-reset`, `.toolbar`, `.search-input`, `.filter-select`, `.count-label`, `.table-wrap`, `table`, `thead`, `th`, `tbody tr`, `td`, `.empty-state`, `.avatar`, `.badge`, `.overlay`, `.drawer` et variantes, `.form-section`, `.form-row`, `.form-group`, `input/select/textarea`, `.toast`

### CSS inline autorisé (strict spécifique à la page)
Ce qui n'existe PAS dans style.css : kanban, pipeline selector, subbar, cards grid, view-toggle, badges couleur spécifiques, modals, éditeur d'étapes, color picker, etc.

### Toutes les pages sont migrées — aucune exception

---

## 7. ÉTAT DES FICHIERS

| Fichier | État | Notes |
|---|---|---|
| `style.css` | ✓ Référence partagée | Ne pas modifier sans raison globale |
| `contacts.html` | ✓ Référence CSS | Zéro CSS inline |
| `activites.html` | ✓ Migré | CSS inline minimal |
| `deals.html` | ✓ Migré avril 2026 | CSS inline minimal |
| `entreprises.html` | ✓ Migré avril 2026 | CSS inline minimal |
| `index.html` | ✓ Dashboard | |
| `login.html` | ✓ Auth | |
| `leads.html` | ❌ À créer | |
| `produits.html` | ❌ À créer | Déjà dans la nav |

---

## 8. DEALS.HTML — DÉTAIL COMPLET

### Tables Supabase créées (migration avril 2026)
```sql
pipelines (id UUID PK, nom TEXT, created_at)
pipeline_stages (id UUID PK, pipeline_id FK, nom TEXT, couleur TEXT, ordre INT)
deals : ajout pipeline_id UUID FK, stage_id UUID FK
```

### Pipeline par défaut
Nom : "ERC Transmission"
Étapes : Qualification → Diagnostic → Valorisation → Recherche → Négociation → Closing → Perdu

### Fonctionnalités
- Dropdown pipeline dans toolbar : liste + ✏️ renommage + "＋ Nouveau pipeline"
- Créer pipeline : modal nom + éditeur d'étapes (nom + couleur)
- Vue Kanban (défaut) + vue liste, toggle
- Subbar onglets par étape (vue liste)
- Drag & drop kanban avec sauvegarde Supabase + rollback
- Clic carte/ligne → drawer édition
- ↗ sur carte/ligne → transfert pipeline (reset étape 1)
- Recherche texte toolbar (titre + entreprise)
- Bouton "+ Nouveau deal" dans le topbar

### Drawer deal — champs complets
- Affaire : titre*, entreprise, contact, produit, quantité, étape, statut, raison perte (si perdu)
- Financier : valeur HT (auto : prix unitaire × qté × (1-remise%)), remise%, TVA% (hérité produit), valeur TTC (auto)
- Dates : échéance prévue (`date_closing_prevu`), réalisation, gain, perte
- Notes

### Calcul prix automatique
- Sélection produit → `unitPrice` = `prix_eur` du produit, TVA = champ `taxe` du produit
- Modification quantité/remise/TVA → recalcul HT et TTC
- `unitPrice` rechargé si deal existant avec produit

### Important pour index.html
- `valeur` (TTC) × `probabilite` / 100 = valeur pondérée pipeline

---

## 9. ENTREPRISES.HTML — FONCTIONNALITÉS

- Vue tableau + cards (toggle)
- Recherche (nom, ville, secteur)
- Drawer CRUD : nom, sigle, secteur, ville, CA, effectif, statut, département, commentaire
- Section contacts liés : rattacher/détacher
- Bouton "+ Activité" → modal rapide (type, date, sujet, heure, deal, note)

---

## 10. SCHÉMA — POINTS D'ATTENTION

### Table `produits`
⚠️ Le champ TVA s'appelle `taxe` (pas `taux_tva`)
Champs clés : `id, nom, prix_eur, taxe, actif`

### Table `deals` — colonnes complètes
`id, titre, entreprise_id, contact_id, etape, statut, raison_perte, valeur, probabilite, date_closing_prevu, date_gain, date_perte, notes, produit_id, quantite, remise, taux_tva, valeur_ht, date_realisation, pipeline_id, stage_id`

---

## 11. AUTH (à activer en prod)

Guard silencieux en haut du `<script>` de chaque page :
```javascript
(async () => {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) window.location.href = 'login.html';
})();
```
`login.html` existe et gère la redirection si déjà connecté.
Bouton déconnexion dans `index.html` : `supabase.auth.signOut()`.

---

## 12. PROMPT DE DÉBUT DE SESSION (à copier-coller)

```
Lis ces fichiers dans cet ordre via web_fetch, confirme chaque lecture, puis attends ma prochaine instruction :

1. https://raw.githubusercontent.com/op516/erc-crm/main/CONTEXTE.md
2. https://raw.githubusercontent.com/op516/erc-crm/main/SCHEMA.sql
3. https://raw.githubusercontent.com/op516/erc-crm/main/style.css
4. https://raw.githubusercontent.com/op516/erc-crm/main/deals.html
5. https://raw.githubusercontent.com/op516/erc-crm/main/contacts.html
6. https://raw.githubusercontent.com/op516/erc-crm/main/entreprises.html
7. https://raw.githubusercontent.com/op516/erc-crm/main/activites.html
8. https://raw.githubusercontent.com/op516/erc-crm/main/index.html
```
