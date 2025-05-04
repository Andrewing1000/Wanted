node {
  stage('Checkout') {
    git credentialsId: 'jenkins-github',
        branch:        'jenkins',
        url:           'https://github.com/Andrewing1000/Wanted.git'
  }

  stage('Build & Up') {
    dir('backend') {
      sh 'docker-compose up --build -d'
    }
  }

  stage('Migrate') {
    dir('backend') {
      sh 'docker-compose run --rm wanted sh -c "python manage.py migrate"'
    }
  }

  stage('Unit Tests') {
    dir('backend') {
      sh 'docker-compose run --rm wanted sh -c "python manage.py test post.tests"'
    }
  }

  stage('Cleanup') {
    dir('backend') {
      sh 'docker-compose down --volumes'
    }
  }
}
