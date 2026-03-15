# 🦷 Smile Everyday — Dental Clinic Management System

> Système de gestion intelligente d'un cabinet dentaire — Jakarta EE · EJB · JPA · WildFly

![Java](https://img.shields.io/badge/Java-EE%208+-orange?style=flat-square&logo=java)
![WildFly](https://img.shields.io/badge/WildFly-27+-red?style=flat-square)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=flat-square&logo=mysql)
![JSF](https://img.shields.io/badge/JSF-Glassmorphism-purple?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

---

## 📋 Table des matières

- [Présentation](#-présentation-du-projet)
- [Architecture](#-architecture-technique)
- [Fonctionnalités](#-fonctionnalités-clés)
- [Structure du projet](#-structure-du-projet)
- [Installation](#-installation-et-configuration)
- [Utilisation](#-utilisation)
- [Sécurité](#-sécurité)
- [Auteur](#-auteur)

---

## 📝 Présentation du Projet

**Smile Everyday** est une solution logicielle complète conçue pour **digitaliser la gestion d'un cabinet dentaire**. En tant qu'ingénieur, ce projet démontre ma capacité à concevoir une **architecture logicielle robuste et sécurisée** répondant à des besoins métiers réels.

L'application couvre l'ensemble du cycle de vie d'un cabinet dentaire : gestion des patients, des rendez-vous, des dossiers médicaux, de la facturation, et d'un espace de recrutement pour les aides-soignants.

---

## 🛠 Architecture Technique

L'application repose sur une **architecture n-tier (multicouche)** respectant les standards **Jakarta EE** :

```
┌─────────────────────────────────────────┐
│           Couche Présentation           │
│         JSP · JSF · CSS3 · JS           │
│         Design Glassmorphism            │
├─────────────────────────────────────────┤
│           Couche Contrôleur             │
│         Servlets · Controleur.java      │
├─────────────────────────────────────────┤
│           Couche Métier                 │
│      EJB 3 · GestionMedicaleLocal       │
│      GestionMedicalelmpl.java           │
├─────────────────────────────────────────┤
│           Couche Persistance            │
│         JPA · Hibernate ORM             │
├─────────────────────────────────────────┤
│           Base de Données               │
│              MySQL 8.0                  │
└─────────────────────────────────────────┘
         Serveur : WildFly 27+
```

### Stack technique

| Couche | Technologie |
|--------|-------------|
| **Backend** | Java EE 8 · Jakarta EE · EJB 3.1 |
| **Persistance** | JPA · Hibernate ORM |
| **Frontend** | JSP · JSF · JSTL · HTML5/CSS3 |
| **Design** | Glassmorphism · Font Awesome 6.5 |
| **Base de données** | MySQL 8.0 |
| **Serveur** | WildFly 27+ |
| **Build** | Maven 3.6+ |

---

## 🚀 Fonctionnalités Clés

### 👨‍⚕️ Espace Dentiste
- Dashboard personnalisé avec vue d'ensemble
- Gestion complète des rendez-vous (création, validation, archivage)
- Consultation des dossiers médicaux des patients
- Enregistrement des actes médicaux et soins
- Gestion des services médicaux

### 🤒 Espace Patient
- Inscription et connexion sécurisée
- Réservation de rendez-vous en ligne
- Consultation du dossier médical personnel
- Historique des soins et consultations
- Accès aux factures
- Mur de publications

### 👩‍⚕️ Espace Aide-Soignant
- Vérification et validation des comptes
- Gestion des services médicaux
- Support aux dentistes

### 📋 Gestion Médicale
- **Dossier Médical Informatisé** : historique complet des patients
- **Actes Médicaux** : enregistrement, tarification, suivi
- **Services Médicaux** : Consultation · Chirurgie · Imagerie · Laboratoire · Urgence
- **Facturation** automatique des actes

### 👥 Module Recrutement
- Espace candidature pour aides-soignants
- Gestion des dossiers de candidature
- Validation des profils professionnels

---

## 📂 Structure du Projet

```
SmileEveryday/
│
├── src/main/java/
│   ├── tn.enit.controller/
│   │   └── Controleur.java           # Contrôleur principal
│   │
│   ├── tn.enit.entities/
│   │   ├── Patient.java              # Entité Patient
│   │   ├── Dentiste.java             # Entité Dentiste
│   │   ├── AideSoignant.java         # Entité Aide-Soignant
│   │   ├── Rendezvous.java           # Entité Rendez-vous
│   │   ├── ServiceMedical.java       # Entité Service Médical
│   │   ├── ActeMedical.java          # Entité Acte Médical
│   │   └── Publication.java          # Entité Publication
│   │
│   ├── tn.enit.services.interfaces/
│   │   └── GestionMedicaleLocal.java # Interface EJB Local
│   │
│   └── tn.enit.services.impl/
│       └── GestionMedicalelmpl.java  # Implémentation EJB
│
├── src/main/webapp/
│   ├── WEB-INF/views/
│   │   ├── connexion/                # Pages de connexion
│   │   ├── connexionDentiste/        # Connexion dentiste
│   │   ├── EspaceDentiste/           # Dashboard dentiste
│   │   ├── EspacePatient/            # Dashboard patient
│   │   ├── DossierMedical/           # Dossier médical
│   │   ├── Facture/                  # Facturation
│   │   ├── ListeServices/            # Services médicaux
│   │   ├── rendezvous/               # Gestion RDV
│   │   ├── MurPublications/          # Mur social
│   │   ├── ProfilPatient/            # Profil patient
│   │   ├── patient/                  # Gestion patients
│   │   ├── Publication/              # Publications
│   │   ├── Service/                  # Services
│   │   ├── AideSoignant/             # Espace AS
│   │   ├── validerInscription/       # Validation compte
│   │   ├── verificationAS/           # Vérification AS
│   │   ├── SuccesRDV/                # Confirmation RDV
│   │   └── SuccesService/            # Confirmation service
│   │
│   ├── images/                       # Assets images
│   ├── mesStyles/                    # CSS personnalisés
│   └── index.jsp                     # Page d'accueil
│
├── src/main/resources/
│   └── META-INF/
│       └── persistence.xml           # Config JPA
│
└── pom.xml                           # Config Maven
```

---

## ⚙️ Installation et Configuration

### Prérequis

```
✅ JDK 11 ou supérieur
✅ WildFly 27+ (ou Glassfish/Payara)
✅ MySQL 8.0
✅ Maven 3.6+
✅ IDE : IntelliJ IDEA ou Eclipse
```

### Étape 1 — Cloner le repository

```bash
git clone https://github.com/ton-profil/smile-everyday.git
cd smile-everyday
```

### Étape 2 — Configurer la base de données

```sql
CREATE DATABASE smile_everyday CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Importer le schéma :
```bash
mysql -u root -p smile_everyday < database/schema.sql
```

### Étape 3 — Configurer persistence.xml

```xml
<persistence-unit name="SmileEverydayPU">
    <jta-data-source>java:jboss/datasources/SmileEverydayDS</jta-data-source>
    <properties>
        <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL8Dialect"/>
        <property name="hibernate.hbm2ddl.auto" value="update"/>
    </properties>
</persistence-unit>
```

### Étape 4 — Configurer le DataSource WildFly

Dans `standalone.xml` de WildFly :

```xml
<datasource jndi-name="java:jboss/datasources/SmileEverydayDS" pool-name="SmileEverydayDS">
    <connection-url>jdbc:mysql://localhost:3306/smile_everyday</connection-url>
    <driver>mysql</driver>
    <security>
        <user-name>root</user-name>
        <password>votre_mot_de_passe</password>
    </security>
</datasource>
```

### Étape 5 — Build et déploiement

```bash
# Compiler le projet
mvn clean package

# Déployer sur WildFly
cp target/SmileEveryday.war $WILDFLY_HOME/standalone/deployments/

# Démarrer WildFly
$WILDFLY_HOME/bin/standalone.bat   # Windows
$WILDFLY_HOME/bin/standalone.sh    # Linux/Mac
```

### Étape 6 — Accéder à l'application

```
http://localhost:8080/SmileEveryday
```

---

## 👤 Utilisation

### Connexion Patient
1. Accéder à la page d'accueil
2. Cliquer sur **"Espace Patient"**
3. S'inscrire ou se connecter
4. Réserver un rendez-vous, consulter son dossier médical

### Connexion Dentiste
1. Accéder à `/connexionDentiste`
2. Saisir les identifiants dentiste
3. Accéder au **Dashboard Dentiste**
4. Gérer les rendez-vous et enregistrer les actes médicaux

### Connexion Aide-Soignant
1. Accéder à l'espace aide-soignant
2. Gérer les services médicaux
3. Valider les inscriptions patients

---

## 🔒 Sécurité

- ✅ **Gestion des sessions** utilisateur sécurisée
- ✅ **Vérification des autorisations** par rôle (Patient · Dentiste · Aide-Soignant)
- ✅ **Protection SQL** via JPA/Hibernate (requêtes paramétrées)
- ✅ **Validation des données** côté serveur
- ✅ **Hashage des mots de passe**
- ✅ **Gestion des erreurs** avec messages informatifs

---

## 📸 Screenshots

> 🚧 Screenshots à venir — lancer l'app et capturer les écrans principaux

| Accueil | Espace Patient | Dashboard Dentiste |
|---------|---------------|-------------------|
| `screenshots/home.png` | `screenshots/patient.png` | `screenshots/dentiste.png` |

---

## 🎬 Démo

> 🚧 Vidéo démo à venir

---

## 👨‍💻 Auteur

**Malek Ghanmi**
- 🎓 Étudiant en Génie Logiciel — ENIT
- 💼 LinkedIn : [linkedin.com/in/malek-ghanmi](#)
- 🐙 GitHub : [github.com/malekghanmi](#)

---

## 📄 Licence

Ce projet est sous licence **MIT** — voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

<div align="center">
  <strong>🦷 Smile Everyday — Parce que chaque sourire compte</strong>
</div>
