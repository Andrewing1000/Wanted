node {
  stage('Checkout') {
    git credentialsId: 'jenkins-github',
        branch:        'jenkins',
        url:           'https://github.com/Andrewing1000/Wanted.git'
  }
  stage('Build & Up') {
    sh 'docker-compose up --build -d'
  }
  stage('Migrate') {
    sh 'docker-compose run --rm wanted sh -c "python manage.py migrate"'
  }
  stage('Unit Tests') {
    sh 'docker-compose run --rm wanted sh -c "python manage.py test post.tests"'
  }
  stage('Cleanup') {
    sh 'docker-compose down --volumes'
  }
}
