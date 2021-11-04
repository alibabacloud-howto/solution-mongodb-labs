# Create an E-Commerce Web App with Node.js Express Framework and MongoDB on Alibaba Cloud

You can access the tutorial artifact including deployment script (Terraform), related source code, sample data and instruction guidance from the github project:
[https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/e-commerce-application](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/e-commerce-application)

More tutorial around Alibaba Cloud Database, please refer to:
[https://github.com/alibabacloud-howto/database](https://github.com/alibabacloud-howto/database)

---
### Overview

This is a demo E-Commerce online store web application that is built with [Node.js](https://nodejs.org/) [Express framework](https://expressjs.com/). The backend data store is on MongoDB. In this tutorial, I will show the steps of build and deployment on [Alibaba Cloud ECS](https://www.alibabacloud.com/product/ecs) and [MongoDB](https://www.alibabacloud.com/product/apsaradb-for-mongodb).

These are the key features of this web application:
- Manage product via ``admin`` account
- Register and login with user
- Navigate, add product to shopping cart
- Place order

Deployment architecture:

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/archi.png)

---
### Index

- [Step 1. Use Terraform to provision ECS and MongoDB database on Alibaba Cloud](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/e-commerce-application#step-1-use-terraform-to-provision-ecs-and-mongodb-database-on-alibaba-cloud)
- [Step 2. Deploy and setup Node.js and other basic components on ECS](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/e-commerce-application#step-2-deploy-and-setup-nodejs-and-other-basic-components-on-ecs)
- [Step 3. Build and deploy the web application](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/e-commerce-application#step-3-build-and-deploy-the-web-application)
- [Step 4. Install Mongoku on ECS to manage data on MongoDB](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/e-commerce-application#step-4-install-mongoku-on-ecs-to-manage-data-on-mongodb)

---
### Step 1. Use Terraform to provision ECS and MongoDB database on Alibaba Cloud

If you are the 1st time to use Terraform, please refer to [https://github.com/alibabacloud-howto/terraform-templates](https://github.com/alibabacloud-howto/terraform-templates) to learn how to install and use the Terraform on different operating systems.

Run the [terraform script](https://github.com/alibabacloud-howto/solution-mongodb-labs/blob/main/e-commerce-application/deployment/terraform/main.tf) to initialize the resources (in this tutorial, we use MongoDB as backend database, so ECS and MongoDB are included in the Terraform script). Please specify the necessary information and region to deploy.

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/apache-airflow/images/tf-parms.png)

After the Terraform script execution finished, the ECS instance information are listed as below.

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/interactive-roadmap/images/tf-done.png)

- ``eip_ecs``: The public EIP of the ECS for web app host

For the MongoDB instance information, please go to the Alibaba Cloud MongoDB web console [https://mongodb.console.aliyun.com/](https://mongodb.console.aliyun.com/) to get the connection URI.

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/interactive-roadmap/images/mongodb-1.png)

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/interactive-roadmap/images/mongodb-2.png)

By default, the username and password are ``root`` and ``N1cetest`` respectively, which are preset in the terraform provision script. If you've already changed it, please update accordingly.

Please replace the string ``****`` with ``N1cetest`` in the connection URI string, such as:
``mongodb://root:N1cetest@dds-xxxx.mongodb.rds.aliyuncs.com:3717,dds-xxxx.mongodb.rds.aliyuncs.com:3717/admin?replicaSet=mgset-55560033``

The MongoDB connection URI will be used later when deploying the web application.

---
### Step 2. Deploy and setup Node.js and other basic components on ECS

Please log on to ECS with ``ECS EIP``. By default, the password is ``N1cetest``, which is preset in the terraform provision script in Step 1. If you've already changed it, please update accordingly.

```bash
ssh root@<ECS_EIP>
```

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/apache-ofbiz/images/ecs-logon.png)

Execute the following commands to install Git client, Node.js.

```bash
dnf install -y git
dnf install -y npm
```

---
### Step 3. Build and deploy the web application

Execute the command to checkout the project [https://github.com/alibabacloud-howto/solution-mongodb-labs.git](https://github.com/alibabacloud-howto/solution-mongodb-labs.git) from github.

```
git clone https://github.com/alibabacloud-howto/solution-mongodb-labs.git
```

Execute the commands and edit the ``.env`` file to setup the MongoDB connection URI (got in the Step 1), then save the changes to the ``.env`` file. By default, I will use ``3000`` as the web app port, if you'd like to change it, please update accordingly.

```
cd ~/solution-mongodb-labs/e-commerce-application
vim .env
```

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/env.png)

Execute the following commands to build and install the app.

```
npm install
```

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/npm-client-build.png)

Now execute the following commands to start the web app.

```
cd ~/solution-mongodb-labs/e-commerce-application
npm start
```

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/npm-start.png)

Then let's open ``http://<ECS_EIP>:3000/`` in web browser to visit the web app.

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/web-app.png)

Usually, we need to run the Node.js app as daemon process. Now, let's install [pm2](https://pm2.io/) to start or manage the lifecycle of the Node.js web app.
First, enter ``Ctrl + C`` to stop the web app process started by executing ``npm start`` before. Then please execute the following commands to install pm2 and start the web app via pm2.

```
cd ~/solution-mongodb-labs/e-commerce-application
npm i -g pm2
pm2 start app.js
```

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/pm2-start.png)

Then let's open ``http://<ECS_EIP>:3000/`` again in web browser to visit the web app.

Let's do some simple operation on it,
- Sign Up ``admin`` account for managing product

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/admin.png)

- Add Product. Let's add iPhone 13 product family for the demo. For the product image URL, I will use the following URLs. Also, the product can be edited.
  - iPhone 13 mini: https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/iphone-13-mini-blue-select-2021.png
  - iPhone 13: https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/iphone-13-family-select-2021.jpeg
  - iPhone 13 pro: https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/iphone-13-pro-blue-select.png
  - iPhone 13 pro max: https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/iphone-13-pro-max-gold-select.png

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/add-product-1.png)

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/add-product-2.png)

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/edit-product.png)

- Register a normal user and play around

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/cart-1.png)

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/shipping.png)

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/shipping-details.png)

---
### Step 4. Install Mongoku on ECS to manage data on MongoDB

Execute the following commands to install open source MongoDB Web Admin tool [Mongoku](https://github.com/huggingface/Mongoku) on ECS to manage data on MongoDB.

```
cd ~
npm install -g mongoku
mongoku start --pm2
```

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/start-mongoku.png)

Then let's open ``http://<ECS_EIP>:3100/`` again in web browser to visit the Mongoku Web Admin. Mongoku use ``3100`` port for web app by default. I've already set this in the security group rule within the [Terraform script](https://github.com/alibabacloud-howto/solution-mongodb-labs/blob/main/e-commerce-application/deployment/terraform/main.tf).

Now we can add the MongoDB connection URI here as the server to navigate and manage the data for this online store e-Commerce web app via Mongoku. Please enjoy.

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/interactive-roadmap/images/mongoku-1.png)

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/e-commerce-application/images/mongoku-2.png)