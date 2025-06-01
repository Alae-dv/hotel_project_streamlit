import streamlit as st
import sqlite3
import pandas as pd
from datetime import date

# Connexion à la base de données SQLite
conn = sqlite3.connect("hotel_db.sqlite")
cursor = conn.cursor()

st.set_page_config(page_title="Gestion Hôtels", layout="wide")
st.title("🏨 Système de Gestion d'Hôtels")

# Menu
menu = [
    "Accueil",
    "Liste des Réservations",
    "Liste des Clients",
    "Chambres Disponibles",
    "Ajouter un Client",
    "Ajouter une Réservation"
]
choix = st.sidebar.selectbox("Navigation", menu)

# Accueil
if choix == "Accueil":
    st.markdown("""
    ### Bienvenue sur l'interface de gestion hôtelière
    Cette application permet de gérer les clients, chambres, réservations, etc.
    Utilise le menu à gauche pour naviguer entre les différentes fonctionnalités.
    """)

# 1. Liste des réservations
elif choix == "Liste des Réservations":
    st.subheader("📅 Réservations")
    query = '''
        SELECT R.id_Reservation, C.Nom_complet, H.Ville AS Ville_Hotel,
               R.Date_arrivee, R.Date_depart
        FROM Reservation R
        JOIN Client C ON R.id_Client = C.id_Client
        JOIN Chambre CH ON R.id_Chambre = CH.id_Chambre
        JOIN Hotel H ON CH.id_Hotel = H.id_Hotel;
    '''
    df = pd.read_sql(query, conn)
    st.dataframe(df)

# 2. Liste des clients
elif choix == "Liste des Clients":
    st.subheader("👤 Clients")
    df = pd.read_sql("SELECT * FROM Client", conn)
    st.dataframe(df)

# 3. Chambres disponibles
elif choix == "Chambres Disponibles":
    st.subheader("🏨 Chambres disponibles entre deux dates")
    date_debut = st.date_input("Date d'arrivée", value=date.today())
    date_fin = st.date_input("Date de départ")

    if date_fin > date_debut:
        query = '''
            SELECT * FROM Chambre
            WHERE id_Chambre NOT IN (
                SELECT id_Chambre FROM Reservation
                WHERE NOT (
                    Date_depart < ? OR Date_arrivee > ?
                )
            );
        '''
        df = pd.read_sql(query, conn, params=(date_debut, date_fin))
        st.dataframe(df)
    else:
        st.warning("La date de départ doit être postérieure à la date d'arrivée.")

# 4. Ajouter un client
elif choix == "Ajouter un Client":
    st.subheader("➕ Ajouter un nouveau client")
    with st.form("ajout_client"):
        nom = st.text_input("Nom complet")
        adresse = st.text_input("Adresse")
        ville = st.text_input("Ville")
        cp = st.number_input("Code postal", step=1)
        email = st.text_input("Email")
        tel = st.text_input("Téléphone")
        submitted = st.form_submit_button("Ajouter")

        if submitted:
            cursor.execute("""
                INSERT INTO Client (Adresse, Ville, Code_postal, Email, Num_telephone, Nom_complet)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (adresse, ville, cp, email, tel, nom))
            conn.commit()
            st.success(f"Client {nom} ajouté avec succès !")

# 5. Ajouter une réservation
elif choix == "Ajouter une Réservation":
    st.subheader("🗓️ Nouvelle Réservation")
    clients = pd.read_sql("SELECT id_Client, Nom_complet FROM Client", conn)
    chambres = pd.read_sql("SELECT id_Chambre FROM Chambre", conn)

    with st.form("ajout_reservation"):
        client = st.selectbox("Client", clients["Nom_complet"])
        id_client = int(clients[clients["Nom_complet"] == client]["id_Client"].values[0])
        id_chambre = st.selectbox("Chambre", chambres["id_Chambre"].tolist())
        date_arr = st.date_input("Date d'arrivée")
        date_dep = st.date_input("Date de départ")
        submit = st.form_submit_button("Réserver")

        if submit and date_dep > date_arr:
            cursor.execute("""
                INSERT INTO Reservation (Date_arrivee, Date_depart, id_Client, id_Chambre)
                VALUES (?, ?, ?, ?)
            """, (date_arr, date_dep, id_client, id_chambre))
            conn.commit()
            st.success("Réservation enregistrée !")
        elif submit:
            st.warning("La date de départ doit être après la date d'arrivée.")
