# Create a Social Web App with Next.js and MongoDB on Alibaba Cloud

You can access the tutorial artifact including deployment script (Terraform), related source code, sample data and instruction guidance from the github project:
[https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/nextjs-mongodb-app](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/nextjs-mongodb-app)

More tutorial around Alibaba Cloud Database, please refer to:
[https://github.com/alibabacloud-howto/database](https://github.com/alibabacloud-howto/database)

---
### Overview

This is an [Next.js](https://nextjs.org/) and [MongoDB](https://www.mongodb.com/) social web application, designed with simplicity for learning and real-world applicability in mind with Next.js and MongoDB on cloud.
The original project is [https://github.com/hoangvvo/nextjs-mongodb-app](https://github.com/hoangvvo/nextjs-mongodb-app), we've done some modification and customization with make it all work on [Alibaba Cloud ECS](https://www.alibabacloud.com/product/ecs) and [MongoDB](https://www.alibabacloud.com/product/apsaradb-for-mongodb).

Deployment architecture:

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/nextjs-mongodb-app/images/archi.png)

---
### Index

- [Step 1. Use Terraform to provision ECS and MongoDB database on Alibaba Cloud](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/nextjs-mongodb-app#step-1-use-terraform-to-provision-ecs-and-mongodb-database-on-alibaba-cloud)
- [Step 2. Install Next.js on ECS](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/nextjs-mongodb-app#step-2-install-nextjs-on-ecs)
- [Step 3. Deploy and run the web app](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/nextjs-mongodb-app#step-3-deploy-and-run-the-web-app)
- [Step 4. Install Mongoku on ECS to manage data on MongoDB](https://github.com/alibabacloud-howto/solution-mongodb-labs/tree/main/nextjs-mongodb-app#step-4-install-mongoku-on-ecs-to-manage-data-on-mongodb)

---
### Step 1. Use Terraform to provision ECS and MongoDB database on Alibaba Cloud

Run the [terraform script](https://github.com/alibabacloud-howto/solution-mongodb-labs/blob/main/nextjs-mongodb-app/deployment/terraform/main.tf) to initialize the resources (in this tutorial, we use MongoDB as backend database, so ECS and MongoDB are included in the Terraform script). Please specify the necessary information and region to deploy.

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/apache-airflow/images/tf-parms.png)

After the Terraform script execution finished, the ECS instance information are listed as below.

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/nextjs-mongodb-app/images/tf-done.png)

- ``eip_ecs``: The public EIP of the ECS for web app host

Go to the Alibaba Cloud ECS console and you can see the ECS instance you just created.

![image desc](https://labex.io/upload/O/I/P/kPjLTkZ0DJ3a.jpg) 

Go to the Alibaba Cloud Mongodb console to view the Mongodb instance.

![image desc](https://labex.io/upload/V/F/V/A8LMwIVvpDXa.jpg)

---
### Step 2. Install Next.js on ECS

#### 2.1 Log into a new instance

Copy the public IP address of the "mongodb-tech" instance just created, and log in remotely via SSH.

![image desc](https://labex.io/upload/O/I/P/kPjLTkZ0DJ3a.jpg) 

> The default account name and password of the ECS instance:
> 
> Account name: root
> 
> Password: Aliyuntest123

```bash
ssh root@<ECS_EIP>
```

![image.png](https://github.com/alibabacloud-howto/opensource_with_apsaradb/raw/main/apache-ofbiz/images/ecs-logon.png)

#### 2.2 Install Next.js

Enter the following command to download the nodejs installation package.

```
wget https://labex-ali-data.oss-us-west-1.aliyuncs.com/nodejs/node-v16.9.1-linux-x64.tar.xz  
```

![image desc](https://labex.io/upload/E/S/W/UoJ9GXT0Fofr.jpg)

Enter the following command to decompress the installation package.

```
tar xf node-v16.9.1-linux-x64.tar.xz
```

![image desc](https://labex.io/upload/F/N/Q/En3V7Hvfmpmw.jpg)

Run the following command to move the decompressed directory to the /usr/local directory:

```
mv node-v16.9.1-linux-x64 /usr/local/node
```

![image desc](https://labex.io/upload/B/J/H/Pv8dYTacGzVW.jpg)

Run the ``vim /etc/profile`` command to open the environment variable configuration file. Append the following content to the end of the file.

```
export NODE_HOME=/usr/local/node
export PATH=$PATH:$NODE_HOME/bin
```

![image desc](https://labex.io/upload/D/Q/J/1o9C0jDPU5x3.jpg)

Run the following command to make the modification take effect.

```
source /etc/profile
```

![image desc](https://labex.io/upload/Q/D/U/ir0LOLaFzlpZ.jpg)

Run the following commands. You can see the corresponding service version, which indicates the installation is completed.

```
node -v

npm -v
```

![image desc](https://labex.io/upload/J/M/D/Yee86Gv9rzRK.jpg)

---
### Step 3. Deploy and run the web app

Enter the following command to install the git tool.

```
apt update && apt -y install git
```

![image desc](https://labex.io/upload/H/M/C/FjcbaxTjH1yz.jpg)

Enter the following command to create a projects directory and enter.

```
mkdir projects && cd projects
```

![image desc](https://labex.io/upload/V/C/G/o1ytZ8ma53W1.jpg)

Enter the following command to download the sample project.

```
git clone https://github.com/hoangvvo/nextjs-mongodb-app 

ls
```

![image desc](https://labex.io/upload/F/W/K/ZafhmDTK9rz3.jpg)

Enter the following command to enter the sample project directory.

```
cd nextjs-mongodb-app
```

![image desc](https://labex.io/upload/X/R/U/hm2sSKtFipQ1.jpg)

Enter the following command to install the nextjs framework dependency package.

```
npm install next react react-dom
```

![image desc](https://labex.io/upload/H/W/H/MdKDbaeN1pZJ.jpg)

Enter the command: ``vim .env``, create a ".env" configuration file, input with the following content and modify the connection address of Mongodb referring to the figure below.

```
MONGODB_URI=mongodb://root:Aliyuntest123@dds-3ns47c06f6d363141.mongodb.rds.aliyuncs.com:3717,dds-3ns47c06f6d363142.mongodb.rds.aliyuncs.com:3717/admin?replicaSet=mgset-55524405
CLOUDINARY_URL=cloudinary://741947492169653:vkyuRmZ3EbSULnkfXJdtSqwhURw@dbplcha6k
DB_NAME=admin
SENDGRID_API_KEY=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
EMAIL_FROM=averyniceguy@nextjs-mongodb.now.sh
WEB_URI=https://nextjs-mongodb.now.sh
SESSION_SECRET=keyboard cat
```

![image desc](https://labex.io/upload/R/K/E/BgOlYAFQgtTV.jpg)

The connection method to obtain MongoDB is as shown in the figure below. Please pay attention to replace "****" with the password "Aliyuntest123".

![image desc](https://labex.io/upload/Q/X/S/K0RXOAwGLE9s.jpg)

Enter the following command to start the project.

```
npm run dev
```

![image desc](https://labex.io/upload/S/C/H/oCdzRxO3ek2q.jpg)

Visit the public IP address of the current ECS in the browser, and the project is installed successfully.

![image desc](https://labex.io/upload/K/J/R/r7akBFLaItGD.jpg)

Users can register their own accounts to post messages.

![image desc](https://labex.io/upload/U/P/P/DfDbvgDFu08V.jpg)

Usually, we need to run the Node.js app as daemon process. Now, let's install [pm2](https://pm2.io/) to start or manage the lifecycle of the Node.js web app.
First, enter ``Ctrl + C`` to stop the web app process started by executing ``npm run dev`` before. Then please execute the following commands to install pm2 and start the web app via pm2.

```
npm i -g pm2
npm run build
```

```
pm2 start npm -- run start
```

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/nextjs-mongodb-app/images/pm2-start.png)

Then, visit the public IP address of the current ECS with port 3000 again in the browser, and the project is started by pm2 successfully.

---
### Step 4. Install Mongoku on ECS to manage data on MongoDB

Execute the following commands to install open source MongoDB Web Admin tool [Mongoku](https://github.com/huggingface/Mongoku) on ECS to manage data on MongoDB.

```
cd ~
npm install -g mongoku
mongoku start --pm2
```

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/nextjs-mongodb-app/images/start-mongoku.png)

Then let's open ``http://<ECS_EIP>:3100/`` again in web browser to visit the Mongoku Web Admin. Mongoku use ``3100`` port for web app by default. I've already set this in the security group rule within the [Terraform script](https://github.com/alibabacloud-howto/solution-mongodb-labs/blob/main/nextjs-mongodb-app/deployment/terraform/main.tf).

Now we can add the MongoDB connection URI here as the server to navigate and manage the data for this social web app via Mongoku. Please enjoy.

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/nextjs-mongodb-app/images/mongoku-1.png)

![image.png](https://github.com/alibabacloud-howto/solution-mongodb-labs/raw/main/nextjs-mongodb-app/images/mongoku-2.png)