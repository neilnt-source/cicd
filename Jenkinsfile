pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 60, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    parameters {
        booleanParam(
            name: 'RUN_DUT_TEST',
            defaultValue: false,
            description: 'Run smoke tests against the configured test router'
        )
    }

    environment {
        BUILD_DIR = 'output'
        DUT_HOST = '192.168.1.1'
    }

    stages {
        stage('Checkout and validate') {
            steps {
                echo 'Starting embedded CI pipeline'
                sh '''
                    set -eu
                    git --version
                    test -x ci/build.sh
                    test -x ci/test_dut.sh
                '''
            }
        }

        stage('Build demo') {
            steps {
                sh './ci/build.sh'
            }
        }

        stage('Archive build artifacts') {
            steps {
                archiveArtifacts(
                    artifacts: 'output/**',
                    fingerprint: true
                )
            }
        }

        stage('DUT smoke test') {
            when {
                expression { return params.RUN_DUT_TEST }
            }
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'prpl-dut-ssh',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh '''
                        set -eu
                        : "${DUT_HOST:?Configure DUT_HOST in the job environment}"
                        export DUT_HOST SSH_USER SSH_KEY
                        ./ci/test_dut.sh
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed: ${currentBuild.currentResult}"
        }
        success {
            echo 'CI pipeline passed'
        }
        failure {
            echo 'CI pipeline failed. Inspect the stage logs.'
        }
    }
}
