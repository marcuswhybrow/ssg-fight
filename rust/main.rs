use tera::Tera;
use tera::Context;
use std::fs;

pub fn main() -> std::io::Result<()> {
    let tera = match Tera::new("templates/**/*.html") {
        Ok(t) => t,
        Err(e) => {
            println!("Parsing error(s): {}", e);
            ::std::process::exit(1);
        }
    };

    let mut context = Context::new();
    context.insert("content", "Hello there!");

    fs::remove_dir_all("build")?;
    fs::create_dir("build")?;
    let file = fs::File::create("build/index.html")?;

    match tera.render_to("base.html", &context, &file) {
        Ok(_) => println!("Rendered to"),
        Err(e) => println!("Error: {}", e)
    };

    Ok(())
}
