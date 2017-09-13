import sys
import subprocess

n_th = int(sys.argv[1])

log_file = sys.argv[2]

command_line = " ".join(sys.argv[3:])

print command_line

process = subprocess.Popen(command_line,
                               shell=True, bufsize=-1,
                               stdin=subprocess.PIPE,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT,
                               close_fds=True)

with open(log_file, "w+") as f:

    for i, line in enumerate(process.stdout):
        
        f.write(line)
        
        if i % n_th == 0:
    
            sys.stdout.write(line)

    process.wait()

sys.exit(process.returncode)
