#!groovy
def BASE_NAME="openvnet"
SEED_WORKSPACE=new File(this.binding.getVariable('__FILE__') + "../../../../").getCanonicalPath()
folder(BASE_NAME)

job("${BASE_NAME}/rpmbuild") {
  parameters {
    stringParam 'LEAVE_CONTAINER', '0', 'Leave container after build for debugging.'
    stringParam 'REPO_BASE_DIR', '/var/www/html/repos', 'Path to create yum repository'
    stringParam 'BUILD_CACHE_DIR', '/var/lib/jenkins/build-cache', 'Directory for storing build cache archive'
    choiceParam 'BUILD_OS', ["el7", "el6"], 'Target OS name'
    stringParam 'GIT_REF', null, 'Git ref name'    
  }
  scm {
    scmNodes << new NodeBuilder().scm(class: "hudson.plugins.filesystem_scm.FSSCM") {
        path SEED_WORKSPACE
        clearWorkspace 'false'
        copyHidden 'true'
        filterEnabled 'false'
      }
    
  }
  steps {
    systemGroovyScriptFile("./deployment/jenkins2/exportBuildEnv.groovy") {
      binding('path', "./build.env")
    }
    shell("./deployment/docker/build.sh ./build.env")
  }
}