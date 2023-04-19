# ~/.config/qtile/config.py

import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, Rule
from libqtile.lazy import lazy

# Scripts
mic_tog = '~/.config/qtile/scripts/mic_notify.sh'
autoshell = '~/.config/qtile/autostart.sh'
screenshot_copy = '/.res/script/scropy.sh'
system_manager = 'kitty btop'

# Preferences
gamer_class = ["hl2_linux"]
group_font= 'agave'
nerd_font= 'Hurmit NF'
terminal = 'kitty'
wpaper = '~/.config/qtile/wallpapers/decay_cat_ign_vaporWave.png'		# Must be DIR
wmname = "LG3D" 											# Set LG3D to fix broken java apps
empty_group_str = '(^ᴗ^✿)'

mod = "mod4"												# Meta key
alt = "mod1"												# Alt key

# Layout Stuff
BORDER_NORMAL = '#1A2024'
BORDER_FOCUS = 	'#92f86d'
BORDER_WIDTH = 2
BAR_MARGIN = [0, 0, 10, 0]									# [top, right, bottom, left]
BAR_OPACITY = 0.8
MARGIN = 1
LAYOUT_DEFS = {
	'margin': MARGIN,
	'border_width': BORDER_WIDTH,
	'border_focus': BORDER_FOCUS,
	'border_normal': BORDER_NORMAL,
	}
BAR_HEIGHT = 28

"""
	Colors
"""
WHITE = '#ffffff'
BLACK = '#000000'

JUST_LIKE_THAT_SCHEME = [
	"#3C2A33",
	"#A13A39",
	"#EEBA9E",
	"#FCF1E3",
	"#ecc0db",
	"#68BCB9",
	"#2C5C77",
]

main_scheme = JUST_LIKE_THAT_SCHEME

COLOR_TEXT = main_scheme[3]
COLOR_WIGT_SYSTRY = BLACK
COLOR_WIGT_GB_DRK = main_scheme[6]
COLOR_WIGT_GB_HL = WHITE
COLOR_WIGT_GB_BG = main_scheme[6]
COLOR_WIGT_TRAY = main_scheme[6]
COLOR_WIGT_LAY = main_scheme[5]
COLOR_WIGT_TIME = main_scheme[5]
COLOR_WIGT_GRBX = main_scheme[5]
COLOR_WIGT_SYS = main_scheme[1]
COLOR_WIGT_WN = main_scheme[1]
COLOR_BAR = BLACK

# Widgets
GROUP_BOX = {
	'font': group_font,
	'use_mouse_wheel': True,
	'disable_drag': True,
	'hide_unused': True,
	'urgent_alert_method': 'block',
	'highlight_method': 'line',
	'background': main_scheme[6],
	'inactive': main_scheme[5],
	'highlight_color': main_scheme[6],
	'this_current_screen_border': WHITE
}
MEMORY = {
	'padding':	0,
	'fontsize':	17,
	'format': '{MemUsed: .0f}{mm}'
}
LAUNCHBAR = {
	'font': 'Hurmit NF',
	'fontsize': 28,
	'background': main_scheme[1],
	'progs': [('\uf94f ', 'qshell:self.qtile.cmd_restart()', 'Reset Qtile')]
}
VOLUME = {
	'fontsize': 20,
	'background': main_scheme[6],
	'mouse_callbacks': {'Button3': lazy.spawn('pavucontrol')}
}
PROMPT = {
	'fontsize': 18,
	'background': main_scheme[1],
	'cursor': False
}
WINDOWNAME = {
	'fontsize': 18,
	'background': main_scheme[1],
	'format': '{name}',
	'empty_group_string': empty_group_str
}
KEYBOARDLAYOUT = {
	'fontsize': 20,
	'background': main_scheme[6],
	'display_map': {'us':'En'},
	'configured_keyboards': ['us']
}
TEXTBOX = {
	'font': nerd_font
}

