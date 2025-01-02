curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh


/home/khaleel/google-cloud-sdk/bin/gcloud compute reset-windows-password windows-server-2019-vm --zone=us-central1-a --user=odl_user_1556096