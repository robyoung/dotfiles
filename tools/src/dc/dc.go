package main

// Requires:
// sudo setcap cap_setgid=ep dc

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
	"syscall"
	"time"
)

func main() {
	var command string
	if len(os.Args) > 1 {
		command = os.Args[1]
	}
	// setGroups()

	switch command {
	case "test":
		fmt.Println("not implemented test")
	case "psql":
		err := commandPsql(os.Args[2:])
		if err != nil {
			log.Fatal(err)
		}
	case "flask":
		err := commandFlask(os.Args[2:])
		if err != nil {
			log.Fatal(err)
		}
	case "make":
		err := commandMake(os.Args[2:])
		if err != nil {
			log.Fatal(err)
		}
	case "alembic":
		fmt.Println("not implemented alembic")
	default:
		err := commandDockerCompose(os.Args[1:])
		if err != nil {
			log.Fatal(err)
		}
	}
}

func setGroups() {
	if err := syscall.Setgroups([]int{999}); err != nil {
		log.Fatal("Failed to set groups: ", err)
	}
	time.Sleep(10 * time.Millisecond)
	if gids, err := syscall.Getgroups(); err != nil {
		log.Print("Could not get current groups")
	} else {
		log.Print("Current groups: ", gids)
	}
}

func execOut(args ...string) (string, error) {
	cmd := exec.Command(args[0], args[1:]...)
	out, err := cmd.Output()
	if err != nil {
		return "", err
	} else {
		return strings.TrimSpace(string(out)), nil
	}
}

func getFromGit(name string) string {
	out, err := execOut("git", "config", fmt.Sprintf("robyoung.%s", name))
	if err != nil {
		return ""
	} else {
		return out
	}
}

func getContainerId(name string) string {
	for i := 0; i < 5; i++ {
		out, err := execOut("docker-compose", "ps", "-q", name)
		if err == nil {
			return out
		}
		time.Sleep(10 * time.Millisecond)
	}
	return ""
}

func commandPsql(args []string) error {
	pgContainerName := getFromGit("dc-postgres")
	if pgContainerName == "" {
		return fmt.Errorf("No postgres container name, set with git config --add robyoung.dc-postgres ...")
	}
	fmt.Println(pgContainerName)
	pgContainerId := getContainerId(pgContainerName)
	if pgContainerId == "" {
		return fmt.Errorf("No postgres container, is it started?")
	}
	tCols, err := execOut("tput", "cols")
	if err != nil {
		return fmt.Errorf("Could not get tput cols: %s", err)
	}
	tLines, err := execOut("tput", "lines")
	if err != nil {
		return fmt.Errorf("Could not get tput lines: %s", err)
	}

	allArgs := []string{
		"docker",
		"exec", "-ti",
		"--env", fmt.Sprintf("COLUMNS=%s", tCols),
		"--env", fmt.Sprintf("LINES=%s", tLines),
  }
  unixUser := getFromGit("dc-postgres-user")
  pgUser := getFromGit("dc-postgres-pguser")
  pgDatabase := getFromGit("dc-postgres-database")

  if unixUser != "" {
    allArgs = append(allArgs, "--user", unixUser)
  }

  allArgs = append(allArgs, pgContainerId, "psql")
  if pgUser != "" {
    allArgs = append(allArgs, "--user", pgUser)
  }
  if pgDatabase != "" && (len(args) == 0 || strings.HasPrefix(args[0], "-")) {
    allArgs = append(allArgs, pgDatabase)
  }
  allArgs = append(allArgs, args...)

	fmt.Println(allArgs)

	cmd := exec.Command(allArgs[0], allArgs[1:]...)
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	cmd.Stdin = os.Stdin
	start := time.Now()
	if err := cmd.Run(); err != nil {
		log.Fatal("Failed to run command: ", err)
	}
	elapsed := time.Now().Sub(start)
	fmt.Fprintln(os.Stderr, "Elapsed", elapsed.String())

	return nil
}

func commandMake(args []string) error {
	containerName := getFromGit("dc-make")
	if containerName == "" {
		return fmt.Errorf("No make container name, set with git config --add robyoung.dc-make ...")
	}
	allArgs := []string{"exec", containerName, "make"}
	allArgs = append(allArgs, args...)

	return commandDockerCompose(allArgs)
}

func commandFlask(args []string) error {
	flaskContainerName := getFromGit("dc-flask")
	if flaskContainerName == "" {
		return fmt.Errorf("No flask container name, set with git config --add robyoung.dc-flask ...")
	}
	flaskCommand := getFromGit("dc-flask-command")
	var flaskCommandArgs []string
	if flaskCommand == "" {
		flaskCommandArgs = []string{"flask"}
	} else {
		flaskCommandArgs = strings.Split(flaskCommand, " ")
	}
	allArgs := []string{"exec", flaskContainerName}
	allArgs = append(allArgs, flaskCommandArgs...)
	allArgs = append(allArgs, args...)

	return commandDockerCompose(allArgs)
}


func commandDockerCompose(args []string) error {
	cmd := exec.Command("docker-compose", args...)
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	cmd.Stdin = os.Stdin
	start := time.Now()
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("Failed to run command: %s", err)
	}
	elapsed := time.Now().Sub(start)
	fmt.Fprintln(os.Stderr, "Elapsed", elapsed.String())
	return nil
}
