import toml
from jinja2 import Environment, FileSystemLoader
from pathlib import Path

# Paths
base_path = Path(__file__).parent
theme_name = "cartogorp-custom"
palette_file = base_path / f"{theme_name}.toml"
template_dir = base_path / "templates"
output_dir = base_path / "generated" / "kitty"

output_dir.mkdir(parents=True, exist_ok=True)

# Load palette
with open(palette_file, "r") as f:
    palette = toml.load(f)

# Jinja environment
env = Environment(loader=FileSystemLoader(template_dir))
template = env.get_template("kitty.conf.j2")

# Render and write
output_path = output_dir / "theme.conf"
output = template.render(**palette)
with open(output_path, "w") as f:
    f.write(output)

def symlink_file(source_path: Path, target_path: Path):
    try:
        if target_path.is_symlink() or target_path.exists():
            target_path.unlink()
        target_path.parent.mkdir(parents=True, exist_ok=True)
        target_path.symlink_to(source_path.resolve())
        print(f"Symlink created: {target_path} -> {source_path}")
    except Exception as e:
        print(f"Failed to create symlink: {e}")

# Example symlink for kitty config
target_kitty_path = Path.home() / ".dotfiles" / "kitty" / ".config" / "kitty" / "theme.conf"
symlink_file(output_path, target_kitty_path)
