pipeline {
    agent any

    environment {
        PATH = "$PATH:/opt/maven/apache-maven-3.9.9/bin"
        GIT_REPO = 'https://github.com/Ehtishamul-Hassan/Springboot-LibraryManagementSystem.git'
        BRANCH = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init
                        terraform validate
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Wait for Instances') {
            steps {
                sh 'sleep 30'
            }
        }

        stage('Configure Sonar using Ansible') {
            steps {
                dir('ansible') {
                    sh '''
                        ansible-playbook -i inventory/aws_ec2.yml install_sonar.yml \
  --private-key /home/jenkins/.ssh/ansible_key \
  -u ec2-user

                    '''
                }
            }
        }

        stage('Configure Nexus using Ansible') {
            steps {
                dir('ansible') {
                    sh '''
                        ansible-playbook -i inventory/aws_ec2.yml install_nexus.yml \
  --private-key /home/jenkins/.ssh/ansible_key \
  -u ec2-user

                    '''
                }
            }
        }

        stage('Configure Docker using Ansible') {
            steps {
                dir('ansible') {
                    sh '''
                        ansible-playbook -i inventory/aws_ec2.yml docker.yml \
  --private-key /home/jenkins/.ssh/ansible_key \
  -u ec2-user

                    '''
                }
            }
        }

        stage('Code Quality') {
            steps {
                withCredentials([string(credentialsId: 'sonar-creds', variable: 'SONAR_TOKEN')]) {
                    sh '''
                    mvn sonar:sonar \
                      -Dsonar.projectKey=springboot_lms \
                      -Dsonar.host.url=http://65.2.172.7:9000/ \
                      -Dsonar.login=$SONAR_TOKEN
                '''
                }
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Artifact') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'Springboot-LibraryManagementSystem', classifier: '', file: 'target/Springboot-LibraryManagementSystem-0.0.1-SNAPSHOT.jar', type: 'jar']], credentialsId: 'nexus-cred', groupId: 'com.java', nexusUrl: '13.127.145.234:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'springartifact', version: '0.0.1-SNAPSHOT'
            }
        }

        stage('Download JAR from Nexus') {
            steps {
                sh """
ssh -i /home/jenkins/.ssh/ansible_key ec2-user@65.2.170.119 '
  mkdir -p /home/ec2-user/docker-build &&
  wget http://13.127.145.234:8081/repository/springartifact/com/java/Springboot-LibraryManagementSystem/0.0.1-SNAPSHOT/Springboot-LibraryManagementSystem-0.0.1-20250802.092730-1.jar -O /home/ec2-user/docker-build/app.jar
'
"""
            }
        }

        stage('Copy Docker Files to Remote EC2') {
            steps {
                sh '''
            scp -i ~/.ssh/ansible_key /var/lib/jenkins/workspace/JenkinsPipeline/Dockerfile ec2-user@65.2.170.119:/home/ec2-user/docker-build/
            scp -i ~/.ssh/ansible_key /var/lib/jenkins/workspace/JenkinsPipeline/docker-compose.yml ec2-user@65.2.170.119:/home/ec2-user/docker-build/
            scp -i ~/.ssh/ansible_key /var/lib/jenkins/workspace/JenkinsPipeline/.env ec2-user@65.2.170.119:/home/ec2-user/docker-build/

        '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
            ssh -i ~/.ssh/ansible_key ec2-user@65.2.170.119 "
                cd /home/ec2-user/docker-build
                docker-compose build
            "
        '''
            }
        }

        stage('Run Docker Compose') {
            steps {
                sh '''
            ssh -i ~/.ssh/ansible_key ec2-user@65.2.170.119 "
                cd /home/ec2-user/docker-build
                docker-compose up -d
            "
        '''
            }
        }
    }
}
