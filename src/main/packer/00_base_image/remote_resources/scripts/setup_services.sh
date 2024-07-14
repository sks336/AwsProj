#!/bin/bash



createStartUpSystemctl() {

echo "#!/bin/bash

/usr/bin/run_nginx.sh

" | sudo tee /usr/bin/startup.sh

sudo chmod +x /usr/bin/startup.sh

}


createStartUpSystemctl



sudo systemctl daemon-reload
sudo systemctl enable startup.service
sudo systemctl start startup.service
sudo systemctl status startup.service


