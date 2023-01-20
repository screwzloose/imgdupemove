import os
from shutil import move
from PIL import Image
import dhash

def move_duplicates(source_dir, dest_dir):
    # Create a dictionary to store the hash values of the images
    image_hashes = {}
    for root, dirs, files in os.walk(source_dir):
        for file in files:
            if file.endswith('.jpg') or file.endswith('.jpeg') or file.endswith('.png'):
                file_path = os.path.join(root, file)
                # Check if the file exists and if the script has permission to read it
                if os.path.exists(file_path) and os.access(file_path, os.R_OK):
                    print(f'Processing file: {file_path}')
                    try:
                        # Open the image with PIL
                        image = Image.open(file_path)
                        # Generate a hash value for the image
                        image_hash = dhash.dhash_int(image)
                        # Check if the hash value already exists in the dictionary
                        if image_hash in image_hashes:
                            print(f'File {file_path} is a duplicate.')
                            # construct destination path for the file
                            destination_path = os.path.join(dest_dir, file)
                            # check if the file already exists in the destination directory
                            if os.path.exists(destination_path):
                                print(f'{destination_path} already exists, skipping')
                            else:
                                # move the file to the destination directory
                                move(file_path, destination_path)
                                print(f'Moving {file_path} to {destination_path}')
                        else:
                            # Add the hash value to the dictionary
                            image_hashes[image_hash] = file_path
                            print(f'File {file_path} is unique')
                    except Exception as e:
                        print(f'An error occurred while processing {file_path} : {e}')
                else:
                    print(f'Cannot access the file: {file_path}')
    print('Duplicate image search completed')

move_duplicates("/path/to/source/directory", "/path/to/destination/directory")
