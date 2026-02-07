# Gotham-Noir-Ultra colorscheme for Ranger
# Place in ~/.config/ranger/colorschemes/gotham.py
# Then add to rc.conf: set colorscheme gotham

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, reverse, bold, normal


class Gotham(ColorScheme):
    progress_bar_color = 12  # Cyan

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal

            if context.empty or context.error:
                fg = 1  # Red
                bg = 0  # Black

            if context.border:
                fg = default_colors

            if context.media:
                if context.image:
                    fg = 13  # Purple for images
                elif context.video:
                    fg = 11  # Orange for video
                elif context.audio:
                    fg = 14  # Light cyan for audio
                else:
                    fg = 11  # Orange for other media

            if context.container:
                fg = 9  # Pink for archives

            if context.directory:
                attr |= bold
                fg = 12  # Cyan for directories

            elif context.executable and not context.directory:
                attr |= bold
                fg = 10  # Green for executables

            if context.socket:
                fg = 13  # Purple
                attr |= bold

            if context.fifo or context.device:
                fg = 13  # Purple
                if context.device:
                    attr |= bold

            if context.link:
                fg = 14  # Light cyan

            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (1, 9):  # Red or Pink
                    fg = 1
                else:
                    fg = 15  # White

            if not context.selected and (context.cut or context.copied):
                fg = 15  # White
                attr |= bold

            if context.main_column:
                if context.selected:
                    attr |= bold

            if context.marked:
                attr |= bold
                fg = 11  # Yellow

            if context.badinfo:
                if attr & reverse:
                    bg = 9  # Pink
                else:
                    fg = 9  # Pink

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 12 if context.good else 9  # Cyan or Pink
            elif context.directory:
                fg = 12  # Cyan
            elif context.tab:
                if context.good:
                    bg = 4  # Dark blue
            elif context.link:
                fg = 14  # Light cyan

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 10  # Green
                elif context.bad:
                    fg = 9  # Pink
            if context.marked:
                attr |= bold | reverse
                fg = 11  # Yellow
            if context.message:
                if context.good:
                    fg = 10  # Green
                elif context.bad:
                    fg = 9  # Pink

        if context.text:
            if context.highlight:
                attr |= reverse

            if context.separator:
                fg = 8  # Dark grey

            if context.tab:
                attr |= reverse

            if context.selected:
                attr |= reverse

        return fg, bg, attr
