pipeline {
  agent any
  triggers {
    pollSCM('H/1 * * * *')
  }
  stages {
    stage('Checkout') {
      steps {
        git credentialsId: 'jenkins-github',
            branch: 'jenkins',
            url:    'https://github.com/Andrewing1000/Wanted.git'
      }
    }

    stage('Build') {
      steps {
        dir('backend') {
          sh 'docker compose build'
        }
      }
    }

    stage('Migrate') {
      steps {
        dir('backend') {
          sh 'docker compose run --rm wanted python manage.py migrate'
        }
      }
    }

    stage('Unit Tests') {
      steps {
        dir('backend') {
          sh 'docker compose run --rm wanted python manage.py test post.tests'
        }
      }
    }

    stage('Deploy') {
      steps {
        dir('backend') {
          sh 'docker compose up -d'
        }
      }
    }
  }

    // post {
  //   always {
  //     dir('backend') {
  //       sh 'docker compose up '
  //     }
  //   }
  // }
}

