// Scripted Pipeline: full control over checkout
node {
  // 1) Clone your repo with credentials
  stage('Checkout') {
    git credentialsId: 'jenkins-github',
        branch:        'jenkins',
        url:           'https://github.com/Andrewing1000/Wanted.git'
  }

  // 2) Build and start your Docker stack
  stage('Build & Up') {
    sh 'docker-compose up --build -d'
  }

  // 3) Run migrations
  stage('Migrate') {
    sh 'docker-compose run --rm wanted sh -c "python manage.py migrate"'
  }

  // 4) Run unit tests
  stage('Unit Tests') {
    sh 'docker-compose run --rm wanted sh -c "python manage.py test post.tests"'
  }

  // 5) Tear down
  stage('Cleanup') {
    sh 'docker-compose down --volumes'
  }
}
