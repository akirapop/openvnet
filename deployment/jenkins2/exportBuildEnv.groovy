import hudson.model.*
import java.nio.file.Path

def iterate_build_params(PrintWriter out) {
  // http://stackoverflow.com/questions/31394647/how-to-access-list-of-jenkins-job-parameters-from-within-a-jobdsl-script
  Build build = Executor.currentExecutor().currentExecutable
  ParametersAction parametersAction = build.getAction(ParametersAction)
  parametersAction.parameters.each { ParameterValue v ->
      out.println "${v.name}=${v.value}"
  }
}

if (binding.hasVariable("path")) {
  def f = new File(path)
  if( ! f.toPath().isAbsolute() ){
    f = new File(build.workspace.remote).toPath().resolve(path).toFile()
  }
  f.withPrintWriter { p ->
    iterate_build_params(p)
  }
}else {
  iterate_build_params(out)
}
