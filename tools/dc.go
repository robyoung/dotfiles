package main

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
	setGroups()

	switch command {
	case "test":
		fmt.Println("not implemented test")
	case "psql":
		err := commandPsql(os.Args[2:])
		if err != nil {
			log.Fatal(err)
		}
	case "flask":
		fmt.Println("not implemented flask")
	case "alembic":
		fmt.Println("not implemented alembic")
	default:
		err := commandDockerCompose(os.Args[1:])
		if err != nil {
			log.Fatal(err)
		}
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
	out, err := execOut("docker-compose", "ps", "-q", name)
	if err != nil {
		return ""
	} else {
		return out
	}
}

func commandPsql(args []string) error {
	pgContainerName := getFromGit("dc-postgres")
	if pgContainerName == "" {
		return fmt.Errorf("No postgres container name, set with git config --add robyoung.dc-postgres ...")
	}
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
		"exec", "-ti",
		"--env", fmt.Sprintf("COLUMNS=%s", tCols),
		"--env", fmt.Sprintf("LINES=%s", tLines),
		"--user", "postgres", pgContainerId,
		"psql",
	}
	allArgs = append(allArgs, args...)


	cmd := exec.Command("docker", allArgs...)
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	cmd.Stdin = os.Stdin
	start := time.Now()
	if err := cmd.Run(); err != nil {
		log.Fatal("Failed to run command: ", err)
	}
	elapsed := time.Now().Sub(start)
	fmt.Println("Elapsed", elapsed.String())

	return nil
}

func setGroups() {
	if err := syscall.Setgroups([]int{999}); err != nil {
		log.Fatal("Failed to set groups: ", err)
	}
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
	fmt.Println("Elapsed", elapsed.String())
	return nil
}
