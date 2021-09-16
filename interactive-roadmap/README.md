# Create an Interactive Roadmap Web App on Alibaba Cloud

You can access the tutorial artifact including deployment script (Terraform), related source code, sample data and instruction guidance from the github project:
[https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/interactive-roadmap](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/interactive-roadmap)

More tutorial around Alibaba Cloud Database, please refer to:
[https://github.com/alibabacloud-howto/database](https://github.com/alibabacloud-howto/database)

---
### Overview

This is an interesting web application to create interactive roadmap, timeline or milestone graph built with [Node.js](https://nodejs.org/) and [React](https://reactjs.org/). The backend data store is on MongoDB. In this tutorial, I will show the steps of build and deployment on [Alibaba Cloud ECS](https://www.alibabacloud.com/product/ecs) and [MongoDB](https://www.alibabacloud.com/product/apsaradb-for-mongodb).

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/luigi_metabase/images/archi.png)

Live demo: [http://roadmap-gallery.alibabacloudlabs.com/](http://roadmap-gallery.alibabacloudlabs.com/)

Deployment architecture:

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/luigi_metabase/images/archi.png)

---
### Index

- [Step 1. Use Terraform to provision ECS and MongoDB database on Alibaba Cloud]()
- [Step 2. Deploy and setup Node.js and other basic components on ECS]()
- [Step 3. Build and deploy the web application]()
- [Step 4. Install Mongoku on ECS to manage data on MongoDB]()

---
### Step 1. Use Terraform to provision ECS and MongoDB database on Alibaba Cloud

Run the [terraform script](https://github.com/alibabacloud-howto/solution-mongodb-labs/blob/main/interactive-roadmap/deployment/terraform/main.tf) to initialize the resources (in this tutorial, we use MongoDB as backend database, so ECS and MongoDB are included in the Terraform script). Please specify the necessary information and region to deploy.

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/apache-airflow/images/tf-parms.png)

After the Terraform script execution finished, the ECS instance information are listed as below.

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/luigi_metabase/images/tf-done.png)

- ``eip_ecs``: The public EIP of the ECS for Azkaban installation host

For the MongoDB instance information, please go to the Alibaba Cloud MongoDB web console [https://mongodb.console.aliyun.com/](https://mongodb.console.aliyun.com/) to get the connection URI.

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/luigi_metabase/images/tf-done.png)

---
### Step 2. Deploy and setup Luigi and Metabase on ECS with RDS PostgreSQL

Please log on to ECS with ``ECS EIP``. By default, the password is ``N1cetest``, which is preset in the terraform provision script in Step 1. If you've already changed it, please update accordingly.

```bash
ssh root@<ECS_EIP>
```

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/apache-ofbiz/images/ecs-logon.png)







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




https://github.com/huggingface/Mongoku

npm i -g pm2
pm2 start server.js
pm2 list
pm2 show server
pm2 monit
pm2 logs
pm2 stop server
pm2 delete server






This tutorial is modified based on [https://github.com/alexander-braun/interactive-roadmap](https://github.com/alexander-braun/interactive-roadmap) to run on Alibaba Cloud. I've done some modification and customization to make them all work on Alibaba Cloud.