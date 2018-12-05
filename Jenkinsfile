#!/usr/bin/groovy
/*
To enable talking to user instance of Systemd, export XDG_RUNTIME_DIR, then restart Jenkins.

$ head ~/.profile ~/.config/systemd/user/dummy.*
==> /var/lib/jenkins/.profile <==
export XDG_RUNTIME_DIR=/run/user/$(id -u)

==> /var/lib/jenkins/.config/systemd/user/dummy.service <==
[Unit]
Description=Do nothing

[Service]
Type=oneshot
ExecStart=/bin/true

==> /var/lib/jenkins/.config/systemd/user/dummy.timer <==
[Unit]
Description=Run dummy no-op service

[Timer]
OnCalendar=yearly
*/

pipeline {
  agent any

  stages {

    stage('Build') {
      steps {
        script {
          sh 'make clean && make'
        }
      }
    } // stage

    stage('Test') {
      steps {
        script {
          withEnv(['OCF_ROOT=/usr/lib/ocf']) {
            sh '/usr/sbin/ocf-tester -d -v -n timer -o name=dummy -o user=1 ' +
              '$(readlink -f systemd-timer)'
          }
        }
      }
    } // stage

  } // stages

  post {
    success {
      script {
        def msg = sh(
          returnStdout: true,
          script: 'git log --oneline --format=%B -n 1 HEAD | head -n 1'
        )
        slackSend(
          message: "Built <$BUILD_URL|$JOB_NAME $BUILD_NUMBER>: $msg",
          color: "good"
        )
      }
    }
  }
}
