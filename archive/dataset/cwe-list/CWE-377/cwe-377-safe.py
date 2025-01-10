import os
import tempfile


def create_temp_file():
    with tempfile.NamedTemporaryFile(mode='w', delete=False) as f:
        f.write("Temporary data")
        print(f"Temporary file created at: {f.name}")

create_temp_file()

