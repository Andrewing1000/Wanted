pipeline {
  agent any

  options {
    skipDefaultCheckout()
  }

  stages {
    stage('Checkout') {
        git branch: 'jenkins', url: 'https://github.com/Andrewing1000/Wanted.git'
    }
    stage('Build & Up') {
      steps {
        sh 'docker-compose up --build -d'
      }
    }
    stage('Migrate') {
      steps {
        sh 'docker-compose run --rm wanted sh -c "python manage.py migrate"'
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
