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
output = template.render(**palette)
with open(output_dir / "theme.conf", "w") as f:
    f.write(output)

