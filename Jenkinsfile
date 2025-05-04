pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        git credentialsId: 'jenkins-github',
            branch: 'jenkins',
            url:    'https://github.com/Andrewing1000/Wanted.git'
      }
    }

    stage('Build & Up') {
        steps {
          dir('backend') {
            sh 'docker compose up --build -d --wait'
          }
        }
    }

    stage('Migrate') {
        steps {
          dir('backend') {
            // ejecuta migrate dentro del contenedor "wanted" que ya está corriendo
            sh 'docker compose exec -T wanted python manage.py migrate'
          }
        }
    }

    stage('Unit Tests') {
        steps {
          dir('backend') {
            sh 'docker compose exec -T wanted python manage.py test post.tests'
          }
        }
    }

    post {
      always {
        dir('backend') {
          sh 'docker compose down --volumes'
        }
      }
    }
  }
}
