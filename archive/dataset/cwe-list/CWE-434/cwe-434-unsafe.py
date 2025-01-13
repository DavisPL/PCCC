def save_uploaded_file(file_content, filename):
    with open('/var/www/uploads/' + filename, 'wb') as f:
        f.write(file_content)

# Exploit Example
# An attacker could upload a file named shell.php containing malicious code.
# If the web server executes .php files in the upload directory, 
# the attacker can execute arbitrary code.


# Attacker runs:
# filename: shell.php
# file_content: PHP code for a web shell