"""
	Groups
"""      
groups = [
	Group("7",					label="\uf74a ",),			# Files
	Group("u", 					label="\uf62d "),			# Side
	Group("8",					label="\uf21b ",			# Intruder
		matches=[Match(wm_class=
				["Opera"])]),			
	Group("i", 					label="\uf6ff ",			# Firefox
		layout='columns',
		matches=[Match(wm_class=
				["firefox","Navigator"])]),
	Group("9",					label="\ue215 ",			# Telegram
		matches=[Match(wm_class=
				["telegram-desktop",
				"TelegramDesktop"])],),		
	Group("o", 					label="\uf1e1 ",			# Social			
		layout='columns',
		matches=[Match(wm_class=
				["discord"])]),	
	Group("0",					label="\uf1b7 ",			# Steam
		matches=[Match(wm_class=["Steam"])]),	
	Group("p", 					label="\uf795 ",			# Gaming
		layout='max',
		matches=[Match(wm_class=gamer_class)],
		),
	Group("minus", 		label="\uf62d "),					# idk
	Group("bracketleft", 		label="\uf68c ",			# Code
		layout="columns",
		matches=[Match(wm_class=["code-oss"])],),
	Group("equal", 		label="\uf5ff ",					# Recording
		matches=[Match(wm_class=["obs"])]),					
	Group("bracketright", 		label="\uf150 ",			# Tray
		layout='floating',
		matches=[Match(wm_class=["spectacle",
				"droidcam","Droidcam"])]),			
]
"""
	Key Bindings
	Run 'xev' to see key names
"""
keys = [ 	 												# Utility
	Key([mod], "Return", lazy.spawn(terminal),				desc="Launch terminal"),
	Key([mod], "r", lazy.spawncmd(), 						desc="Spawn a command in prompt widget"),
															# Window focus bindings
	Key(["control"], "escape", lazy.spawn(system_manager),	desc="Spawn Process Manager"),
    Key([mod], "h", lazy.layout.left(), 					desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), 					desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), 					desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), 						desc="Move focus up"),
    Key([alt], "Tab", lazy.layout.next(),					desc="Switch window focus"),
     														# Audio controls
    Key([mod], "semicolon", lazy.spawn("amixer sset Master 5%+"),		desc="Increase Volume"),
    Key([mod], "slash", lazy.spawn("amixer sset Master 5%-"),			desc="Decrease Volume"),
    Key([mod], "apostrophe", lazy.spawn("amixer sset Master toggle"),	desc="Toggle Volume"),
    Key([mod], "b", lazy.spawn(mic_tog),								desc="Toggle Microphone"),    
      														# Window moving
    Key([mod], "f", lazy.window.toggle_floating(), 			desc="Toggle floating"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), 	desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), 	desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), 	desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), 		desc="Move window up"),
      														# Window resizing
    Key([mod, "control"], "h", lazy.layout.grow_left(), 	desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), 	desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), 	desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), 		desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), 				desc="Reset all window sizes"),
															# Other 
	Key([], "Print", lazy.spawn(screenshot_copy), 			desc="Take a screenshot using Scrot"),															
    Key([mod, "shift"],"Return",lazy.layout.toggle_split(),	desc="Toggle split and unsplit sides of stack",),
    Key([mod], "Space", lazy.next_layout(), 				desc="Toggle between layouts"),
    Key([mod], "Tab", lazy.window.toggle_maximize(), 		desc="Toggle maximize"),
	Key([alt], "Return", lazy.window.toggle_fullscreen(),	desc="Toggle Fullscreen"),
    Key([mod], "w", lazy.window.kill(), 					desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), 		desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), 			desc="Shutdown Qtile"),]
for i in groups: keys.extend([  							# Group Controls
	Key([mod],i.name, lazy.group[i.name].toscreen(),		desc="Switch to group"),
	Key([mod, "shift"],i.name, lazy.window.togroup(i.name,),desc="Move window to group"),])
# Mouse Bindings
mouse = [													
    Drag([mod],"Button1", 									# Move the window
    	lazy.window.set_position_floating(),
    	start=lazy.window.get_position()),
    Drag([mod],"Button3", 									# Resize the window
    	lazy.window.set_size_floating(),
    	start=lazy.window.get_size()),
    Click([mod],"Button2", 									# No idea
    	lazy.window.bring_to_front()),
]

"""
	Layouts
"""
layouts = [
	layout.Columns(**LAYOUT_DEFS),
	#layout.Tile(**LAYOUT_DEFS),
	layout.Max(),
	#layout.RatioTile(**LAYOUT_DEFS),
	layout.Floating(border_width=0)
]

floating_layout = layout.Floating(
	border_width = 0,
	border_focus = BORDER_FOCUS,
	border_normal = BORDER_NORMAL,
	float_rules=[
		#*layout.Floating.default_float_rules,				# Run `xprop` to see the wm class.
		Match(wm_type="utility"),
        Match(wm_type="notification"),
        Match(wm_type="toolbar"),
        Match(wm_type="splash"),
        Match(wm_type="dialog"),							# Breaking apps. Fix later
        Match(wm_class="file_progress"),
        Match(wm_class="confirm"),
        Match(wm_class="dialog"), 							
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="notification"),
        Match(wm_class="splash"),
        Match(wm_class="toolbar"),
        Match(func=lambda c: c.has_fixed_size()),
        Match(func=lambda c: c.has_fixed_ratio()),
		Match(wm_class="pavucontrol"), 						# Pavucontrol for audio
		Match(wm_class="confirmreset"),		  				# gitk
		Match(wm_class="makebranch"),  						# gitk
		Match(wm_class="maketag"),  						# gitk
		Match(wm_class="ssh-askpass"),  					# ssh-askpass
		Match(wm_class="qalculate-qt"),
		Match(title="branchdialog"),  						# gitk
		Match(title="pinentry"),  							# GPG key password entry
		],)

