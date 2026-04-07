-- CRM ERC Conseil — Schéma base de données
-- À exécuter dans Supabase > SQL Editor

-- Entreprises (cédants)
CREATE TABLE entreprises (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nom           TEXT NOT NULL,
  secteur       TEXT,
  ville         TEXT,
  departement   TEXT,
  ca            DECIMAL(12,2),
  ebitda        DECIMAL(12,2),
  effectif      INTEGER,
  statut        TEXT DEFAULT 'prospect',
  source        TEXT,
  created_at    TIMESTAMP DEFAULT NOW()
);

-- Contacts (dirigeants, acquéreurs, conseils)
CREATE TABLE contacts (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  prenom        TEXT,
  nom           TEXT NOT NULL,
  email         TEXT,
  telephone     TEXT,
  role          TEXT, -- cedant, acquereur, conseil, banquier
  entreprise_id UUID REFERENCES entreprises(id),
  created_at    TIMESTAMP DEFAULT NOW()
);

-- Deals (dossiers de transmission)
CREATE TABLE deals (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  titre         TEXT NOT NULL,
  entreprise_id UUID REFERENCES entreprises(id),
  contact_id    UUID REFERENCES contacts(id),
  etape         TEXT DEFAULT 'qualification',
  -- etapes : qualification, diagnostic, valorisation, recherche, negociation, closing, perdu
  valeur        DECIMAL(12,2),
  probabilite   INTEGER DEFAULT 0,
  date_closing  DATE,
  notes         TEXT,
  created_at    TIMESTAMP DEFAULT NOW(),
  updated_at    TIMESTAMP DEFAULT NOW()
);

-- Activités (appels, RDV, emails, tâches)
CREATE TABLE activites (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  deal_id       UUID REFERENCES deals(id),
  contact_id    UUID REFERENCES contacts(id),
  type          TEXT, -- appel, rdv, email, tache, note
  titre         TEXT,
  description   TEXT,
  date_echeance TIMESTAMP,
  faite         BOOLEAN DEFAULT FALSE,
  created_at    TIMESTAMP DEFAULT NOW()
);

-- Documents liés aux deals
CREATE TABLE documents (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  deal_id       UUID REFERENCES deals(id),
  nom           TEXT,
  type          TEXT, -- memo, diagnostic, nda, loi, valorisation
  drive_url     TEXT,
  created_at    TIMESTAMP DEFAULT NOW()
);
