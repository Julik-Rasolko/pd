import os
import time

sbatch_code = '''#!/bin/bash
#
#SBATCH --ntasks={}
#SBATCH --cpus-per-task=1
#SBATCH --partition=RT
#SBATCH --job-name=example
#SBATCH --comment="Run mpi from config"
#SBATCH --output=out.txt
#SBATCH --error=error.txt
mpiexec ./a.out {}'''

data = open("data.txt", "a")
for p in range(1, 9):
    for N in [1000, 1000000, 100000000]:
        with open("run_sbatch_config.sh", "w") as sbatch_old_code:
            sbatch_old_code.write(sbatch_code.format(p, N))
        os.system("sbatch run_sbatch_config.sh")
        time.sleep(3)
        with open("out.txt", "r") as out:
            curr_out = out.read()
            for line in curr_out.split('\n'):
                if line.split(' ')[0] == 'Boost:':
                    curr_data = line
                    break
            data.write("{} {} {}".format(p, N, curr_data))
        os.system("rm out.txt")
data.close()
