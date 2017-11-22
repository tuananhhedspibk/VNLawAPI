#!/bin/bash

if [ ! -f ./config/secrets.yml ]; then  
  echo -e "\nGenerating a secrets.yml file"

  # Random Keys
  KEY_DEV=$(rake secret)
  KEY_TEST=$(rake secret)

  # Generate the file
  cat > secrets.yml <<EOL
  development:  
    secret_key_base: ${KEY_DEV}

  test:  
    secret_key_ba se: ${KEY_TEST}

  production:  
    secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
EOL
fi