widget_defaults = dict(
    font="ProFontWindows", fontsize= 22,
	foreground=COLOR_TEXT,
    padding=4,
)

screens = [Screen(top=bar.Bar([
	widget.Spacer(length=5,background=COLOR_WIGT_LAY),
	widget.CurrentLayoutIcon(background=COLOR_WIGT_LAY),
	widget.TextBox(**TEXTBOX,text='\ue0b0',fontsize=36,padding=0,foreground=COLOR_WIGT_LAY,background=COLOR_WIGT_GB_BG),
	widget.GroupBox(**GROUP_BOX),	
	widget.WindowCount(background=COLOR_WIGT_GB_BG,show_zero=True),
	widget.TextBox(**TEXTBOX,text='\ue0b0',fontsize=36,padding=0,background=COLOR_WIGT_WN,foreground=COLOR_WIGT_GB_BG),		
	widget.Prompt(**PROMPT),
	#widget.WindowName(**WINDOWNAME),
	widget.TaskList(fontsize=18,borderwidth=0,icon_size=22,title_width_method=None,background=COLOR_WIGT_WN,),
	widget.Spacer(length=-150), 
	widget.TextBox(**TEXTBOX,text='\ue0b0',fontsize=36,padding=0,foreground=COLOR_WIGT_WN),	
	widget.TextBox(**TEXTBOX,text='/',fontsize=22,padding=0,foreground=COLOR_TEXT),
	widget.CPU(fontsize=17,format='{freq_current}GHz {load_percent}%'),
	widget.TextBox(**TEXTBOX,text='/',fontsize=22,padding=0,foreground=COLOR_TEXT),	
	widget.NvidiaSensors(fontsize=17,format='{temp}°C {fan_speed}'),
	widget.TextBox(**TEXTBOX,text='/',fontsize=22,padding=0,foreground=COLOR_TEXT),	
	widget.Memory(**MEMORY),
	widget.TextBox(**TEXTBOX,text=' / ',fontsize=22,padding=0,foreground=COLOR_TEXT),	
	widget.Systray(icon_size=22,background=COLOR_WIGT_SYSTRY,padding=6),
	widget.TextBox(**TEXTBOX,text=' \ue0ba',fontsize=34,padding=0,foreground=COLOR_WIGT_TRAY,background=COLOR_WIGT_SYSTRY),
	widget.KeyboardLayout(**KEYBOARDLAYOUT),
	widget.TextBox(**TEXTBOX,text='/',fontsize=17,padding=0,foreground=COLOR_TEXT,background=COLOR_WIGT_TRAY),	
	widget.TextBox(**TEXTBOX,text='\uf001',fontsize=20,padding=6,background=COLOR_WIGT_TRAY),
	widget.Volume(**VOLUME),
	widget.TextBox(**TEXTBOX,text=' \ue0ba',fontsize=34,padding=0,foreground=COLOR_WIGT_TIME,background=COLOR_WIGT_TRAY),
	widget.Clock(format="%Y-%m-%d %a %H:%M",background=COLOR_WIGT_TIME,fontsize=22,),
	widget.TextBox(**TEXTBOX,text='\ue0bc ',fontsize=34,padding=0,foreground=COLOR_WIGT_TIME,background=COLOR_WIGT_SYS),
	widget.LaunchBar(**LAUNCHBAR),
	],
	BAR_HEIGHT,
	margin = BAR_MARGIN,
	background=COLOR_BAR,						
	opacity=BAR_OPACITY,),									
	wallpaper= wpaper, 									
	wallpaper_mode='fill',
),]

@hook.subscribe.startup_once
def autostart():
    subprocess.run([autoshell])

dgroups_key_binder = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True										# Breaks some apps if not set to True.
auto_minimize = False										# Auto-minimize specific apps when losing focus
reconfigure_screens = True
dgroups_app_rules = []  									# Type: list
focus_on_window_activation = "smart"						# No idea what this is...
wl_input_rules = None										# Can be used to configure input devices in Wayland
