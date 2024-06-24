git config --global user.email "khaleel.org@gmail.com"
git config --global user.name "Khaleel Ahmad"
ssh-keygen -t ed25519 -C "khaleel.org@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
