import os
import json

def get_directory_structure(rootdir):
    """
    Crée une représentation récursive de la structure du répertoire.
    :param rootdir: Le répertoire racine à explorer.
    :return: Dictionnaire représentant la structure du répertoire.
    """
    dir_structure = {}
    for item in os.listdir(rootdir):
        # Ignorer les éléments liés à Git
        if item == '.git' or item.endswith('.git') or item.startswith('.git'):
            continue
        
        item_path = os.path.join(rootdir, item)
        if os.path.isdir(item_path):
            sub_structure = get_directory_structure(item_path)
            if sub_structure:  # Ne pas inclure les répertoires vides
                dir_structure[item] = sub_structure
        else:
            # Ignorer les fichiers Git spécifiques
            if item not in ['.gitignore', '.gitattributes', '.gitmodules']:
                dir_structure[item] = None
    return dir_structure

def save_structure_to_json(structure, output_file="project_structure.json"):
    """
    Sauvegarde la structure du répertoire dans un fichier JSON.
    :param structure: Le dictionnaire représentant la structure du répertoire.
    :param output_file: Nom du fichier JSON de sortie.
    """
    with open(output_file, "w") as f:
        json.dump(structure, f, indent=4)
    print(f"Structure sauvegardée dans {output_file}")

if __name__ == "__main__":
    project_path = input("Project Path : ")
    structure = get_directory_structure(project_path)
    save_structure_to_json(structure)