import os
import requests

# Liste des films
films = [
    "The Dark Knight",
    "500 Days of Summer",
    "Casino Royale",
    "Spider-Man 2 (2004)",
    "Interstellar",
    "Taxi Driver",
    "Star Wars: Episode III – Revenge of the Sith",
    "Jurassic Park",
    "Catch Me If You Can",
    "10 Things I Hate About You",
    "La La Land",
    "Whiplash",
    "The Intern",
    "One Day",
    "Black Swan",
    "Se7en",
    "Gone Girl",
    "Mission: Impossible – Rogue Nation",
    "War of the Worlds",
    "Minority Report",
    "Notting Hill",
    "The Incredibles",
    "Ratatouille",
    "Cars",
    "Inside Out",
    "Harry Potter and the Goblet of Fire",
    "Un Monstre à Paris",
    "We Live in Time",
    "Star Wars: Episode V – The Empire Strikes Back",
    "Forrest Gump",
    "Alien",
    "Inception",
    "The Prestige",
    "Titanic",
    "Shutter Island",
    "Gangs of New York",
    "Zodiac",
    "Panic Room",
    "The Social Network",
    "Skyfall"
]

# Dossier où les images seront enregistrées
dossier_images = 'images_films'

# Crée le dossier s'il n'existe pas
if not os.path.exists(dossier_images):
    os.makedirs(dossier_images)

# Fonction pour récupérer l'image d'affiche à partir d'OMDb API
def get_image_url(film_name):
    # L'URL de l'OMDb API (version gratuite, pas de clé API nécessaire pour les requêtes publiques)
    api_url = f"http://www.omdbapi.com/?t={film_name}&apikey=703021a8"
    response = requests.get(api_url)
    data = response.json()

    # Vérifie si la requête a réussi et s'il y a une image
    if data.get('Response') == 'True' and 'Poster' in data:
        return data['Poster']
    return None

# Téléchargement et sauvegarde des images
for film in films:
    try:
        # Récupérer l'URL de l'image
        image_url = get_image_url(film)
        
        if image_url and image_url != "N/A":
            # Télécharger l'image
            response = requests.get(image_url)
            response.raise_for_status()  # Vérifier que la requête a réussi
            
            # Définir le nom du fichier (le nom du film)
            nom_fichier = os.path.join(dossier_images, f"{film}.jpg")
            
            # Sauvegarder l'image
            with open(nom_fichier, 'wb') as f:
                f.write(response.content)
            print(f"Image pour {film} téléchargée avec succès.")
        else:
            print(f"Aucune image trouvée pour {film}.")
    
    except requests.exceptions.RequestException as e:
        print(f"Erreur lors du téléchargement de l'image pour {film}: {e}")
