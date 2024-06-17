```ini
  [Unit]
  Description=GitHub Webhook Listener

  [Service]
  ExecStart=/usr/bin/ruby /home/samuelpaget/webhook_listener/app.rb
  Restart=always
  User=samuelpaget
  Environment=PATH=/usr/bin:/usr/local/bin
  Environment=RACK_ENV=production
  WorkingDirectory=/home/samuelpaget/webhook_listener

  [Install]
  WantedBy=multi-user.target
```

sudo systemctl enable webhook_listener
sudo systemctl start webhook_listener