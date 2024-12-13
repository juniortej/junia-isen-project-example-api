import secrets

def generate_jwt_secret():
    """Generate a secure JWT secret."""
    return secrets.token_urlsafe(32)

def update_env_file(env_file_path, key, value):
    """Update or add a key-value pair in the .env file."""
    updated = False
    lines = []

    try:
        # Read the existing .env file
        with open(env_file_path, "r") as file:
            lines = file.readlines()
    except FileNotFoundError:
        print(f"⚠️  File {env_file_path} not found. A new one will be created.")

    # Open the .env file for writing (overwrite mode)
    with open(env_file_path, "w") as file:
        for line in lines:
            
            if line.startswith(f"{key}="):
                file.write(f"{key}={value}\n")
                updated = True
            else:
                file.write(line)

        
        if not updated:
            file.write(f"{key}={value}\n")

    print(f"✅ {key} updated successfully in {env_file_path}.")

if __name__ == "__main__":
    env_file = ".env"
    key_to_update = "JWT_SECRET"
    new_secret = generate_jwt_secret()

    update_env_file(env_file, key_to_update, new_secret)
    print(f"🔑 New {key_to_update}: {new_secret}")
