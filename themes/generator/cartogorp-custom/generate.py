import toml
import os
import shutil
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, TemplateError

# === Configuration ===
theme_name = "cartogorp-custom"
base_path = Path(__file__).parent
palette_file = base_path / f"{theme_name}.toml"
template_dir = base_path / "templates"
output_root = base_path / "generated"
dotfiles_root = Path.home() / ".dotfiles/themes/.config/themes" / theme_name

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

# === Process each app ===
for app_dir in template_dir.iterdir():
    if not app_dir.is_dir():
        continue

    app_name = app_dir.name
    try:
        # Create output and target directories
        output_dir = output_root / app_name
        output_dir.mkdir(parents=True, exist_ok=True)

        target_dir = dotfiles_root / app_name
        target_dir.mkdir(parents=True, exist_ok=True)

        # Process each template file
        for template_path in app_dir.glob("*.j2"):
            template_name = template_path.name
            output_name = template_name.replace(".j2", "")
            output_file = output_dir / output_name
            target_link = target_dir / output_name

            try:
                template = env.get_template(f"{app_name}/{template_name}")
                rendered = template.render(**palette)
                with open(output_file, "w") as f:
                    f.write(rendered)

                # Create or update symlink
                if target_link.exists() or target_link.is_symlink():
                    target_link.unlink()
                target_link.symlink_to(output_file.resolve())

                successes.append(f"{app_name}/{output_name}")
            except TemplateError as te:
                errors.append(f"{app_name}/{template_name}: Jinja2 error: {te}")
            except Exception as e:
                errors.append(f"{app_name}/{template_name}: Render error: {e}")
    except Exception as e:
        errors.append(f"{app_name}: Setup error: {e}")

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

