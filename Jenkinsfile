#!groovy
node {
    stage "Checkout"
    checkout scm
    jobDsl targets: ['deployment/jenkins2/jobs.groovy'].join('\n'),
        removedJobAction: 'DELETE',
        removedViewAction: 'DELETE'
    stage "Build"
    sh "/usr/bin/env"
    sh "git rev-parse HEAD > .git_sha1"
    def git_sha1 = readFile(".git_sha1").trim()
    for (os_name in ['el6', 'el7']) {
      build job: "openvnet/rpmbuild",
            parameters: [
              [$class: 'StringParameterValue', name: 'GIT_REF', value: git_sha1],
              [$class: 'StringParameterValue', name: 'BUILD_OS', value: os_name]
            ]
    }
}