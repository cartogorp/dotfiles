import toml
import os
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, TemplateError

# === Configuration ===
theme_name = "cartogorp-custom"
base_path = Path(__file__).parent
palette_file = base_path / f"{theme_name}.toml"
template_dir = base_path / "templates"
output_root = base_path / "generated"
dotfiles_root = Path.home() / ".dotfiles/themes/.config/themes" / theme_name

# Map app names to desired output filenames (with extensions)
apps = {
    "kitty": "theme.conf",
    "waybar": "style.css",
    "zellij": "theme.kdl",
    "wofi": "style.css",
    "ranger": "colorscheme",
    # add more apps and their output files here
}

# === Prepare environment ===
output_root.mkdir(parents=True, exist_ok=True)

try:
    with open(palette_file, "r") as f:
        palette = toml.load(f)
except Exception as e:
    print(f"❌ Failed to load palette TOML: {e}")
    exit(1)

env = Environment(loader=FileSystemLoader(template_dir))

successes = []
errors = []

for app, out_filename in apps.items():
    try:
        # Compose template filename based on app and output extension
        ext = out_filename.split('.')[-1]  # e.g. 'conf', 'css', 'kdl'
        template_name = f"{app}/{app}.{ext}.j2"  # e.g. kitty/kitty.conf.j2

        # Load and render template
        template = env.get_template(template_name)
        rendered = template.render(colours=palette)
    
        # Ensure output directory exists
        app_output_dir = output_root / app
        app_output_dir.mkdir(parents=True, exist_ok=True)
        output_file = app_output_dir / out_filename

        # Write rendered output
        with open(output_file, "w") as f:
            f.write(rendered)

        # Prepare symlink target directory
        target_dir = dotfiles_root / app
        target_dir.mkdir(parents=True, exist_ok=True)
        symlink_path = target_dir / out_filename

        # Remove existing symlink/file and create new symlink
        if symlink_path.exists() or symlink_path.is_symlink():
            symlink_path.unlink()
        symlink_path.symlink_to(output_file.resolve())

        successes.append(f"{app}/{out_filename}")

        print(f"[✓] Generated & linked {app}/{out_filename}")

    except TemplateError as te:
        errors.append(f"{app}: Jinja2 template error: {te}")
    except FileNotFoundError:
        errors.append(f"{app}: Template file not found: {template_name}")
    except Exception as e:
        errors.append(f"{app}: Error during generation or symlink: {e}")

# === Summary ===
print("\n✅ Theme generation complete.")
if successes:
    print("\nGenerated & linked:")
    for s in successes:
        print(f"  ✔ {s}")

if errors:
    print("\n⚠️ Errors encountered:")
    for e in errors:
        print(f"  ✖ {e}")

