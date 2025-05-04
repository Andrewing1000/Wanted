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
          // note the space instead of dash
          sh 'docker compose up --build -d'
        }
      }
    }

    stage('Migrate') {
      steps {
        dir('backend') {
          sh 'docker compose run --rm wanted sh -c "python manage.py migrate"'
        }
      }
    }

    stage('Unit Tests') {
      steps {
        dir('backend') {
          sh 'docker compose run --rm wanted sh -c "python manage.py test post.tests"'
        }
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
