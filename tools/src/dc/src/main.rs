use anyhow::{anyhow, bail, Result};
use std::{env, process::{Command, ExitStatus}, str, thread, time::Duration};

fn main() {
    let args: Vec<String> = env::args().collect();

    let command = if args.len() > 1 {
        Some(args[1].as_ref())
    } else {
        None
    };

    let ecode = match command {
        Some("test") => command_test(&args[2..]).expect("fail"),
        Some("psql") => command_psql(&args[2..]).expect("fail"),
        Some("pgload") => command_pgload(&args[2..]).expect("fail"),
        Some("flask") => command_flask(&args[2..]).expect("fail"),
        Some("make") => command_make(&args[2..]).expect("fail"),
        _ => command_docker_compose(&args[1..]).expect("fail"),
    };

    std::process::exit(ecode.code().unwrap_or(1));

}

fn command_psql(args: &[String]) -> Result<ExitStatus> {
    let mut all_args = vec!["docker", "exec", "-ti"];

    let dimensions = get_terminal_dimensions()?;
    let psql_args = add_psql_connection_args(args)?;

    all_args.extend(dimensions.iter().map(|s| &**s));
    all_args.extend(psql_args.iter().map(String::as_str));
    all_args.extend(args.iter().map(String::as_str));

    // println!("# {:?}", all_args);
    let mut child = Command::new(all_args[0])
        .args(&all_args[1..])
        .spawn()
        .expect("failed to run psql");

    let ecode = child.wait().expect("failed to wait for child");

    Ok(ecode)
}

fn command_pgload(args: &[String]) -> Result<ExitStatus> {
    let mut all_args = vec!["docker", "exec", "-i"];

    let psql_args = add_psql_connection_args(args)?;

    all_args.extend(psql_args.iter().map(String::as_str));
    all_args.extend(args.iter().map(String::as_str));

    let mut child = Command::new(all_args[0])
        .args(&all_args[1..])
        .stdin(std::process::Stdio::inherit())
        .spawn()
        .expect("failed to run pgload");

    let ecode = child.wait().expect("failed to wait for child");

    Ok(ecode)
}

fn add_psql_connection_args(args: &[String]) -> Result<Vec<String>> {
    let mut all_args = Vec::new();
    let unix_user = get_from_git("dc-postgres-user");
    if unix_user != "" {
        all_args.extend_from_slice(&["--user".to_owned(), unix_user]);
    }

    let container_name = get_from_git("dc-postgres");
    if container_name == "" {
        bail!("No postgres container name, set with git config --add robyoung.dc-postgres ...")
    }
    let container_id = get_container_id(&container_name)
        .map_err(|_| anyhow!("No postgres container, is it started?"))?;
    all_args.extend_from_slice(&[container_id, "psql".to_owned()]);

    let pg_user = get_from_git("dc-postgres-pguser");
    if pg_user != "" {
        all_args.extend_from_slice(&["--user".to_owned(), pg_user]);
    }

    let pg_database = get_from_git("dc-postgres-database");
    if pg_database != "" && (args.len() == 0 || args[0].starts_with("-")) {
        all_args.push(pg_database);
    }

    Ok(all_args)
}

fn command_make(args: &[String]) -> Result<ExitStatus> {
    let container_name = get_from_git("dc-make");
    if container_name == "" {
        bail!("No make container name, set with git config --add robyoung.dc-make ...")
    }
    let mut all_args = vec![String::from("exec"), container_name, String::from("make")];
    all_args.extend_from_slice(&args);

    command_docker_compose(&all_args)
}

fn command_flask(args: &[String]) -> Result<ExitStatus> {
    let container_name = get_from_git("dc-flask");
    if container_name == "" {
        bail!("No make container name, set with git config --add robyoung.dc-flask ...")
    }
    let mut all_args = vec![String::from("exec")];
    all_args.extend(get_terminal_dimensions()?);
    all_args.extend_from_slice(&[container_name, String::from("flask")]);
    all_args.extend_from_slice(&args);

    command_docker_compose(&all_args)
}

fn command_test(args: &[String]) -> Result<ExitStatus> {
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

fn command_docker_compose(args: &[String]) -> Result<ExitStatus> {
    // println!("{:?}", args);
    let mut child = Command::new("docker")
        .args([&[String::from("compose")], args].concat())
        .spawn()
        .expect("failed to run docker compose");

    let ecode = child.wait().expect("failed to wait for child");

    Ok(ecode)
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
        if let Ok(out) = exec_out(&["docker", "compose", "ps", "-q", name]) {
            return Ok(out);
        }
        thread::sleep(Duration::from_millis(10));
    }
    bail!("could not find container id")
}

fn get_terminal_dimensions() -> Result<Vec<String>> {
    let tcols = format!("COLUMNS={}", exec_out(&["tput", "cols"])?);
    let tlines = format!("LINES={}", exec_out(&["tput", "lines"])?);
    // println!("{:?}x{:?}", tcols, tlines);

    Ok(vec![
        String::from("--env"),
        tcols,
        String::from("--env"),
        tlines,
    ])
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
