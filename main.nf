// Random numbers for starters
mainInputChannel = Channel.from(1,2,3,4,5,6,7,8,9)

process goodProcess {

  input:
  val x from mainInputChannel

  output:
  file("*.txt") into fileChannel
  val x into numericChannel

  script:
  """
  echo $x > file_${x}.txt
  """
}

channelToTerminalProcess = Channel.create()
channelToMainProcess = Channel.create()
fileChannel.into { channelToMainProcess; channelToTerminalProcess }

process terminalProcess {

  input:
  file(numeric_file) from channelToTerminalProcess

  script:
  """
  # Simulate the time the processes takes to finish
  timeToWait=\$(shuf -i ${params.terminalProcessTimeRange} -n 1)
  sleep \$timeToWait
  if [ "${params.abortTerminalProcess}" = true ]; then
    exit 1
  fi
  """
}

process intermitentFailProcess {

  label "intermitentProcess"

  input:
  val x from numericChannel

  output:
  file("*.fas") into fastaChannel

  script:
  """
  # Simulate the time the processes takes to finish
  timeToWait=\$(shuf -i ${params.intermitentProcessTimeRange} -n 1)
  sleep \$timeToWait
  # Test if number if even. If true, fail with an exit code 
  # equal to the number
  if [ \$((${x}%2)) -eq 0 ] && [ "${params.alwaysPassIntermitentProcess}" = false ]; then
    exit $x
  fi
  echo $x > file_${x}.fas
  """
}

process criticalProcess {
  input:
  file fasta from fastaChannel

  output:
  file fasta into newFastaChannel

  script:
  """
  if [ "${params.abortCriticalProcess}" = true ]; then
    exit 666
  fi
  """
}

process missingOutputFileProcess {

  input:
  file fasta from newFastaChannel

  output:
  file("*.mod") into voidChannel

  script:
  """
  # Simulate the time the processes takes to finish
  timeToWait=\$(shuf -i ${params.missingOutputProcessTimeRange} -n 1)
  sleep \$timeToWait
  if [ "${params.forceMissingOutputFail}" = false ]; then
    touch file_\$timeToWait.mod
  fi
  """
}