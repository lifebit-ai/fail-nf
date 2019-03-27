## Fail-nf

A mini (dumb) nextflow pipeline to test pipeline failures in general :D.

## Usage

Running without parameters will run the pipeline to completion sucessfully:

```
nextflow run main.nf
```

### Simulate failures

#### Intermitent failures

To simulate a process with intermitent failures (some process executions fail while
others pass) that **retry up to 3 times and them the error is ignored**:

```
nextflow run main.nf --alwaysPassIntermitentProcess=false
```

You can override the default error strategy using a parameter as well:

```
nextflow run main.nf --alwaysPassIntermitentProcess=false \
  --intermitentProcessErrorStrategy="terminate"
```

### Simulate failure of terminal (non-critical) process

To simulate the failure of a "secondary" non-critical process, which is ignored and
does not prevent the rest of the pipeline to complete:

```
nextflow run main.nf --abortTerminalProcess
```

The default error strategy for this process can also be override:

```
nextflow run main.nf --abortTerminalProcess \
  --terminalProcessErrorStrategy="terminate"
```

### Simulate critical process failure

To simulate the failure of a critical pipeline process that prevents downstream processes
from being executed:

```
nextflow run main.nf --abortCriticalProcess
```

### Simulate missing output file failure

To simulate the failure of processes due to missing declared output files:

```
nextflow run main.nf --forceMissingOutputFail
```

## Change simulated run time

You can set different ranges of run times (in seconds) for three processes, which
can be combined with any of the failure options above:

```
nextflow run main.nf --terminalProcessTimeRange="10-20" \
  --intermitentProcessTimeRange="1-1" \
  --missingOutputProcessTimeRange="100-120"
```