pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Migrate') {
      steps {
        sh 'docker-compose run --rm wanted sh -c "python manage.py migrate"'
      }
    }
    stage('Build & Up') {
      steps {
        sh 'docker-compose up --build -d'
      }
    }
    stage('Unit Tests') {
      steps {
        sh 'docker-compose run --rm wanted sh -c "python manage.py test post.tests"'
      }
    }
  }

  post {
    always {
      sh 'docker-compose down --volumes'
    }
  }
}
