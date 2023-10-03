use std::fs::File;
use std::io::{self, Read, Write};
use std::path::Path;

fn main() -> io::Result<()> {
    let path = Path::new("file1.txt");
    let mut file1 = File::create(&path)?;
    file1.write_all(b"Hello, world!")?;

    let mut file1 = File::open(&path)?;
    let mut contents = String::new();
    file1.read_to_string(&mut contents)?;

    let path2 = Path::new("file2.txt");
    let mut file2 = File::create(&path2)?;
    file2.write_all(contents.as_bytes())?;

    Ok(())
}