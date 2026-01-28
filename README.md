# 🦷 Smile Everyday - Dental Clinic Management System

## 📝 Présentation du Projet
**Smile Everyday** est une solution logicielle complète conçue pour digitaliser la gestion d'un cabinet dentaire. En tant qu'ingénieur, ce projet démontre ma capacité à concevoir une architecture logicielle robuste et sécurisée répondant à des besoins métiers réels.



---

## 🛠 Architecture Technique
L'application repose sur une architecture **n-tier** (multicouche) respectant les standards **Jakarta EE** :

* **Backend** : EJB 3.1 (Enterprise JavaBeans) pour la logique métier et la gestion des transactions.
* **Persistance** : JPA (Java Persistence API) avec Hibernate pour le mapping objet-relationnel (ORM).
* **Frontend** : JSP & JSF avec un design moderne en **Glassmorphism** (CSS3 avancé).
* **Base de données** : MySQL.

## 🚀 Fonctionnalités Clés
- **Gestion des Rendez-vous** : Flux complet de réservation, validation et archivage.
- **Dossier Médical Informatisé** : Historique des patients et des soins prodigués.
- **Espace Recrutement** : Module de gestion des candidatures pour les aides-soignants.
- **Sécurité** : Validation des données côté serveur et gestion des sessions.

---

## 📂 Structure du Dépôt
- `/src` : Code source Java (Classes, EJB, Contrôleurs).
- `/database` : Script SQL de création de la base de données (`schema.sql`).
- `/webapp` : Interfaces utilisateurs (JSP, CSS, Assets).

## ⚙️ Installation
1.  Importer le script situé dans `/database` sur votre serveur MySQL.
2.  Configurer la DataSource dans votre serveur d'application (Glassfish/Payara).
3.  Déployer le fichier WAR généré.
