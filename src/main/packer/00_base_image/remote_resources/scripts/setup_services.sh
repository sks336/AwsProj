#!/bin/bash


# Start up nginx services!!

sudo systemctl daemon-reload
sudo systemctl enable nginx.service
sudo systemctl start nginx.service


