-- CRM ERC Conseil — Schéma base de données
-- Basé sur les exports Pipedrive réels
-- À exécuter dans Supabase > SQL Editor

-- ============================================
-- ENTREPRISES (ex Organizations Pipedrive)
-- ============================================
CREATE TABLE entreprises (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nom                   TEXT NOT NULL,
  sigle                 TEXT,
  secteur_activite      TEXT,
  detail_activite       TEXT,
  naf                   TEXT,
  site_web              TEXT,
  linkedin              TEXT,
  ca_annuel             DECIMAL(12,2),
  nb_employes           INTEGER,
  actionnariat          TEXT,
  holding               TEXT,
  mois_cloture          TEXT,
  adresse               TEXT,
  cp                    TEXT,
  ville                 TEXT,
  departement           TEXT,
  pays                  TEXT,
  type_contact          TEXT,
  sous_type_contact     TEXT,
  reference             TEXT,
  lien_dossier          TEXT,
  statut                TEXT DEFAULT 'prospect',
  source_contact        TEXT,
  date_premier_contact  DATE,
  date_premier_rdv      DATE,
  rappel_prevoir        BOOLEAN DEFAULT FALSE,
  suivi                 BOOLEAN DEFAULT FALSE,
  cible_secteur         TEXT,
  cible_detail          TEXT,
  cible_localisation    TEXT,
  cible_capital_dispo   TEXT,
  teaser_recu           BOOLEAN DEFAULT FALSE,
  engagement_conf       BOOLEAN DEFAULT FALSE,
  dossier_envoye        BOOLEAN DEFAULT FALSE,
  visite                BOOLEAN DEFAULT FALSE,
  commentaire           TEXT,
  autres_notes          TEXT,
  created_at            TIMESTAMP DEFAULT NOW(),
  updated_at            TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- CONTACTS (ex Persons Pipedrive)
-- ============================================
CREATE TABLE contacts (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  prenom                TEXT,
  nom                   TEXT NOT NULL,
  civilite              TEXT,
  fonction              TEXT,
  annee_naissance       TEXT,
  classification        TEXT,
  email_travail         TEXT,
  email_perso           TEXT,
  tel_travail           TEXT,
  tel_mobile            TEXT,
  tel_domicile          TEXT,
  linkedin_url          TEXT,
  adresse_perso         TEXT,
  cp_perso              TEXT,
  ville_perso           TEXT,
  entreprise_id         UUID REFERENCES entreprises(id),
  role                  TEXT,
  date_entree_relation  DATE,
  origine_contact       TEXT,
  localisation          TEXT,
  apport_disponible     TEXT,
  domaine_recherche     TEXT,
  notes                 TEXT,
  created_at            TIMESTAMP DEFAULT NOW(),
  updated_at            TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- DEALS (ex Deals Pipedrive)
-- ============================================
CREATE TABLE deals (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  titre                 TEXT NOT NULL,
  entreprise_id         UUID REFERENCES entreprises(id),
  contact_id            UUID REFERENCES contacts(id),
  etape                 TEXT DEFAULT 'qualification',
  statut                TEXT DEFAULT 'ouvert',
  raison_perte          TEXT,
  valeur                DECIMAL(12,2),
  probabilite           INTEGER DEFAULT 0,
  date_closing_prevu    DATE,
  date_gain             DATE,
  date_perte            DATE,
  notes                 TEXT,
  created_at            TIMESTAMP DEFAULT NOW(),
  updated_at            TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- ACTIVITES (ex Activities Pipedrive)
-- ============================================
CREATE TABLE activites (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  deal_id               UUID REFERENCES deals(id),
  contact_id            UUID REFERENCES contacts(id),
  entreprise_id         UUID REFERENCES entreprises(id),
  type                  TEXT,
  sujet                 TEXT,
  description           TEXT,
  note                  TEXT,
  date_echeance         DATE,
  heure_echeance        TIME,
  duree                 TEXT,
  lieu                  TEXT,
  faite                 BOOLEAN DEFAULT FALSE,
  date_fait             TIMESTAMP,
  created_at            TIMESTAMP DEFAULT NOW(),
  updated_at            TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- NOTES (ex Notes Pipedrive)
-- ============================================
CREATE TABLE notes (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  contenu               TEXT,
  deal_id               UUID REFERENCES deals(id),
  contact_id            UUID REFERENCES contacts(id),
  entreprise_id         UUID REFERENCES entreprises(id),
  epingle_deal          BOOLEAN DEFAULT FALSE,
  epingle_contact       BOOLEAN DEFAULT FALSE,
  epingle_entreprise    BOOLEAN DEFAULT FALSE,
  created_at            TIMESTAMP DEFAULT NOW(),
  updated_at            TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- PRODUITS (ex Products Pipedrive)
-- ============================================
CREATE TABLE produits (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nom                   TEXT NOT NULL,
  code_produit          TEXT,
  categorie             TEXT,
  description           TEXT,
  prix_eur              DECIMAL(12,2),
  unite                 TEXT,
  taxe                  DECIMAL(5,2),
  frequence_facturation TEXT,
  cycles_facturation    INTEGER,
  ref_interne           TEXT,
  ref_fuscaq            TEXT,
  ref_cession_pme       TEXT,
  actif                 BOOLEAN DEFAULT TRUE,
  created_at            TIMESTAMP DEFAULT NOW(),
  updated_at            TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- DOCUMENTS (ex Files Pipedriv
