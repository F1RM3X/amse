import os
import requests

# Liste des films et de leurs URL d'image sur Wikipédia
films = {
    "The Dark Knight": "https://upload.wikimedia.org/wikipedia/en/a/a7/Dark_Knight.jpg",
    "500 Days of Summer": "https://upload.wikimedia.org/wikipedia/en/8/8c/500_Days_of_Summer.jpg",
    "Casino Royale": "https://upload.wikimedia.org/wikipedia/en/5/5f/Casino_Royale_2006_Poster.jpg",
    "Spider-Man 2 (2004)": "https://upload.wikimedia.org/wikipedia/en/0/0d/Spider-Man_2_poster.jpg",
    "Interstellar": "https://upload.wikimedia.org/wikipedia/en/9/9b/Interstellar_film_poster.jpg",
    "Taxi Driver": "https://upload.wikimedia.org/wikipedia/en/8/8f/Taxi_Driver_poster.jpg",
    "Star Wars: Episode III – Revenge of the Sith": "https://upload.wikimedia.org/wikipedia/en/6/6e/Star_Wars_Episode_III_Revenge_of_the_Sith_poster.jpg",
    "Jurassic Park": "https://upload.wikimedia.org/wikipedia/en/e/e7/Jurassic_Park_poster.jpg",
    "Catch Me If You Can": "https://upload.wikimedia.org/wikipedia/en/0/0d/Catch_Me_If_You_Can_poster.jpg",
    "10 Things I Hate About You": "https://upload.wikimedia.org/wikipedia/en/7/7d/10_Things_I_Hate_About_You.jpg",
    "La La Land": "https://upload.wikimedia.org/wikipedia/en/2/2d/La_La_Land_%28film%29_poster.jpg",
    "Whiplash": "https://upload.wikimedia.org/wikipedia/en/8/8d/Whiplash_poster.jpg",
    "The Intern": "https://upload.wikimedia.org/wikipedia/en/0/0d/The_Intern_film_poster.jpg",
    "One Day": "https://upload.wikimedia.org/wikipedia/en/0/0d/One_Day_film_poster.jpg",
    "Black Swan": "https://upload.wikimedia.org/wikipedia/en/8/8d/Black_Swan_poster.jpg",
    "Se7en": "https://upload.wikimedia.org/wikipedia/en/8/8f/Se7en_movie_poster.jpg",
    "Gone Girl": "https://upload.wikimedia.org/wikipedia/en/0/0d/Gone_Girl_film_poster.jpg",
    "Mission: Impossible – Rogue Nation": "https://upload.wikimedia.org/wikipedia/en/0/0d/Mission_Impossible_Rogue_Nation.jpg",
    "War of the Worlds": "https://upload.wikimedia.org/wikipedia/en/1/1e/War_of_the_Worlds_2005_poster.jpg",
    "Minority Report": "https://upload.wikimedia.org/wikipedia/en/6/6d/Minority_Report_poster.jpg",
    "Notting Hill": "https://upload.wikimedia.org/wikipedia/en/1/1e/Notting_Hill_%28film%29_poster.jpg",
    "The Incredibles": "https://upload.wikimedia.org/wikipedia/en/0/0b/The_Incredibles.jpg",
    "Ratatouille": "https://upload.wikimedia.org/wikipedia/en/5/5d/RatatouillePoster.jpg",
    "Cars": "https://upload.wikimedia.org/wikipedia/en/3/3d/Cars_2006.jpg",
    "Inside Out": "https://upload.wikimedia.org/wikipedia/en/0/0d/Inside_Out_2015.jpg",
    "Harry Potter and the Goblet of Fire": "https://upload.wikimedia.org/wikipedia/en/5/5f/Harry_Potter_and_the_Goblet_of_Fire_poster.jpg",
    "Un Monstre à Paris": "https://upload.wikimedia.org/wikipedia/en/0/0d/Un_Monstre_%C3%A0_Paris.jpg",
    "We Live in Time": "https://upload.wikimedia.org/wikipedia/en/0/0d/We_Live_in_Time.jpg",
    "Star Wars: Episode V – The Empire Strikes Back": "https://upload.wikimedia.org/wikipedia/en/3/3c/Empire_Strikes_Back.jpg",
    "Forrest Gump": "https://upload.wikimedia.org/wikipedia/en/6/67/Forrest_Gump_poster.jpg"
}

# Dossier où les images seront enregistrées
dossier_images = 'tp1/imagess'

# Crée le dossier s'il n'existe pas
if not os.path.exists(dossier_images):
    os.makedirs(dossier_images)

# Téléchargement et sauvegarde des images
for film, url in films.items():
    try:
        # Récupérer l'image
        response = requests.get(url)
        response.raise_for_status()  # Vérifier que la requête a réussi
        
        # Définir le nom du fichier (le nom du film)
        nom_fichier = os.path.join(dossier_images, f"{film}.jpg")
        
        # Sauvegarder l'image
        with open(nom_fichier, 'wb') as f:
            f.write(response.content)
        print(f"Image pour {film} téléchargée avec succès.")
    
    except requests.exceptions.RequestException as e:
        print(f"Erreur lors du téléchargement de l'image pour {film}: {e}")
