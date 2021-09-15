
```bash
dnf install -y git
dnf install -y npm
```

```
npm uninstall nodemon
sudo npm install -g --force nodemon
```

```
cd backend
nohup npm start &
```

```
cd client
npm install -g create-react-app
npm install --save react react-dom
npm run-script build
npm install -g serve
nohup serve -s build &
```


Install Mongo-express on CentOS
git clone https://github.com/mongo-express/mongo-express.git
cp mongo-express/config.default.js mongo-express/config.js
vim mongo-express/config.js
cd mongo-express/
npm run build
node app




https://github.com/huggingface/Mongoku

npm i -g pm2
pm2 start server.js
pm2 list
pm2 show server
pm2 monit
pm2 logs
pm2 stop server
pm2 delete server

