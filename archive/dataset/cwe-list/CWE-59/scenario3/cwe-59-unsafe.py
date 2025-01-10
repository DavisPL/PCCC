def read_config():
    with open('/etc/myapp/config.cfg', 'r') as f:
        return f.read()

config = read_config()
print(config)


# Exploit Example
# If an attacker replaces /etc/myapp/config.cfg with a symbolic link to a sensitive file like /etc/shadow,
# the script will read and possibly expose sensitive information.

# Attacker runs:
#ln -sf /etc/shadow /etc/myapp/config.cfg