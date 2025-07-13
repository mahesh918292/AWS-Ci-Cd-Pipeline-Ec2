# nodejs-express-on-aws-ec2

This repo hosts the source code for my YouTube tutorial on CI/CD from Github to an AWS EC2 instance via CodePipeline and CodeDeploy (https://www.youtube.com/watch?v=Buh3GjHPmjo). This tutorial uses a node.js express app as an example for the demo.

I also created a video to talk about how to fix some of the common CodeDeploy failures I have run into (https://www.youtube.com/watch?v=sXZVkOH6hrA). Below are a couple of examples:

```
ApplicationStop failed with exit code 1
```

```
The overall deployment failed because too many individual instances failed deployment, too few healthy instances are available for deployment, or some instances in your deployment group are experiencing problems.
```

===========================

EC2 script on creation to install the CodeDeploy Agent:

```
#!/bin/bash
sudo yum -y update
sudo yum -y install ruby
sudo yum -y install wget
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
```

Check if CodeDeploy agent is running:
```
sudo service codedeploy-agent status
```

Location for CodeDeploy logs:
```


/opt/codedeploy-agent/deployment-root/deployment-logs/codedeploy-agent-deployments.log
```

Uninstall CodeDeploy Agent:
```
sudo yum erase codedeploy-agent
```


<img width="1920" height="1080" alt="Screenshot (566)" src="https://github.com/user-attachments/assets/bd7a7a20-feb5-491a-9b87-ddd791961222" />
# Creaate an ec2 instance and add these policies inorder to access code in s3 and deploy to ec2


# Now Create a new pipeline,create a role for it,select source from where to upload files,tests ( optional ),give path of appspec.yml and create a pipeline


<img width="1920" height="1080" alt="Screenshot (567)" src="https://github.com/user-attachments/assets/e0f980c5-7250-460f-a922-67191ae1e52e" />
# After Creating pipeline this looks like this
<img width="1920" height="1080" alt="Screenshot (568)" src="https://github.com/user-attachments/assets/b62c5cb1-bd9d-4aa6-88e3-21c6ae8a5488" />
# Output 
<img width="1920" height="1080" alt="Screenshot (569)" src="https://github.com/user-attachments/assets/19b6bd33-8410-4ad0-a791-ca3ead667d5e" />

# Making a change to the code for the automatic ci/cd pipeline trigger
<img width="1920" height="1080" alt="Screenshot (570)" src="https://github.com/user-attachments/assets/2d1d0581-bc75-4e2a-ae96-6d4ae9bbf0e8" />
# Pipeline has been triggered and output will be updated


# Deployment Workflow

# AWS CodePipeline + CodeDeploy

**CodePipeline:**

- Connects to GitHub and pulls the latest source.
- Packages the code into a ZIP archive.
- Uploads the ZIP to an internal S3 bucket (artifact storage).
- Passes the S3 artifact location (URL) to CodeDeploy.

**CodeDeploy:**

- Receives the artifact S3 path from CodePipeline.
- The CodeDeploy Agent on the EC2 instance:
  - Downloads the ZIP from S3.
  - Extracts it to the instance.
  - Executes lifecycle hooks defined in `appspec.yml`.
