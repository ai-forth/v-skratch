/* -------
   This "c" element generates a table of constants that must be known to
   our system in order to pass suitable magic numbers to system calls.
   It's written in "c" since that's the most convenient way to obtain the
   values; includes aren't expanded into assembler source.  ORDER MUST BE
   MAINTAINED or offsets must be maintained in the FORTH system too.
   ------- */

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <termio.h>
#include <sys/mman.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/shm.h>

int GREG[100] = { 
  /*   0 */  O_RDONLY, O_WRONLY, O_RDWR, O_NDELAY, O_NONBLOCK,
  /*   5 */  O_APPEND, O_SYNC, O_CREAT, O_TRUNC, O_EXCL,
  /*  10 */  O_NOCTTY, SEEK_SET, SEEK_CUR, SEEK_END, STDIN_FILENO,
  /*  15 */  STDOUT_FILENO, STDERR_FILENO, MCL_CURRENT, MCL_FUTURE, SIGHUP,
  /*  20 */  SIGINT, SIGQUIT, SIGILL, SIGTRAP, SIGABRT,
  /*  25 */  0, SIGFPE, SIGKILL, SIGBUS, SIGSEGV,
  /*  30 */  SIGSYS, SIGPIPE, SIGALRM, SIGTERM, SIGUSR1,
  /*  35 */  SIGUSR2, SIGCHLD, SIGPWR, SIGWINCH, SIGURG,
  /*  40 */  SIGPOLL, SIGSTOP, SIGTSTP, SIGCONT, SIGTTIN,
  /*  45 */  SIGTTOU, SIGVTALRM, SIGPROF, SIGXCPU, SIGXFSZ,
  /*  50 */  0, 0, SIG_BLOCK, SIG_UNBLOCK, SIG_SETMASK,
  /*  55 */  SA_ONSTACK, SA_RESETHAND, SA_RESTART, SA_SIGINFO, SA_NODEFER,
  /*  60 */  SS_ONSTACK, SS_DISABLE, SIGSTKSZ, IPC_CREAT, IPC_EXCL,
  /*  65 */  SHM_R, SHM_W, IPC_RMID, SHM_LOCK, SHM_UNLOCK
};
