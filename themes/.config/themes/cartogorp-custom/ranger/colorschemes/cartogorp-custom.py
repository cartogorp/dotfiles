from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, reverse, bold, normal, default

# Colors from cartogorp-custom.toml
# text.primary = "#ffffff"
# surface.a0 = "#18131f"
# accent.a0 = "#7e57c2"
# primary.a0 = "#4cb5ab"
# ui.border = "#5c5861"
# ui.selection = "#41948c"
# text.secondary = "#c6c6c6"
# text.muted = "#919191"
# danger.a0 = "#b41c2b"
# success.a0 = "#009f42"
# warning.a0 = "#f0ad4e"

class Cartogorp(ColorScheme):
    progress_bar_color = 6  # cyan

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        # Base text and background
        elif context.in_browser:
            fg = 7  # white, text.primary
            
        if context.selected:
            attr = reverse
            
        # Directory coloring
        if context.directory:
            fg = 6  # cyan (primary.a0)
        elif context.file:
            if context.executable:
                fg = 2  # green (success.a0)
                
        # Link coloring
        elif context.link:
            fg = 5  # magenta (accent.a0)
            
        # Special status coloring
        if context.main_column:
            if context.selected:
                attr |= bold
                fg = 14  # cyan (primary.a0)
                
        # Error status
        if context.bad:
            fg = 1  # red (danger.a0)
            
        # Marked files
        if context.marked:
            attr |= bold
            fg = 3  # yellow (warning.a0)
            
        # Inactive pane
        if context.inactive_pane:
            fg = 8  # gray (text.muted)
            
        # Border
        if context.border:
            fg = 8  # gray (ui.border)
            
        # Media files
        if context.media:
            if context.image:
                fg = 13  # bright magenta
            elif context.video:
                fg = 13  # bright magenta
            elif context.audio:
                fg = 13  # bright magenta
                
        # Document files
        if context.document:
            fg = 15  # bright white
            
        # Container files
        if context.container:
            fg = 9  # bright red
            
        # Special file types
        for ftype in ["fifo", "device", "socket", "char", "block"]:
            if getattr(context, ftype, False):
                fg = 3  # yellow (warning.a0)
                
        # Status bar
        if context.in_statusbar:
            fg = 7  # white (text.primary)
            if context.permissions:
                if context.good:
                    fg = 2  # green (success.a0)
                elif context.bad:
                    fg = 1  # red (danger.a0)
            if context.message:
                if context.good:
                    attr |= bold
                    fg = 2  # green (success.a0)
                elif context.bad:
                    attr |= bold
                    fg = 1  # red (danger.a0)
                    
        # Title bar
        if context.in_titlebar:
            fg = 5  # magenta (accent.a0)
            
            if context.hostname:
                fg = 5  # magenta (accent.a0)
            elif context.directory:
                fg = 6  # cyan (primary.a0)
            elif context.tab:
                if getattr(context, 'good', False):
                    fg = 2  # green (success.a0)
                else:
                    fg = 7  # white (text.primary)
            elif context.link:
                fg = 5  # magenta (accent.a0)
                
        # Tabs
        if context.tab:
            if not context.selected:
                fg = 8  # gray (text.muted)
                
        # Command line
        if context.in_taskview:
            if context.title:
                fg = 5  # magenta (accent.a0)
            if context.selected:
                attr |= reverse
                
        return fg, bg, attr

