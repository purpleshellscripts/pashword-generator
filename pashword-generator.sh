#!/bin/bash

#Check if OpenSSL is installed
if openssl version >> /dev/null; then
    echo "Using $(openssl version)"
    echo
else
    echo "OpenSSL installation not found. This program uses OpenSSL to generate passwords. Please install OpenSSL to use this program."
    exit 1
fi

## Generate functions ##
# Lowercase
lc()    {
    while [ "${#pw}" -lt 128 ]; do
        pw+=$(openssl rand -base64 64 | tr -dc 'a-z')
    done
    echo "${pw:0:128}"
}

# Lowercase and uppercase
lcuc()    {
    while [ "${#pw}" -lt 128 ]; do
        pw+=$(openssl rand -base64 64 | tr -dc 'A-Za-z')
    done
    echo "${pw:0:128}"
}

# Lowercase, uppercase, and numbers
lcucn()    {
    while [ "${#pw}" -lt 128 ]; do
        pw+=$(openssl rand -base64 64 | tr -dc 'A-Za-z0-9')
    done
    echo "${pw:0:128}"
}

# Lowercase, uppercase, numbers, and symbols
lcucns()    {
    while [ "${#pw}" -lt 128 ]; do
        pw+=$(openssl rand -base64 64 | tr -dc 'A-Za-z0-9!@#$%^&*()_+=-[]{}:;,.?/<>~')
    done
    echo "${pw:0:128}"
}

# Hexadecimal
hex()   {
    openssl rand -hex 16
    while [ "${#pw}" -lt 128 ]; do
        pw+=$(openssl rand -hex 16)
    done
    echo "${pw:0:128}"
}

# Ask for the number of characters
DEFAULT_LENGTH=32
echo "Maximum password length is 128 characters."
printf "Enter desired password length or press Enter for the default length of %s: " "$DEFAULT_LENGTH"
read -r LENGTH

if [ -n "$LENGTH" ] && ! [[ "$LENGTH" =~ ^[0-9]+$ ]]; then
    echo "Invalid length value entered."
    exit 1
fi

if [ -z "$LENGTH" ]; then
    printf "Using default password length: %s\n" "$DEFAULT_LENGTH"
    LENGTH="$DEFAULT_LENGTH"
else
    echo "Password length: $LENGTH"
fi

if [ "$LENGTH" -le 0 ] || [ "$LENGTH" -gt 128 ]; then
    echo "Invalid length value entered."
    exit 1
fi
echo

# Ask for complexity
DEFAULT_COMPLEXITY=0
cat <<EOF
[0]: Default (lowercase, uppercase, numbers, and symbols)
[1]: Lowercase
[2]: Lowercase and uppercase
[3]: Lowercase, uppercase, and numbers
[4]: Lowercase, uppercase, numbers, and symbols
[5]: Hexadecimal
EOF
echo

printf "Enter a number to select the desired password complexity or press Enter to select default complexity: %s: " "$DEFAULT_COMPLEXITY"
read -r COMPLEXITY

if [ -n "$COMPLEXITY" ] && ! [[ "$COMPLEXITY" =~ ^[0-5]+$ ]]; then
    echo "Invalid complexity value entered."
    exit 1
fi

if [ -z "$COMPLEXITY" ]; then
        printf "Using default complexity: %s\n" "$DEFAULT_COMPLEXITY"
        COMPLEXITY="$DEFAULT_COMPLEXITY"
else
    echo "Selected complexity: $COMPLEXITY"
fi

echo

case "$COMPLEXITY" in
  0)
    echo "Password: "
    lcucns | head -c "$LENGTH"
    echo
    ;;
  1)
    echo "Password: "
    lc | head -c "$LENGTH"
    echo
    ;;
  2)
    echo "Password: "
    lcuc | head -c "$LENGTH"
    echo
    ;;
  3)
    echo "Password: "
    lcucn | head -c "$LENGTH"
    echo
    ;;
  4)
    echo "Password: "
    lcucns | head -c "$LENGTH"
    echo
    ;;
  5)
    echo "Password: "
    hex | head -c "$LENGTH"
    echo
    ;;
  *)
    echo "Invalid complexity level."
    exit 1
    ;;
esac