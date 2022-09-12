use anyhow::{anyhow, bail, Result};
use std::{env, process::Command, str, thread, time::Duration};

fn main() {
    let args: Vec<String> = env::args().collect();

    let command = if args.len() > 1 {
        Some(args[1].as_ref())
    } else {
        None
    };

    match command {
        Some("test") => command_test(&args[2..]).expect("fail"),
        Some("psql") => command_psql(&args[2..]).expect("fail"),
        Some("flask") => command_flask(&args[2..]).expect("fail"),
        Some("make") => command_make(&args[2..]).expect("fail"),
        _ => command_docker_compose(&args).expect("fail"),
    }
}

fn command_psql(args: &[String]) -> Result<()> {
    let container_name = get_from_git("dc-postgres");
    if container_name == "" {
        bail!("No postgres container name, set with git config --add robyoung.dc-postgres ...")
    }
    let container_id = get_container_id(&container_name)
        .map_err(|_| anyhow!("No postgres container, is it started?"))?;
    let tcols = format!("COLUMNS={}", exec_out(&["tput", "cols"])?);
    let tlines = format!("LINES={}", exec_out(&["tput", "lines"])?);

    let mut all_args = vec!["docker", "exec", "-ti", "--env", &tcols, "--env", &tlines];

    let unix_user = get_from_git("dc-postgres-user");
    if unix_user != "" {
        all_args.extend_from_slice(&["--user", &unix_user]);
    }

    all_args.extend_from_slice(&[&container_id, "psql"]);

    let pg_user = get_from_git("dc-postgres-pguser");
    if pg_user != "" {
        all_args.extend_from_slice(&["--user", &pg_user]);
    }

    let pg_database = get_from_git("dc-postgres-database");
    if pg_database != "" && (args.len() == 0 || args[0].starts_with("-")) {
        all_args.push(&pg_database);
    }

    all_args.extend_from_slice(&args.iter().map(String::as_str).collect::<Vec<&str>>());

    // println!("{:?}", all_args);
    let mut child = Command::new(all_args[0])
        .args(&all_args[1..])
        .spawn()
        .expect("failed to run psql");

    child.wait().expect("failed to wait for child");

    Ok(())
}

fn command_make(args: &[String]) -> Result<()> {
    let container_name = get_from_git("dc-make");
    if container_name == "" {
        bail!("No make container name, set with git config --add robyoung.dc-make ...")
    }
    let mut all_args = vec![String::from("exec"), container_name, String::from("make")];
    all_args.extend_from_slice(&args);

    command_docker_compose(&all_args)
}

fn command_flask(args: &[String]) -> Result<()> {
    let container_name = get_from_git("dc-flask");
    if container_name == "" {
        bail!("No make container name, set with git config --add robyoung.dc-flask ...")
    }
    let mut all_args = vec![String::from("exec"), container_name, String::from("flask")];
    all_args.extend_from_slice(&args);

    command_docker_compose(&all_args)
}

fn command_test(args: &[String]) -> Result<()> {
    let container_name = get_from_git("dc-test");
    if container_name == "" {
        bail!("No make container name, set with git config --add robyoung.dc-test ...")
    }
    let tmp = get_from_git("dc-test-command");
    let test_command = match tmp.as_str() {
        "" => "pytest",
        cmd @ _ => cmd,
    }
    .split(" ");

    let mut all_args = vec!["exec", container_name.as_str()];
    all_args.extend_from_slice(&test_command.collect::<Vec<&str>>());

    command_docker_compose(
        &all_args
            .into_iter()
            .map(str::to_owned)
            .chain(args.iter().map(String::clone))
            .collect::<Vec<String>>(),
    )
}

fn command_docker_compose(args: &[String]) -> Result<()> {
    let mut child = Command::new("docker-compose")
        .args(args)
        .spawn()
        .expect("failed to run docker-compose");

    child.wait().expect("failed to wait for child");

    Ok(())
}

fn get_from_git(name: &str) -> String {
    if let Ok(out) = exec_out(&["git", "config", &format!("robyoung.{}", name)]) {
        String::from(out.trim())
    } else {
        String::from("")
    }
}

fn get_container_id(name: &str) -> Result<String> {
    for _ in 0..5 {
        if let Ok(out) = exec_out(&["docker-compose", "ps", "-q", name]) {
            return Ok(out);
        }
        thread::sleep(Duration::from_millis(10));
    }
    bail!("could not find container id")
}

fn exec_out(args: &[&str]) -> Result<String> {
    Ok(String::from(
        str::from_utf8(
            &Command::new(args[0])
                .args(args[1..].iter())
                .output()?
                .stdout,
        )
        .expect("invalid bytes from command")
        .trim(),
    ))
}
